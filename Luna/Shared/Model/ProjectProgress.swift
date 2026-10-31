import Foundation

/// The done and open item counts of one project. See docs/features/projects-and-areas.md.
///
/// The items are task and routine blocks, Anytime tasks, Inbox items, and Someday items with the project's ID.
/// Inbox and Someday items are always open. Events do not count.
struct ProjectProgress: Hashable, Sendable {
    var done = 0
    var open = 0

    var total: Int { done + open }

    /// Done items / all items. 0 when the project has no items.
    var fraction: Double {
        total == 0 ? 0 : Double(done) / Double(total)
    }

    /// `fraction` as a whole percent, for text and VoiceOver.
    var percent: Int {
        Int((fraction * 100).rounded())
    }

    init(done: Int = 0, open: Int = 0) {
        self.done = done
        self.open = open
    }

    init(projectID: Project.ID, in store: PlannerStore) {
        for block in store.blocks where block.projectID == projectID && block.kind != .event {
            add(done: block.isDone)
        }
        for task in store.anytimeTasks where task.projectID == projectID {
            add(done: task.done)
        }
        open += store.inboxItems.filter { $0.projectID == projectID }.count
        open += store.somedayItems.filter { $0.projectID == projectID }.count
    }

    private mutating func add(done isDone: Bool) {
        if isDone { done += 1 } else { open += 1 }
    }
}
