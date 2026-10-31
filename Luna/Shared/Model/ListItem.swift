import Foundation

/// One row in a smart list or on project detail: a block, an Anytime task, an Inbox item, or a Someday item.
/// See docs/features/projects-and-areas.md.
enum ListItem: Identifiable, Hashable, Sendable {
    case block(Block)
    case anytimeTask(AnytimeTask)
    case inbox(InboxItem)
    case someday(InboxItem)

    var id: UUID {
        switch self {
        case .block(let block): block.id
        case .anytimeTask(let task): task.id
        case .inbox(let item), .someday(let item): item.id
        }
    }

    var title: String {
        switch self {
        case .block(let block): block.title
        case .anytimeTask(let task): task.title
        case .inbox(let item), .someday(let item): item.title
        }
    }

    /// An SF Symbol name.
    var icon: String {
        switch self {
        case .block(let block): block.icon ?? "calendar"
        case .anytimeTask(let task): task.icon
        case .inbox(let item), .someday(let item): item.icon
        }
    }

    var color: BlockColor {
        switch self {
        case .block(let block): block.color ?? .slate
        case .anytimeTask(let task): task.color
        case .inbox(let item), .someday(let item): item.color
        }
    }

    /// The block start or the task day. Inbox and Someday items have no date.
    var date: Date? {
        switch self {
        case .block(let block): block.start
        case .anytimeTask(let task): task.day
        case .inbox, .someday: nil
        }
    }

    /// Inbox and Someday items are always open.
    var isDone: Bool {
        switch self {
        case .block(let block): block.isDone
        case .anytimeTask(let task): task.done
        case .inbox, .someday: false
        }
    }

    var completedAt: Date? {
        switch self {
        case .block(let block): block.completedAt
        case .anytimeTask(let task): task.completedAt
        case .inbox, .someday: nil
        }
    }

    var projectID: UUID? {
        switch self {
        case .block(let block): block.projectID
        case .anytimeTask(let task): task.projectID
        case .inbox(let item), .someday(let item): item.projectID
        }
    }

    /// Blocks and Anytime tasks have a check circle. Inbox and Someday items do not.
    var canToggle: Bool {
        switch self {
        case .block, .anytimeTask: true
        case .inbox, .someday: false
        }
    }

    /// Earliest date first. Items with no date go last. Equal items keep their order.
    static func sortedByDate(_ items: [ListItem]) -> [ListItem] {
        stableSorted(items) { a, b in
            switch (a.date, b.date) {
            case let (a?, b?): a < b
            case (.some, nil): true
            default: false
            }
        }
    }

    /// Newest completion first. Items with no completion time go last. Equal items keep their order.
    static func sortedNewestFirst(_ items: [ListItem]) -> [ListItem] {
        stableSorted(items) { a, b in
            switch (a.completedAt, b.completedAt) {
            case let (a?, b?): a > b
            case (.some, nil): true
            default: false
            }
        }
    }

    private static func stableSorted(_ items: [ListItem], by areInOrder: (ListItem, ListItem) -> Bool) -> [ListItem] {
        items.enumerated()
            .sorted { a, b in
                if areInOrder(a.element, b.element) { return true }
                if areInOrder(b.element, a.element) { return false }
                return a.offset < b.offset
            }
            .map(\.element)
    }
}
