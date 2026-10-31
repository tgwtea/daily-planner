import Foundation

/// The editable fields of a habit in the habit editor. See docs/screens/habit-editor.md.
struct HabitDraft: Equatable, Sendable {
    static let goalRange = 1...99

    var name = ""
    var icon = "checkmark"
    var color = BlockColor.slate
    var goal = 1
    /// The card subtitle. It can be empty.
    var detail = ""
    var weekdays = Set(Weekday.allCases)

    init() {}

    init(habit: Habit) {
        name = habit.name
        icon = habit.icon
        color = habit.color
        goal = habit.goal
        detail = habit.subtitle
        weekdays = habit.weekdays
    }

    /// The name without leading and trailing white space, or `nil` when nothing is left.
    var trimmedName: String? {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? nil : trimmed
    }

    var isValid: Bool {
        trimmedName != nil && !weekdays.isEmpty && Self.goalRange.contains(goal)
    }

    /// Writes the draft into `habit`. The ID and the history do not change.
    func apply(to habit: inout Habit) {
        habit.name = trimmedName ?? habit.name
        habit.icon = icon
        habit.color = color
        habit.goal = goal
        habit.subtitle = detail.trimmingCharacters(in: .whitespacesAndNewlines)
        habit.weekdays = weekdays
    }
}
