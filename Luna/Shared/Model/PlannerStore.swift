import Foundation
import Observation

/// The one in-memory store for blocks, tasks, habits, and projects.
/// Views read its arrays and call its intents. Roadmap 2.1 replaces only its storage.
@Observable
final class PlannerStore {
    var blocks: [Block]
    var anytimeTasks: [AnytimeTask]
    var inboxItems: [InboxItem]
    /// Inbox items that the user set aside for later. They do not show in the Inbox.
    var somedayItems: [InboxItem]
    /// The habits that the Habits tab and Today show, in the user's order.
    var habits: [Habit]
    /// Habits that the user archived. They keep their history and do not show on Habits or Today.
    var archivedHabits: [Habit]
    var areas: [Area]
    var projects: [Project]

    init(
        blocks: [Block] = [],
        anytimeTasks: [AnytimeTask] = [],
        inboxItems: [InboxItem] = [],
        somedayItems: [InboxItem] = [],
        habits: [Habit] = [],
        archivedHabits: [Habit] = [],
        areas: [Area] = [],
        projects: [Project] = []
    ) {
        self.blocks = blocks
        self.anytimeTasks = anytimeTasks
        self.inboxItems = inboxItems
        self.somedayItems = somedayItems
        self.habits = habits
        self.archivedHabits = archivedHabits
        self.areas = areas
        self.projects = projects
    }

    // MARK: Queries

    /// The blocks of one day, in start order.
    func blocks(on day: Date, calendar: Calendar) -> [Block] {
        blocks
            .filter { calendar.isDate($0.start, inSameDayAs: day) }
            .sorted { $0.start < $1.start }
    }

    func anytimeTasks(on day: Date, calendar: Calendar) -> [AnytimeTask] {
        anytimeTasks.filter { task in
            task.day.map { calendar.isDate($0, inSameDayAs: day) } ?? false
        }
    }

    /// The projects of one area in store order. `nil` gives the projects with no area.
    func projects(inArea areaID: Area.ID?) -> [Project] {
        projects.filter { $0.areaID == areaID }
    }

    // MARK: Intents

    /// Toggles a task. For a routine, sets every step to done, or every step to not done when all are done.
    /// An event does not change. `now` becomes the completion time of a block that becomes done.
    func toggleDone(blockID: Block.ID, now: Date) {
        guard let index = blocks.firstIndex(where: { $0.id == blockID }) else { return }
        var block = blocks[index]
        switch block.kind {
        case .event:
            return
        case .routine where block.isRoutine:
            let newValue = !block.isDone
            for stepIndex in block.steps.indices {
                block.steps[stepIndex].done = newValue
            }
        default:
            block.done.toggle()
        }
        block.completedAt = block.isDone ? now : nil
        blocks[index] = block
    }

    /// Toggles one step. A routine gets a completion time when its last step becomes done.
    func toggleStep(blockID: Block.ID, stepID: Step.ID, now: Date) {
        guard let index = blocks.firstIndex(where: { $0.id == blockID }),
              let stepIndex = blocks[index].steps.firstIndex(where: { $0.id == stepID })
        else { return }
        blocks[index].steps[stepIndex].done.toggle()
        blocks[index].completedAt = blocks[index].isDone ? now : nil
    }

    func toggleAnytimeTask(id: AnytimeTask.ID, now: Date) {
        guard let index = anytimeTasks.firstIndex(where: { $0.id == id }) else { return }
        anytimeTasks[index].done.toggle()
        anytimeTasks[index].completedAt = anytimeTasks[index].done ? now : nil
    }

    /// Adds one to the habit count of the day. At the goal, the count goes back to zero.
    func logHabit(id: Habit.ID, on day: Date, calendar: Calendar) {
        guard let index = habits.firstIndex(where: { $0.id == id }) else { return }
        let key = calendar.startOfDay(for: day)
        let value = habits[index].history[key] ?? 0
        habits[index].history[key] = value >= habits[index].goal ? nil : value + 1
    }

    /// Adds a habit at the end. A draft that is not valid adds nothing.
    /// - Returns: the ID of the new habit, or `nil` for a draft that is not valid.
    @discardableResult
    func addHabit(_ draft: HabitDraft) -> Habit.ID? {
        guard draft.isValid else { return nil }
        var habit = Habit(name: "", icon: draft.icon, color: draft.color, goal: draft.goal, subtitle: "")
        draft.apply(to: &habit)
        habits.append(habit)
        return habit.id
    }

    /// Writes the draft into a habit. The history does not change. A draft that is not valid changes nothing.
    func updateHabit(id: Habit.ID, draft: HabitDraft) {
        guard draft.isValid, let index = habits.firstIndex(where: { $0.id == id }) else { return }
        draft.apply(to: &habits[index])
    }

    /// Moves a habit to the archived list. The habit keeps its history.
    func archiveHabit(id: Habit.ID) {
        guard let index = habits.firstIndex(where: { $0.id == id }) else { return }
        archivedHabits.append(habits.remove(at: index))
    }

