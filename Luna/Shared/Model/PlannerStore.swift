import Foundation
import Observation

/// The one in-memory store for blocks, tasks, habits, and projects.
/// Views read its arrays and call its intents. Roadmap 2.1 replaces only its storage.
@Observable
final class PlannerStore {
    var blocks: [Block]
    var anytimeTasks: [AnytimeTask]
    var inboxItems: [InboxItem]
    var habits: [Habit]
    var areas: [Area]
    var projects: [Project]

    init(
        blocks: [Block] = [],
        anytimeTasks: [AnytimeTask] = [],
        inboxItems: [InboxItem] = [],
        habits: [Habit] = [],
        areas: [Area] = [],
        projects: [Project] = []
    ) {
        self.blocks = blocks
        self.anytimeTasks = anytimeTasks
        self.inboxItems = inboxItems
        self.habits = habits
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

    // MARK: Intents

    /// Toggles a task. For a routine, sets every step to done, or every step to not done when all are done.
    /// An event does not change.
    func toggleDone(blockID: Block.ID) {
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
        blocks[index] = block
    }

    func toggleStep(blockID: Block.ID, stepID: Step.ID) {
        guard let index = blocks.firstIndex(where: { $0.id == blockID }),
              let stepIndex = blocks[index].steps.firstIndex(where: { $0.id == stepID })
        else { return }
        blocks[index].steps[stepIndex].done.toggle()
    }

    func toggleAnytimeTask(id: AnytimeTask.ID) {
        guard let index = anytimeTasks.firstIndex(where: { $0.id == id }) else { return }
        anytimeTasks[index].done.toggle()
    }

    /// Adds one to the habit count of the day. At the goal, the count goes back to zero.
    func logHabit(id: Habit.ID, on day: Date, calendar: Calendar) {
        guard let index = habits.firstIndex(where: { $0.id == id }) else { return }
        let key = calendar.startOfDay(for: day)
        let value = habits[index].history[key] ?? 0
        habits[index].history[key] = value >= habits[index].goal ? nil : value + 1
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
        let trimmed = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty, let index = inboxItems.firstIndex(where: { $0.id == id }) else { return }
        inboxItems[index].title = trimmed
    }

    func deleteInboxItem(id: InboxItem.ID) {
        inboxItems.removeAll { $0.id == id }
    }

    /// Moves Inbox items with `List.onMove` semantics: `destination` is an offset in the list before the move.
    func moveInboxItems(fromOffsets source: IndexSet, toOffset destination: Int) {
        let moving = source.map { inboxItems[$0] }
        for index in source.sorted(by: >) {
            inboxItems.remove(at: index)
        }
        let insertIndex = destination - source.filter { $0 < destination }.count
        inboxItems.insert(contentsOf: moving, at: insertIndex)
    }
}
