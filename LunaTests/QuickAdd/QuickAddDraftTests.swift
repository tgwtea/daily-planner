import Foundation
import Testing
@testable import Luna

@Suite struct QuickAddDraftTests {
    /// Thursday, October 29, 2026, 10:20 AM.
    private let now = TestCalendar.date(2026, 10, 29, 10, 20)

    private var context: QuickAddContext {
        var calendar = TestCalendar.utc
        calendar.locale = Locale(identifier: "en_US")
        return QuickAddContext(now: now, calendar: calendar)
    }

    private func at(_ day: Int, _ hour: Int, _ minute: Int = 0) -> Date {
        TestCalendar.date(2026, 10, day, hour, minute)
    }

    private func draft(_ text: String, prefill: QuickAddPrefill = .none) -> QuickAddDraft {
        var draft = QuickAddDraft()
        draft.text = text
        draft.prefill = prefill
        return draft
    }

    // MARK: Destination

    @Test func timeGivesBlockWithDefaultDuration() {
        #expect(draft("Gym 7pm").destination(context) == .block(start: at(29, 19), durationMinutes: 30))
    }

    @Test func dentistExampleGivesTomorrowBlock() {
        #expect(draft("Call the dentist tomorrow 9am 15m").destination(context) == .block(start: at(30, 9), durationMinutes: 15))
    }

    @Test func dayWordWithoutTimeGivesAnytime() {
        #expect(draft("Pay rent tomorrow").destination(context) == .anytime(day: at(30, 0)))
    }

    @Test func noDayNoTimeGivesInbox() {
        #expect(draft("Buy milk").destination(context) == .inbox(durationMinutes: 30))
        #expect(draft("Buy milk 15m").destination(context) == .inbox(durationMinutes: 15))
    }

    @Test func blockEndsAt1159PM() {
        #expect(draft("Late 11pm 2h").destination(context) == .block(start: at(29, 23), durationMinutes: 59))
    }

    @Test func startAt1159PMGivesAnytime() {
        #expect(draft("Late 11:59pm").destination(context) == .anytime(day: at(29, 0)))
    }

    // MARK: Pre-fill

    @Test func bandPrefillGivesBlock() {
        #expect(draft("Write", prefill: .time(at(29, 14))).destination(context) == .block(start: at(29, 14), durationMinutes: 30))
    }

    @Test func textTimeWinsOverPrefill() {
        let result = draft("Write 4pm", prefill: .time(at(29, 14))).destination(context)
        #expect(result == .block(start: at(29, 16), durationMinutes: 30))
    }

    @Test func textDayKeepsPrefillTime() {
        let result = draft("Write tomorrow", prefill: .time(at(29, 14))).destination(context)
        #expect(result == .block(start: at(30, 14), durationMinutes: 30))
    }

    @Test func anytimePrefillGivesAnytime() {
        #expect(draft("Water plants", prefill: .anytime(day: at(31, 0))).destination(context) == .anytime(day: at(31, 0)))
    }

    @Test func anytimePrefillWithTimeGivesBlockOnThatDay() {
        let result = draft("Water plants 8am", prefill: .anytime(day: at(31, 0))).destination(context)
        #expect(result == .block(start: at(31, 8), durationMinutes: 30))
    }

    @Test func bandPrefillUsesFirstFreeSlot() {
        let busy = TestCalendar.task(start: at(29, 12), minutes: 60)
        let prefill = QuickAddPrefill.band(.afternoon, day: now, blocks: [busy], now: now, schedule: .standard, calendar: context.calendar)
        #expect(prefill == .time(at(29, 13)))
    }

    @Test func fullBandPrefillUsesBandStart() {
        // The Morning band of today is full: 10:30 AM to noon is busy.
        let busy = TestCalendar.task(start: at(29, 10, 30), minutes: 90)
        let prefill = QuickAddPrefill.band(.morning, day: now, blocks: [busy], now: now, schedule: .standard, calendar: context.calendar)
        #expect(prefill == .time(at(29, 6)))
    }

