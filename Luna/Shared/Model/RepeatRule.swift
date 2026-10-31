import Foundation

/// How a block repeats. See docs/features/block-editing.md#decisions.
/// Quick add sets it (decided 2026-10-31). Roadmap 1c.3 adds the repeated display and the per-day reset.
enum RepeatRule: String, CaseIterable, Identifiable, Sendable {
    case never, daily, weekdays, weekly

    var id: Self { self }

    var displayName: String {
        switch self {
        case .never: "Never"
        case .daily: "Daily"
        case .weekdays: "Weekdays"
        case .weekly: "Weekly"
        }
    }
}
