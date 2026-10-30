import Foundation
import Testing
@testable import Luna

@Suite struct PlannerStoreTests {
    private let calendar = TestCalendar.utc
    private let day = TestCalendar.date(2026, 10, 29)

    private func routine(stepsDone: [Bool]) -> Block {
        Block(
            kind: .routine, title: "Morning routine", start: day, durationMinutes: 45,
            icon: "sunrise", color: .rose,
            steps: stepsDone.map { Step(title: "Step", done: $0) }
        )
    }

    @Test func toggleDoneFlipsTask() {
        let task = TestCalendar.task(start: day, minutes: 30)
        let store = PlannerStore(blocks: [task])
        store.toggleDone(blockID: task.id)
        #expect(store.blocks[0].isDone)
        store.toggleDone(blockID: task.id)
        #expect(!store.blocks[0].isDone)
    }

    @Test func toggleDoneOnPartialRoutineCompletesAllSteps() {
        let block = routine(stepsDone: [true, false, false])
        let store = PlannerStore(blocks: [block])
        store.toggleDone(blockID: block.id)
        #expect(store.blocks[0].steps.allSatisfy { $0.done })
        #expect(store.blocks[0].isDone)
    }

    @Test func toggleDoneOnDoneRoutineClearsAllSteps() {
        let block = routine(stepsDone: [true, true])
        let store = PlannerStore(blocks: [block])
        store.toggleDone(blockID: block.id)
        #expect(store.blocks[0].steps.allSatisfy { !$0.done })
    }

    @Test func toggleStepFlipsOneStep() {
        let block = routine(stepsDone: [true, true, false])
        let store = PlannerStore(blocks: [block])
        store.toggleStep(blockID: block.id, stepID: block.steps[2].id)
        #expect(store.blocks[0].isDone)
        #expect(store.blocks[0].done == false)
    }

    @Test func eventCannotBeDone() {
        let event = Block(kind: .event, title: "Standup", start: day, durationMinutes: 15, calendarName: "Work")
        let store = PlannerStore(blocks: [event])
        store.toggleDone(blockID: event.id)
        #expect(store.blocks[0] == event)
        #expect(!store.blocks[0].isDone)
    }

    @Test func toggleAnytimeTaskFlipsDone() {
        let task = AnytimeTask(title: "Reply to Maya", icon: "envelope", color: .slate, day: day)
        let store = PlannerStore(anytimeTasks: [task])
        store.toggleAnytimeTask(id: task.id)
        #expect(store.anytimeTasks[0].done)
    }

    @Test func logHabitAddsOneThenResetsAtGoal() {
        let habit = Habit(name: "Water", icon: "waterbottle", color: .slate, goal: 2, subtitle: "")
        let store = PlannerStore(habits: [habit])
        store.logHabit(id: habit.id, on: day, calendar: calendar)
        #expect(store.habits[0].value(on: day, calendar: calendar) == 1)
        store.logHabit(id: habit.id, on: day.addingTimeInterval(3600), calendar: calendar)
        #expect(store.habits[0].isDone(on: day, calendar: calendar))
        store.logHabit(id: habit.id, on: day, calendar: calendar)
        #expect(store.habits[0].value(on: day, calendar: calendar) == 0)
    }

    @Test func scheduleMovesItemAndKeepsProject() throws {
        let projectID = UUID()
        let item = InboxItem(title: "Call the dentist", durationMinutes: 15, icon: "phone", color: .rose, projectID: projectID)
        let store = PlannerStore(inboxItems: [item])
        let start = TestCalendar.date(2026, 10, 29, 10, 30)

        #expect(store.schedule(inboxItemID: item.id, at: start, calendar: calendar))

        #expect(store.inboxItems.isEmpty)
        let block = try #require(store.blocks.first)
        #expect(block.kind == .task)
        #expect(block.title == "Call the dentist")
        #expect(block.start == start)
        #expect(block.durationMinutes == 15)
        #expect(block.icon == "phone")
        #expect(block.color == .rose)
        #expect(block.projectID == projectID)
    }

    @Test func scheduleLateClampsToDayEnd() {
        let item = InboxItem(title: "Draft", durationMinutes: 60, icon: "doc.text", color: .slate)
        let store = PlannerStore(inboxItems: [item])
        #expect(store.schedule(inboxItemID: item.id, at: TestCalendar.date(2026, 10, 29, 23, 30), calendar: calendar))
        #expect(store.blocks[0].durationMinutes == 29)
        #expect(store.blocks[0].fitsDay(calendar: calendar))
    }

    @Test func scheduleAt2359FailsAndKeepsItem() {
        let item = InboxItem(title: "Draft", durationMinutes: 60, icon: "doc.text", color: .slate)
        let store = PlannerStore(inboxItems: [item])
        #expect(!store.schedule(inboxItemID: item.id, at: TestCalendar.date(2026, 10, 29, 23, 59), calendar: calendar))
        #expect(store.inboxItems == [item])
        #expect(store.blocks.isEmpty)
    }

    @Test func blocksOnDayAreSortedAndFiltered() {
        let late = TestCalendar.task(start: TestCalendar.date(2026, 10, 29, 15, 0), minutes: 30)
        let early = TestCalendar.task(start: TestCalendar.date(2026, 10, 29, 9, 0), minutes: 30)
        let other = TestCalendar.task(start: TestCalendar.date(2026, 10, 30, 9, 0), minutes: 30)
        let store = PlannerStore(blocks: [late, other, early])
        #expect(store.blocks(on: day, calendar: calendar).map(\.id) == [early.id, late.id])
    }
}