    // MARK: Picker edits

    @Test func setTimeReplacesTheToken() {
        var draft = draft("Gym 7am 45m")
        draft.setTime(minute: 18 * 60 + 15, context)
        #expect(draft.text == "Gym 6:15pm 45m")
    }

    @Test func setTimeAddsATokenAtTheEnd() {
        var draft = draft("Gym")
        draft.setTime(minute: 9 * 60, context)
        #expect(draft.text == "Gym 9:00am ")
        #expect(draft.minute(context) == 9 * 60)
        #expect(draft.parsed(context).title == "Gym")
    }

    @Test func setDayWritesExactDates() {
        var draft = draft("Gym tomorrow")
        draft.setDay(at(29, 0), context)
        #expect(draft.text == "Gym 2026-10-29")
        draft.setDay(at(30, 0), context)
        #expect(draft.text == "Gym 2026-10-30")
        draft.setDay(TestCalendar.date(2026, 11, 6), context)
        #expect(draft.text == "Gym 2026-11-06")
        #expect(draft.day(context) == TestCalendar.date(2026, 11, 6))
    }

    @Test func setDurationWritesMinutesOrHours() {
        var draft = draft("Read 15m")
        draft.setDuration(45, context)
        #expect(draft.text == "Read 45m")
        draft.setDuration(120, context)
        #expect(draft.text == "Read 2h")
        #expect(draft.parsed(context).durationMinutes == 120)
    }

    @Test func pickerOnEmptyTextLeavesRoomForTitle() {
        var draft = draft("")
        draft.setDuration(30, context)
        draft.text += "Stretch"
        #expect(draft.parsed(context).title == "Stretch")
        #expect(draft.parsed(context).durationMinutes == 30)
    }

    // MARK: Chips

    @Test func dentistChips() {
        let chips = draft("Call the dentist tomorrow 9am 15m").chips(context)
        // The system time format uses a narrow no-break space before AM.
        let titles = chips.map { $0.title.replacingOccurrences(of: "\u{202F}", with: " ") }
        #expect(titles == ["Tomorrow", "9:00 AM", "Morning", "15 min", "Rose"])
        #expect(chips.last?.accessibilityLabel == "Color, Rose")
        #expect(chips.last?.dot == .rose)
    }

    @Test func noTimeChipShowsInboxOrAnytime() {
        #expect(draft("Buy milk").chips(context).map(\.title) == ["Inbox", "Rose"])
        #expect(draft("Buy milk today").chips(context).map(\.title) == ["Today", "Anytime", "Rose"])
    }

    @Test func otherDayChipShowsShortDate() {
        let chips = draft("Trip nov 6").chips(context)
        #expect(chips.first?.title == "Fri, Nov 6")
    }

    @Test func repeatAndChecklistChipsShowOnlyForBlocks() {
        var block = draft("Routine 7am")
        block.repeatRule = .weekdays
        block.steps = ["Stretch", " ", "Water"]
        #expect(block.chips(context).map(\.kind) == [.time, .band, .repeatRule, .checklist, .color])
        #expect(block.chips(context).first { $0.kind == .checklist }?.title == "2 steps")

        var inbox = draft("Routine")
        inbox.repeatRule = .weekdays
        inbox.steps = ["Stretch"]
        #expect(inbox.chips(context).map(\.kind) == [.destination, .color])
    }

    // MARK: Cycles

    @Test func colorCycleFollowsPickerOrder() {
        var color = BlockColor.rose
        var seen: [BlockColor] = []
        for _ in 0..<5 {
            color = color.next
            seen.append(color)
        }
        #expect(seen == [.slate, .sage, .sand, .plum, .rose])
    }

    @Test func iconCycleWrapsAround() {
        #expect(BlockIcons.all.count == 12)
        #expect(BlockIcons.next(after: "phone") == "basket")
        #expect(BlockIcons.next(after: "airplane") == "laptopcomputer")
        #expect(BlockIcons.next(after: "unknown") == "laptopcomputer")
    }
}
