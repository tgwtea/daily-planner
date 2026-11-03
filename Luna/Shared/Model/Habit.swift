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
    /// The days of the week that the habit is due. A day that is not in the set does not break the streak.
    var weekdays: Set<Weekday> = Set(Weekday.allCases)
    /// The logged count per day. The key is the start of the day.
    var history: [DayKey: Int] = [:]

    func value(on day: Date, calendar: Calendar) -> Int {
        history[DayKey(day, calendar: calendar)] ?? 0
    }

    func isDone(on day: Date, calendar: Calendar) -> Bool {
        value(on: day, calendar: calendar) >= goal
    }

    func isScheduled(on day: Date, calendar: Calendar) -> Bool {
        weekdays.contains(Weekday(of: day, calendar: calendar))
    }
}
