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

    // MARK: Items

    private func items(_ list: SmartList, _ store: PlannerStore) -> [ListItem] {
        list.items(in: store, today: today, calendar: calendar)
    }

    @Test func upcomingItemsAreInDateOrderWithoutEvents() {
        let later = TestCalendar.task(start: TestCalendar.date(2026, 10, 31, 9), minutes: 30)
        let sooner = TestCalendar.task(start: TestCalendar.date(2026, 10, 30, 15), minutes: 30)
        let event = Block(kind: .event, title: "Standup", start: tomorrow, durationMinutes: 15)
        let dated = task("Tomorrow", day: TestCalendar.date(2026, 10, 30))
        let store = PlannerStore(blocks: [later, event, sooner], anytimeTasks: [dated])
        #expect(items(.upcoming, store).map(\.id) == [dated.id, sooner.id, later.id])
    }

    @Test func anytimeItemsKeepStoreOrder() {
        let first = task("First", day: nil)
        let second = task("Second", day: nil)
        let store = PlannerStore(anytimeTasks: [first, task("Dated", day: tomorrow), task("Done", day: nil, done: true), second])
        #expect(items(.anytime, store).map(\.id) == [first.id, second.id])
    }

    @Test func somedayItemsAreSomedayItems() {
        let item = InboxItem(title: "Learn to juggle", durationMinutes: 20, icon: "circle", color: .sand)
        let store = PlannerStore(inboxItems: [InboxItem(title: "Inbox", durationMinutes: 5, icon: "circle", color: .sand)], somedayItems: [item])
        #expect(items(.someday, store) == [.someday(item)])
    }

    @Test func logbookIsNewestFirstWithUndatedLast() {
        var oldBlock = TestCalendar.task(start: yesterday, minutes: 30)
        oldBlock.done = true
        oldBlock.completedAt = yesterday
        var undated = task("No time", day: nil, done: true)
        undated.completedAt = nil
        var newTask = task("New", day: nil, done: true)
        newTask.completedAt = today
        var event = Block(kind: .event, title: "Standup", start: yesterday, durationMinutes: 15)
        event.completedAt = today
        let open = task("Open", day: nil)
        let store = PlannerStore(blocks: [oldBlock, event], anytimeTasks: [undated, open, newTask])
        #expect(items(.logbook, store).map(\.id) == [newTask.id, oldBlock.id, undated.id])
    }

    @Test func countIsItemCount() {
        let store = PlannerStore.sample()
        for list in [SmartList.upcoming, .anytime, .someday] {
            #expect(count(list, store) == items(list, store).count)
        }
    }
}
