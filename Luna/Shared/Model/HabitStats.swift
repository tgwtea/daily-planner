import Foundation

/// Streak, month, and heatmap math for one habit or for all habits together. See docs/features/habits.md.
///
/// Each function takes a list of habits. Pass one habit for its own numbers.
/// A day is done for the list when every habit in it is done (decided 2026-10-31).
/// Every habit is scheduled every day until checkpoint 1b.7 adds weekday sets.
enum HabitStats {
    /// The heatmap columns. Each column is one Monday-to-Sunday week.
    static let heatmapWeeks = 12

    /// `true` when the list is not empty and every habit is done on `day`.
    static func isDone(_ habits: [Habit], on day: Date, calendar: Calendar) -> Bool {
        !habits.isEmpty && habits.allSatisfy { $0.isDone(on: day, calendar: calendar) }
    }

    /// The number of habits done on `day`.
    static func doneCount(_ habits: [Habit], on day: Date, calendar: Calendar) -> Int {
        habits.filter { $0.isDone(on: day, calendar: calendar) }.count
    }

    /// Consecutive done days up to and including `today`.
    /// When today is not done yet, the count ends at yesterday.
    static func streak(_ habits: [Habit], today: Date, calendar: Calendar) -> Int {
        var day = calendar.startOfDay(for: today)
        if !isDone(habits, on: day, calendar: calendar) {
            guard let yesterday = calendar.date(byAdding: .day, value: -1, to: day) else { return 0 }
            day = yesterday
        }
        var count = 0
        while isDone(habits, on: day, calendar: calendar) {
            count += 1
            guard let previous = calendar.date(byAdding: .day, value: -1, to: day) else { break }
            day = previous
        }
        return count
    }

    /// The longest run of done days from the first logged day to `today`.
    static func bestStreak(_ habits: [Habit], today: Date, calendar: Calendar) -> Int {
        let end = calendar.startOfDay(for: today)
        guard var day = habits.flatMap(\.history.keys).min(), day <= end else { return 0 }
        var best = 0
        var run = 0
        while day <= end {
            run = isDone(habits, on: day, calendar: calendar) ? run + 1 : 0
            best = max(best, run)
            guard let next = calendar.date(byAdding: .day, value: 1, to: day) else { break }
            day = next
        }
        return best
    }

    /// Done habit-days divided by scheduled habit-days, from the first day of the month to `today`, in percent.
    /// For one habit this is done days divided by elapsed days.
    static func monthPercent(_ habits: [Habit], today: Date, calendar: Calendar) -> Int {
        let end = calendar.startOfDay(for: today)
        guard !habits.isEmpty, var day = calendar.dateInterval(of: .month, for: end)?.start else { return 0 }
        var done = 0
        var scheduled = 0
        while day <= end {
            done += doneCount(habits, on: day, calendar: calendar)
            scheduled += habits.count
            guard let next = calendar.date(byAdding: .day, value: 1, to: day) else { break }
            day = next
        }
        return Int((Double(done) / Double(scheduled) * 100).rounded())
    }

    /// The heatmap share of one day, 0...1.
    /// One habit gives its value / goal. More habits give the share of habits done.
    static func share(_ habits: [Habit], on day: Date, calendar: Calendar) -> Double {
        if habits.count == 1, let habit = habits.first {
            return min(1, Double(habit.value(on: day, calendar: calendar)) / Double(max(habit.goal, 1)))
        }
        guard !habits.isEmpty else { return 0 }
        return Double(doneCount(habits, on: day, calendar: calendar)) / Double(habits.count)
    }

    /// The 84 heatmap cells, one column per week, oldest week first. Each column runs Monday to Sunday.
    /// A day after `today` is `nil`.
    static func heatmap(_ habits: [Habit], today: Date, calendar: Calendar) -> [Double?] {
        let end = calendar.startOfDay(for: today)
        return (0..<heatmapWeeks).reversed().flatMap { weeksBack in
            Week.days(containing: Week.shift(end, weeks: -weeksBack, calendar: calendar), calendar: calendar)
                .map { day in day > end ? nil : share(habits, on: day, calendar: calendar) }
        }
    }

    /// The mix of the habit color with the canvas for a heatmap share: 35% at the lowest share, 100% when done.
    /// A share of 0 uses the empty cell color instead.
    static func heatStrength(_ share: Double) -> Double {
        0.35 + 0.65 * min(max(share, 0), 1)
    }
}
