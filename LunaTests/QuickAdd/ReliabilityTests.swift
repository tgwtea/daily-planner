import Foundation
import Testing
@testable import Luna

@Suite struct ReliabilityTests {
    private let calendar = TestCalendar.utc
    private var context: QuickAddContext {
        QuickAddContext(now: TestCalendar.date(2026, 10, 31), calendar: calendar)
    }

    @Test(arguments: ["153722867280912931h", "9223372036854775808m", "999999999999999999999h"])
    func durationOverflow(token: String) {
        var draft = QuickAddDraft()
        draft.text = "Work \(token)"
        #expect(draft.issues(context) == [.duration])
        #expect(draft.parsed(context).title.contains(token))
        let store = PlannerStore()
        #expect(store.addQuickAdd(draft, context: context) == nil)
        #expect(store.inboxItems.isEmpty && store.blocks.isEmpty && store.anytimeTasks.isEmpty)
        draft.setDuration(30, context)
        #expect(draft.issues(context).isEmpty)
    }

    @Test func integerBoundariesAndZero() {
        for token in ["\(Int.max)m", "\(Int.max / 60)h", "0m", "0h"] {
            let result = QuickAddParser.parse("Work \(token)", now: context.now, calendar: calendar)
            #expect(result.issues.isEmpty)
        }
        let item = InboxItem(title: "Large", durationMinutes: Int.max, icon: "circle", color: .rose)
        let store = PlannerStore(inboxItems: [item])
        #expect(store.placeInBand(inboxItemID: item.id, band: .morning, now: context.now, schedule: .standard, calendar: calendar) == nil)
        #expect(store.inboxItems.count == 1)
        let block = TestCalendar.task(start: context.now, minutes: Int.max)
        #expect(block.end > block.start)
        var draft = QuickAddDraft()
        draft.text = "Work 0m"
        #expect(draft.destination(context) == .inbox(durationMinutes: 30))
    }

    @Test(arguments: ["9:99am", "11:99pm", "13pm", "999am", "24:00", "99:30", "9:999am", "9:99", "14:30 11:99pm"])
    func invalidTimes(text: String) {
        var draft = QuickAddDraft()
        draft.text = "Work \(text)"
        #expect(draft.issues(context) == [.time])
        #expect(draft.parsed(context).minute == nil)
        #expect(PlannerStore().addQuickAdd(draft, context: context) == nil)
        draft.setTime(minute: 600, context)
        #expect(draft.issues(context).isEmpty)
    }

    @Test(arguments: [("12am", 0), ("12pm", 720), ("11:59pm", 1439), ("00:00", 0)])
    func validTimes(text: String, expected: Int) {
        let result = QuickAddParser.parse("Work \(text)", now: context.now, calendar: calendar)
        #expect(result.minute == expected)
        #expect(result.issues.isEmpty)
    }

    @Test(arguments: ["2024-02-29", "2028-11-06", "2025-10-30"])
    func exactDates(token: String) throws {
        let parsed = QuickAddParser.parse("Work \(token)", now: context.now, calendar: calendar)
        let day = try #require(parsed.day)
        #expect(DayKey(day, calendar: calendar).token == token)
        var draft = QuickAddDraft()
        draft.text = "Work tomorrow"
        draft.setDay(day, context)
        #expect(draft.text == "Work \(token)")
        #expect(draft.day(context) == day)
        #expect(draft.parsed(context).title == "Work")
        #expect(draft.chips(context).first?.title.contains(String(calendar.component(.year, from: day))) == true)
    }

    @Test(arguments: ["2026-02-29", "2026-13-01", "2026-00-01", "0000-01-01"])
    func invalidExactDates(token: String) {
        let parsed = QuickAddParser.parse("Work \(token)", now: context.now, calendar: calendar)
        #expect(parsed.issues == [.date])
        #expect(parsed.title == "Work \(token)")
    }

    @Test func deviceCalendarWithThirteenMonths() throws {
        var hebrew = Calendar(identifier: .hebrew)
        hebrew.timeZone = calendar.timeZone
        let day = try #require(hebrew.date(from: DateComponents(year: 5786, month: 13, day: 1)))
        let context = QuickAddContext(now: self.context.now, calendar: hebrew)
        var draft = QuickAddDraft()
        draft.text = "Work"
        draft.setDay(day, context)
        #expect(draft.day(context) == day)
        #expect(draft.issues(context).isEmpty)
        let named = QuickAddParser.parse("Work nov 6", now: context.now, calendar: hebrew)
        #expect(named.day == TestCalendar.date(2026, 11, 6))
    }

