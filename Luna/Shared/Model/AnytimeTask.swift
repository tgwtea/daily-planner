import Foundation

/// A task for a day that has no time. See docs/features/anytime-tasks.md.
struct AnytimeTask: Identifiable, Hashable, Sendable {
    var id = UUID()
    var title: String
    /// An SF Symbol name.
    var icon: String
    var color: BlockColor
    var done = false
    /// When the task became done. `nil` while it is open. Logbook sorts by it.
    var completedAt: Date?
    /// The day of the task. `nil` puts it in the Anytime smart list.
    var day: Date?
    var projectID: UUID?
}
