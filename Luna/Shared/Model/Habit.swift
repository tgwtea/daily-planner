import Foundation

/// A repeated daily goal with a count. See docs/features/habits.md.
struct Habit: Identifiable, Hashable, Sendable {
    var id = UUID()
    var name: String
    /// An SF Symbol name.
    var icon: String
    var color: BlockColor
    var goal: Int
    /// The card subtitle, for example "8 glasses a day".
    var subtitle: String
    /// The logged count per day. The key is the start of the day.
    var history: [Date: Int] = [:]

    func value(on day: Date, calendar: Calendar) -> Int {
        history[calendar.startOfDay(for: day)] ?? 0
    }

    func isDone(on day: Date, calendar: Calendar) -> Bool {
        value(on: day, calendar: calendar) >= goal
    }
}
