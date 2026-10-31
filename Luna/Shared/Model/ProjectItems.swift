import Foundation

/// The items of one project in the three groups of project detail. See docs/features/projects-and-areas.md#decisions.
///
/// The items follow the rules of `ProjectProgress`: task and routine blocks, Anytime tasks, Inbox items,
/// and Someday items with the project's ID. Events do not show.
struct ProjectItems: Hashable, Sendable {
    /// Open blocks and open dated Anytime tasks, earliest first.
    var scheduled: [ListItem]
    /// Open Anytime tasks with no day, then Inbox items, then Someday items, in store order.
    var anytime: [ListItem]
    /// Done blocks and done Anytime tasks, newest first.
    var done: [ListItem]

    init(projectID: Project.ID, in store: PlannerStore) {
        let blocks = store.blocks
            .filter { $0.projectID == projectID && $0.kind != .event }
            .map(ListItem.block)
        let tasks = store.anytimeTasks
            .filter { $0.projectID == projectID }
            .map(ListItem.anytimeTask)
        let open = (blocks + tasks).filter { !$0.isDone }

        scheduled = ListItem.sortedByDate(open.filter { $0.date != nil })
        anytime = open.filter { $0.date == nil }
            + store.inboxItems.filter { $0.projectID == projectID }.map(ListItem.inbox)
            + store.somedayItems.filter { $0.projectID == projectID }.map(ListItem.someday)
        done = ListItem.sortedNewestFirst((blocks + tasks).filter(\.isDone))
    }
}