    @Test(arguments: [(3, 8), (11, 1)])
    func clockChangeKeepsWallTime(month: Int, day: Int) throws {
        let ny = TestCalendar.make(timeZone: "America/New_York")
        let start = TestCalendar.date(2026, month, day, calendar: ny)
        let context = QuickAddContext(now: start, calendar: ny)
        var draft = QuickAddDraft()
        draft.text = "Work today 9am"
        guard case .block(let date, let duration) = draft.destination(context) else {
            Issue.record("Expected a block")
            return
        }
        #expect(ny.component(.hour, from: date) == 9)
        #expect(duration == 30)
        let slot = try #require(SlotSearch.firstFreeSlot(durationMinutes: 30, in: .morning, day: start, blocks: [], now: start, schedule: .standard, calendar: ny))
        #expect(ny.component(.hour, from: slot) == 7)
        let tooLate = TestCalendar.date(2026, month, day, 11, 45, calendar: ny)
        #expect(SlotSearch.firstFreeSlot(durationMinutes: 30, in: .morning, day: start, blocks: [], now: tooLate, schedule: .standard, calendar: ny) == nil)
    }

    @Test func nonexistentAndRepeatedTimes() throws {
        let ny = TestCalendar.make(timeZone: "America/New_York")
        let spring = TestCalendar.date(2026, 3, 8, calendar: ny)
        var draft = QuickAddDraft()
        draft.text = "Work 2:30am"
        let context = QuickAddContext(now: spring, calendar: ny)
        #expect(draft.issues(context) == [.nonexistentTime])
        #expect(PlannerStore().addQuickAdd(draft, context: context) == nil)
        #expect(LocalTime.date(minute: 150, on: spring, calendar: ny) == nil)
        let boundary = try #require(LocalTime.boundary(minute: 150, on: spring, calendar: ny))
        #expect(ny.component(.hour, from: boundary) == 3)
        let autumn = TestCalendar.date(2026, 11, 1, calendar: ny)
        let repeated = try #require(LocalTime.date(minute: 90, on: autumn, calendar: ny))
        #expect(repeated.timeIntervalSince(autumn) == 90 * 60)
        #expect(DayLimit.maxDuration(forStart: autumn, calendar: ny) == 1499)
        #expect(DayLimit.maxDuration(forStart: spring, calendar: ny) == 1379)
    }

    @Test func slotNeverStartsInThePast() throws {
        let day = context.now
        let now = day.addingTimeInterval(7 * 3600 + 1)
        let slot = try #require(SlotSearch.firstFreeSlot(durationMinutes: 30, in: .morning, day: day, blocks: [], now: now, schedule: .standard, calendar: calendar))
        #expect(slot == day.addingTimeInterval(7 * 3600 + 15 * 60))
        #expect(SlotSearch.firstFreeSlot(durationMinutes: 30, in: .morning, day: day, blocks: [], now: day.addingTimeInterval(86400), schedule: .standard, calendar: calendar) == nil)
    }

    @Test(arguments: [(false, false), (false, true), (true, false), (true, true)])
    func todayIncludesAnytime(hasBlock: Bool, hasTask: Bool) throws {
        let store = PlannerStore()
        for text in (hasBlock ? ["Work today 9am"] : []) + (hasTask ? ["Buy milk today"] : []) {
            var draft = QuickAddDraft()
            draft.text = text
            #expect(store.addQuickAdd(draft, context: context) != nil)
        }
        let plan = DayPlan.make(
            blocks: store.blocks(on: context.now, calendar: calendar),
            anytimeTasks: store.anytimeTasks(on: context.now, calendar: calendar),
            schedule: .standard, calendar: calendar, showFreeTime: true
        )
        #expect(plan.isEmpty == (!hasBlock && !hasTask))
        #expect(plan.anytimeTasks.count == (hasTask ? 1 : 0))
        #expect(plan.blocks.count == (hasBlock ? 1 : 0))
        if hasTask {
            let task = try #require(plan.anytimeTasks.first)
            store.toggleAnytimeTask(id: task.id, now: context.now)
            #expect(store.anytimeTasks(on: context.now, calendar: calendar).first?.done == true)
        }
    }

    @Test func habitHistorySurvivesTravel() throws {
        let singapore = TestCalendar.make(timeZone: "Asia/Singapore")
        let tokyo = TestCalendar.make(timeZone: "Asia/Tokyo")
        let today = TestCalendar.date(2026, 10, 31, 12, calendar: singapore)
        let habit = Habit(name: "Read", icon: "book", color: .rose, goal: 1, subtitle: "")
        let store = PlannerStore(habits: [habit])
        for offset in [-1, 0] {
            store.logHabit(id: habit.id, on: try #require(singapore.date(byAdding: .day, value: offset, to: today)), calendar: singapore)
        }
        let logged = store.habits[0]
        #expect(logged.value(on: today, calendar: tokyo) == 1)
        #expect(HabitStats.streak([logged], today: today, calendar: tokyo) == 2)
        #expect(HabitStats.bestStreak([logged], today: today, calendar: tokyo) == 2)
        #expect(HabitStats.monthPercent([logged], today: today, calendar: tokyo) == HabitStats.monthPercent([logged], today: today, calendar: singapore))
        #expect(HabitStats.heatmap([logged], today: today, calendar: tokyo) == HabitStats.heatmap([logged], today: today, calendar: singapore))
        store.logHabit(id: habit.id, on: today, calendar: tokyo)
        #expect(store.habits[0].value(on: today, calendar: singapore) == 0)
    }
}
