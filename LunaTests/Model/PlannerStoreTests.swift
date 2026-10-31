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
        store.toggleDone(blockID: task.id, now: day)
        #expect(store.blocks[0].isDone)
        store.toggleDone(blockID: task.id, now: day)
        #expect(!store.blocks[0].isDone)
    }

    @Test func toggleDoneOnPartialRoutineCompletesAllSteps() {
        let block = routine(stepsDone: [true, false, false])
        let store = PlannerStore(blocks: [block])
        store.toggleDone(blockID: block.id, now: day)
        #expect(store.blocks[0].steps.allSatisfy { $0.done })
        #expect(store.blocks[0].isDone)
    }

    @Test func toggleDoneOnDoneRoutineClearsAllSteps() {
        let block = routine(stepsDone: [true, true])
        let store = PlannerStore(blocks: [block])
        store.toggleDone(blockID: block.id, now: day)
        #expect(store.blocks[0].steps.allSatisfy { !$0.done })
    }

    @Test func toggleStepFlipsOneStep() {
        let block = routine(stepsDone: [true, true, false])
        let store = PlannerStore(blocks: [block])
        store.toggleStep(blockID: block.id, stepID: block.steps[2].id, now: day)
        #expect(store.blocks[0].isDone)
        #expect(store.blocks[0].done == false)
    }

    @Test func eventCannotBeDone() {
        let event = Block(kind: .event, title: "Standup", start: day, durationMinutes: 15, calendarName: "Work")
        let store = PlannerStore(blocks: [event])
        store.toggleDone(blockID: event.id, now: day)
        #expect(store.blocks[0] == event)
        #expect(!store.blocks[0].isDone)
    }

    @Test func toggleAnytimeTaskFlipsDone() {
        let task = AnytimeTask(title: "Reply to Maya", icon: "envelope", color: .slate, day: day)
        let store = PlannerStore(anytimeTasks: [task])
        store.toggleAnytimeTask(id: task.id, now: day)
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

    // MARK: Inbox

    private func inboxItem(_ title: String, minutes: Int = 30) -> InboxItem {
        InboxItem(title: title, durationMinutes: minutes, icon: "phone", color: .rose, projectID: UUID())
    }

    @Test func placeInBandSchedulesAtFirstFreeSlot() throws {
        let item = inboxItem("Call the dentist")
        let busy = TestCalendar.task(start: TestCalendar.date(2026, 10, 29, 10, 30), minutes: 30)
        let store = PlannerStore(blocks: [busy], inboxItems: [item])
        let now = TestCalendar.date(2026, 10, 29, 10, 20)
        let start = store.placeInBand(inboxItemID: item.id, band: .morning, now: now, schedule: .standard, calendar: calendar)
        #expect(start == TestCalendar.date(2026, 10, 29, 11))
        #expect(store.inboxItems.isEmpty)
        let block = try #require(store.blocks.first { $0.title == "Call the dentist" })
        #expect(block.start == start)
        #expect(block.projectID == item.projectID)
    }

    @Test func placeInBandWithNoFitKeepsItem() {
        let item = inboxItem("Draft review", minutes: 60)
        let store = PlannerStore(inboxItems: [item])
        let now = TestCalendar.date(2026, 10, 29, 11, 20)
        #expect(store.placeInBand(inboxItemID: item.id, band: .morning, now: now, schedule: .standard, calendar: calendar) == nil)
        #expect(store.inboxItems == [item])
        #expect(store.blocks.isEmpty)
    }

    @Test func renameInboxItemTrimsAndIgnoresEmpty() {
        let item = inboxItem("Call")
        let store = PlannerStore(inboxItems: [item])
        store.renameInboxItem(id: item.id, title: "  Call the dentist ")
        #expect(store.inboxItems[0].title == "Call the dentist")
        store.renameInboxItem(id: item.id, title: "   ")
        #expect(store.inboxItems[0].title == "Call the dentist")
    }

    @Test func deleteInboxItemRemovesIt() {
        let first = inboxItem("A")
        let second = inboxItem("B")
        let store = PlannerStore(inboxItems: [first, second])
        store.deleteInboxItem(id: first.id)
        #expect(store.inboxItems == [second])
    }

    @Test(arguments: [
        (IndexSet([0]), 3, ["B", "C", "A", "D"]),
        (IndexSet([3]), 0, ["D", "A", "B", "C"]),
        (IndexSet([0, 2]), 4, ["B", "D", "A", "C"]),
        (IndexSet([1]), 1, ["A", "B", "C", "D"]),
    ])
    func moveInboxItemsMatchesListOnMove(source: IndexSet, destination: Int, expected: [String]) {
        let store = PlannerStore(inboxItems: ["A", "B", "C", "D"].map { inboxItem($0) })
        store.moveInboxItems(fromOffsets: source, toOffset: destination)
        #expect(store.inboxItems.map(\.title) == expected)
    }

    // MARK: Habit management

    private func draft(_ name: String, goal: Int = 1, weekdays: Set<Weekday> = Set(Weekday.allCases)) -> HabitDraft {
        var draft = HabitDraft()
        draft.name = name
        draft.goal = goal
        draft.weekdays = weekdays
        return draft
    }

    @Test func addHabitAppendsValidDraft() {
        let store = PlannerStore()
        let id = store.addHabit(draft("  Read  ", goal: 2, weekdays: [.monday]))
        #expect(store.habits.map(\.id) == [id])
        #expect(store.habits[0].name == "Read")
        #expect(store.habits[0].goal == 2)
        #expect(store.habits[0].weekdays == [.monday])
    }

    @Test func addHabitRejectsInvalidDraft() {
        let store = PlannerStore()
        #expect(store.addHabit(draft("   ")) == nil)
        #expect(store.addHabit(draft("Read", weekdays: [])) == nil)
        #expect(store.addHabit(draft("Read", goal: 0)) == nil)
        #expect(store.habits.isEmpty)
    }

    @Test func updateHabitKeepsIDAndHistory() {
        let habit = Habit(name: "Water", icon: "waterbottle", color: .slate, goal: 8, subtitle: "", history: [day: 3])
        let store = PlannerStore(habits: [habit])
        var edit = HabitDraft(habit: habit)
        edit.name = "Tea"
        edit.weekdays = [.saturday]
        store.updateHabit(id: habit.id, draft: edit)
        #expect(store.habits[0].id == habit.id)
        #expect(store.habits[0].name == "Tea")
        #expect(store.habits[0].weekdays == [.saturday])
        #expect(store.habits[0].history == [day: 3])
        edit.name = ""
        store.updateHabit(id: habit.id, draft: edit)
        #expect(store.habits[0].name == "Tea")
    }

    @Test func archiveRestoreAndDeleteHabit() {
        let names = ["A", "B", "C"].map { Habit(name: $0, icon: "circle", color: .rose, goal: 1, subtitle: "", history: [day: 1]) }
        let store = PlannerStore(habits: names)
        store.archiveHabit(id: names[0].id)
        #expect(store.habits.map(\.name) == ["B", "C"])
        #expect(store.archivedHabits.map(\.name) == ["A"])
        #expect(store.archivedHabits[0].history == [day: 1])
        store.restoreHabit(id: names[0].id)
        #expect(store.habits.map(\.name) == ["B", "C", "A"])
        #expect(store.archivedHabits.isEmpty)
        store.archiveHabit(id: names[1].id)
        store.deleteArchivedHabit(id: names[1].id)
        #expect(store.habits.map(\.name) == ["C", "A"])
        #expect(store.archivedHabits.isEmpty)
    }

    @Test(arguments: [
        (IndexSet([0]), 3, ["B", "C", "A", "D"]),
        (IndexSet([3]), 0, ["D", "A", "B", "C"]),
    ])
    func moveHabitsMatchesListOnMove(source: IndexSet, destination: Int, expected: [String]) {
        let store = PlannerStore(habits: ["A", "B", "C", "D"].map {
            Habit(name: $0, icon: "circle", color: .rose, goal: 1, subtitle: "")
        })
        store.moveHabits(fromOffsets: source, toOffset: destination)
        #expect(store.habits.map(\.name) == expected)
    }

    // MARK: Completion time

    private let later = TestCalendar.date(2026, 10, 29, 14)

    @Test func toggleDoneSetsAndClearsCompletedAt() {
        let task = TestCalendar.task(start: day, minutes: 30)
        let store = PlannerStore(blocks: [task])
        store.toggleDone(blockID: task.id, now: later)
        #expect(store.blocks[0].completedAt == later)
        store.toggleDone(blockID: task.id, now: later)
        #expect(store.blocks[0].completedAt == nil)
    }

    @Test func routineGetsCompletedAtFromToggleAndFromLastStep() {
        let block = routine(stepsDone: [true, false])
        let store = PlannerStore(blocks: [block])
        store.toggleDone(blockID: block.id, now: later)
        #expect(store.blocks[0].completedAt == later)
        store.toggleStep(blockID: block.id, stepID: block.steps[1].id, now: later)
        #expect(store.blocks[0].completedAt == nil)
        store.toggleStep(blockID: block.id, stepID: block.steps[1].id, now: day)
        #expect(store.blocks[0].completedAt == day)
    }

    @Test func stepOfOpenRoutineLeavesCompletedAtNil() {
        let block = routine(stepsDone: [false, false])
        let store = PlannerStore(blocks: [block])
        store.toggleStep(blockID: block.id, stepID: block.steps[0].id, now: later)
        #expect(store.blocks[0].completedAt == nil)
    }

    @Test func toggleAnytimeTaskSetsAndClearsCompletedAt() {
        let task = AnytimeTask(title: "Reply to Maya", icon: "envelope", color: .slate)
        let store = PlannerStore(anytimeTasks: [task])
        store.toggleAnytimeTask(id: task.id, now: later)
        #expect(store.anytimeTasks[0].completedAt == later)
        store.toggleAnytimeTask(id: task.id, now: later)
        #expect(store.anytimeTasks[0].completedAt == nil)
    }

    // MARK: Projects and areas

    @Test func addProjectTrimsAndAppends() throws {
        let areaID = UUID()
        let store = PlannerStore()
        let id = try #require(store.addProject(name: "  Garden ", color: .sage, areaID: areaID))
        #expect(store.projects.count == 1)
        #expect(store.projects[0].id == id)
        #expect(store.projects[0].name == "Garden")
        #expect(store.projects[0].color == .sage)
        #expect(store.projects[0].areaID == areaID)
        #expect(store.projects[0].timing == .noDate)
    }

    @Test func addProjectIgnoresEmptyName() {
        let store = PlannerStore()
        #expect(store.addProject(name: "   ", color: .rose, areaID: nil) == nil)
        #expect(store.projects.isEmpty)
    }

    @Test func addAreaTrimsAndIgnoresEmptyName() throws {
        let store = PlannerStore()
        #expect(store.addArea(name: "", icon: "house") == nil)
        let id = try #require(store.addArea(name: " Family ", icon: "heart"))
        #expect(store.areas == [Area(id: id, name: "Family", icon: "heart")])
    }

    @Test func addAnytimeTaskUsesProjectColorAndNoDay() {
        let project = Project(name: "Home", color: .plum)
        let store = PlannerStore(projects: [project])
        store.addAnytimeTask(title: " Fix the tap ", projectID: project.id)
        store.addAnytimeTask(title: " ", projectID: project.id)
        store.addAnytimeTask(title: "Unknown project", projectID: UUID())
        #expect(store.anytimeTasks.count == 1)
        #expect(store.anytimeTasks[0].title == "Fix the tap")
        #expect(store.anytimeTasks[0].color == .plum)
        #expect(store.anytimeTasks[0].day == nil)
        #expect(store.anytimeTasks[0].projectID == project.id)
        #expect(!store.anytimeTasks[0].done)
    }

    @Test func setNotesChangesProject() {
        let project = Project(name: "Home", color: .plum)
        let store = PlannerStore(projects: [project])
        store.setNotes(projectID: project.id, notes: "Spring list")
        #expect(store.projects[0].notes == "Spring list")
    }
}
