import Foundation

/// A task with no day and no time yet. See docs/features/inbox-scheduling.md.
struct InboxItem: Identifiable, Hashable, Sendable {
    var id = UUID()
    var title: String
    var durationMinutes: Int
    /// An SF Symbol name.
    var icon: String
    var color: BlockColor
    /// The tag of the item. A tag is a project (decided 2026-10-30).
    var projectID: UUID?
}
