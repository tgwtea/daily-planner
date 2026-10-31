import Foundation
import Testing
@testable import Luna

@Suite struct SmartListTests {
    private let calendar = TestCalendar.utc
    private let today = TestCalendar.date(2026, 10, 29, 10, 20)
    private let tomorrow = TestCalendar.date(2026, 10, 30, 9)
    private let yesterday = TestCalendar.date(2026, 10, 28, 9)

    private func count(_ list: SmartList, _ store: PlannerStore) -> Int? {
        list.count(in: store, today: today, calendar: calendar)
    }

    private func task(_ title: String, day: Date?, done: Bool = false) -> AnytimeTask {
        AnytimeTask(title: title, icon: "circle", color: .sage, done: done, day: day)
    }

    @Test func upcomingCountsOpenBlocksAfterToday() {
        var done = TestCalendar.task(start: tomorrow, minutes: 30)
        done.done = true
        let event = Block(kind: .event, title: "Standup", start: tomorrow, durationMinutes: 15)
        let store = PlannerStore(blocks: [
            TestCalendar.task(start: tomorrow, minutes: 30),
            TestCalendar.task(start: TestCalendar.date(2026, 10, 29, 23), minutes: 30),
            TestCalendar.task(start: yesterday, minutes: 30),
            done,
            event,
        ])
        #expect(count(.upcoming, store) == 1)
    }

    @Test func upcomingCountsOpenDatedAnytimeTasksAfterToday() {
        let store = PlannerStore(anytimeTasks: [
            task("Tomorrow", day: tomorrow),
            task("Done tomorrow", day: tomorrow, done: true),
            task("Today", day: today),
            task("No day", day: nil),
        ])
        #expect(count(.upcoming, store) == 1)
    }

    @Test func anytimeCountsOpenTasksWithNoDay() {
        let store = PlannerStore(anytimeTasks: [
            task("Open", day: nil),
            task("Done", day: nil, done: true),
            task("Dated", day: tomorrow),
        ])
        #expect(count(.anytime, store) == 1)
    }

    @Test func somedayCountsSomedayItems() {
        let item = InboxItem(title: "Learn to juggle", durationMinutes: 20, icon: "circle", color: .sand)
        let store = PlannerStore(inboxItems: [item], somedayItems: [item, item])
        #expect(count(.someday, store) == 2)
    }

    @Test func logbookHasNoCount() {
        #expect(count(.logbook, PlannerStore()) == nil)
    }

    @Test func orderMatchesMockup() {
        #expect(SmartList.allCases.map(\.title) == ["Upcoming", "Anytime", "Someday", "Logbook"])
    }
}