    /// Moves an archived habit back to the end of the habit list.
    func restoreHabit(id: Habit.ID) {
        guard let index = archivedHabits.firstIndex(where: { $0.id == id }) else { return }
        habits.append(archivedHabits.remove(at: index))
    }

    /// Deletes an archived habit and its history for good.
    func deleteArchivedHabit(id: Habit.ID) {
        archivedHabits.removeAll { $0.id == id }
    }

    /// Moves habits with `List.onMove` semantics.
    func moveHabits(fromOffsets source: IndexSet, toOffset destination: Int) {
        Self.move(&habits, fromOffsets: source, toOffset: destination)
    }

    /// Moves an Inbox item to a task block at `start`. The block keeps the item's project.
    /// A block that would cross 11:59 PM gets a shorter duration.
    /// - Returns: `false` when the item does not exist or less than 1 minute is left in the day.
    @discardableResult
    func schedule(inboxItemID: InboxItem.ID, at start: Date, calendar: Calendar) -> Bool {
        guard let index = inboxItems.firstIndex(where: { $0.id == inboxItemID }) else { return false }
        let item = inboxItems[index]
        guard let duration = DayLimit.clampedDuration(item.durationMinutes, start: start, calendar: calendar)
        else { return false }
        blocks.append(Block(
            kind: .task,
            title: item.title,
            start: start,
            durationMinutes: duration,
            icon: item.icon,
            color: item.color,
            projectID: item.projectID
        ))
        inboxItems.remove(at: index)
        return true
    }

    /// Schedules an Inbox item at the first free slot in `band` of today (the day of `now`).
    /// - Returns: the start of the new block, or `nil` when the band has no free slot. The item then stays in the Inbox.
    @discardableResult
    func placeInBand(
        inboxItemID: InboxItem.ID,
        band: Band,
        now: Date,
        schedule: BandSchedule,
        calendar: Calendar
    ) -> Date? {
        guard let item = inboxItems.first(where: { $0.id == inboxItemID }),
              let start = SlotSearch.firstFreeSlot(
                  durationMinutes: item.durationMinutes, in: band, day: now,
                  blocks: blocks(on: now, calendar: calendar), now: now,
                  schedule: schedule, calendar: calendar
              ),
              self.schedule(inboxItemID: inboxItemID, at: start, calendar: calendar)
        else { return nil }
        return start
    }

    /// Sets the title of an Inbox item. An empty title does not change the item.
    func renameInboxItem(id: InboxItem.ID, title: String) {
        guard let trimmed = Self.trimmed(title), let index = inboxItems.firstIndex(where: { $0.id == id }) else { return }
        inboxItems[index].title = trimmed
    }

    /// Adds a project at the end of its area. An empty name adds nothing.
    /// - Returns: the ID of the new project, or `nil` for an empty name.
    @discardableResult
    func addProject(name: String, color: BlockColor, areaID: Area.ID?) -> Project.ID? {
        guard let name = Self.trimmed(name) else { return nil }
        let project = Project(name: name, color: color, areaID: areaID)
        projects.append(project)
        return project.id
    }

    /// Adds an area at the end. An empty name adds nothing.
    /// - Returns: the ID of the new area, or `nil` for an empty name.
    @discardableResult
    func addArea(name: String, icon: String) -> Area.ID? {
        guard let name = Self.trimmed(name) else { return nil }
        let area = Area(name: name, icon: icon)
        areas.append(area)
        return area.id
    }

    /// Adds an Anytime task with no day to a project, in the project color. An empty title adds nothing.
    func addAnytimeTask(title: String, projectID: Project.ID) {
        guard let title = Self.trimmed(title),
              let project = projects.first(where: { $0.id == projectID })
        else { return }
        anytimeTasks.append(AnytimeTask(title: title, icon: "list.bullet", color: project.color, projectID: projectID))
    }

    func setNotes(projectID: Project.ID, notes: String) {
        guard let index = projects.firstIndex(where: { $0.id == projectID }) else { return }
        projects[index].notes = notes
    }

    func deleteInboxItem(id: InboxItem.ID) {
        inboxItems.removeAll { $0.id == id }
    }

    /// Moves Inbox items with `List.onMove` semantics: `destination` is an offset in the list before the move.
    func moveInboxItems(fromOffsets source: IndexSet, toOffset destination: Int) {
        Self.move(&inboxItems, fromOffsets: source, toOffset: destination)
    }

    /// `List.onMove` semantics: `destination` is an offset in the list before the move.
    private static func move<Element>(_ list: inout [Element], fromOffsets source: IndexSet, toOffset destination: Int) {
        let moving = source.map { list[$0] }
        for index in source.sorted(by: >) {
            list.remove(at: index)
        }
        let insertIndex = destination - source.filter { $0 < destination }.count
        list.insert(contentsOf: moving, at: insertIndex)
    }

    /// The text without leading and trailing white space, or `nil` when nothing is left.
    private static func trimmed(_ text: String) -> String? {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? nil : trimmed
    }
}
