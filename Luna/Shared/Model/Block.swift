import Foundation

/// An item on the timeline with a start time and a duration.
/// See docs/features/timeline-and-day-bands.md and docs/features/block-completion-and-routines.md.
struct Block: Identifiable, Hashable, Sendable {
    enum Kind: String, Hashable, Sendable {
        /// A block that the user can mark done.
        case task
        /// A task block with a checklist. It is done when all steps are done.
        case routine
        /// A read-only block from the system calendar. It is never done.
        case event
    }

    var id = UUID()
    var kind: Kind
    var title: String
    var start: Date
    var durationMinutes: Int
    /// An SF Symbol name. Events have no icon.
    var icon: String?
    /// Events have no block color.
    var color: BlockColor?
    var steps: [Step] = []
    /// The done flag of a task. A routine uses its steps instead.
    var done = false
    /// When the block became done. `nil` while it is open. Logbook sorts by it.
    var completedAt: Date?
    /// The calendar name of an event, for example "Work".
    var calendarName: String?
    var projectID: UUID?

    var end: Date {
        start.addingTimeInterval(TimeInterval(durationMinutes * 60))
    }

    /// A routine with zero steps counts as a task.
    var isRoutine: Bool {
        kind == .routine && !steps.isEmpty
    }

    var isDone: Bool {
        switch kind {
        case .event: false
        case .routine where isRoutine: steps.allSatisfy(\.done)
        default: done
        }
    }

    /// `true` when the block ends at 11:59 PM of its start day at the latest.
    func fitsDay(calendar: Calendar) -> Bool {
        guard let latestEnd = DayLimit.latestEnd(forStart: start, calendar: calendar) else { return false }
        return end <= latestEnd
    }
}

/// One checklist item inside a block.
struct Step: Identifiable, Hashable, Sendable {
    var id = UUID()
    var title: String
    var done = false
}
