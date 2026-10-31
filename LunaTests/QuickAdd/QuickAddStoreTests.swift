import Foundation
import Testing
@testable import Luna

@Suite struct QuickAddStoreTests {
    private let now = TestCalendar.date(2026, 10, 29, 10, 20)
    private let context = QuickAddContext(now: TestCalendar.date(2026, 10, 29, 10, 20), calendar: TestCalendar.utc)

    private func draft(_ text: String) -> QuickAddDraft {
        var draft = QuickAddDraft()
        draft.text = text
        draft.color = .sage
        draft.icon = "dumbbell"
        return draft
    }

    @Test func timeAddsTaskBlock() throws {
        let store = PlannerStore()
        let result = store.addQuickAdd(draft("Gym tomorrow 7am 45m"), context: context)
        let block = try #require(store.blocks.first)
        #expect(result == .block(block.id, start: TestCalendar.date(2026, 10, 30, 7)))
        #expect(block.kind == .task)
        #expect(block.title == "Gym")
        #expect(block.durationMinutes == 45)
        #expect(block.color == .sage)
        #expect(block.icon == "dumbbell")
        #expect(block.repeatRule == .never)
    }

    @Test func blockKeepsStepsAndRepeatRule() throws {
        let store = PlannerStore()
        var draft = draft("Morning routine 7am")
        draft.steps = ["Stretch", "", "Water"]
        draft.repeatRule = .weekdays
        store.addQuickAdd(draft, context: context)
        let block = try #require(store.blocks.first)
        #expect(block.kind == .routine)
        #expect(block.isRoutine)
        #expect(block.steps.map(\.title) == ["Stretch", "Water"])
        #expect(block.repeatRule == .weekdays)
    }

    @Test func dayWordAddsAnytimeTask() throws {
        let store = PlannerStore()
        var draft = draft("Pay rent tomorrow")
        draft.steps = ["Ignored"]
        let result = store.addQuickAdd(draft, context: context)
        let task = try #require(store.anytimeTasks.first)
        #expect(result == .anytime(task.id))
        #expect(task.title == "Pay rent")
        #expect(task.day == TestCalendar.date(2026, 10, 30))
        #expect(store.blocks.isEmpty)
    }

    @Test func noTimeAddsToTopOfInbox() throws {
        let old = InboxItem(title: "Old", durationMinutes: 30, icon: "phone", color: .rose)
        let store = PlannerStore(inboxItems: [old])
        let result = store.addQuickAdd(draft("Buy milk 15m"), context: context)
        let item = try #require(store.inboxItems.first)
        #expect(result == .inbox(item.id))
        #expect(store.inboxItems.map(\.title) == ["Buy milk", "Old"])
        #expect(item.durationMinutes == 15)
        #expect(item.projectID == nil)
    }

    @Test(arguments: ["", "   ", "tomorrow 9am 15m"])
    func emptyTitleAddsNothing(text: String) {
        let store = PlannerStore()
        #expect(store.addQuickAdd(draft(text), context: context) == nil)
        #expect(store.blocks.isEmpty)
        #expect(store.anytimeTasks.isEmpty)
        #expect(store.inboxItems.isEmpty)
    }
}
