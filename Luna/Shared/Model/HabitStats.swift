import Foundation

/// Streak, month, and heatmap math for one habit or for all habits together. See docs/features/habits.md.
///
/// Each function takes a list of habits. Pass one habit for its own numbers.
/// A day is done for the list when every habit that is scheduled that day is done (decided 2026-10-31).
/// A day on which no habit is scheduled is an off day. It does not break a streak (decided 2026-10-30).
enum HabitStats {
    /// The heatmap columns. Each column is one Monday-to-Sunday week.
    static let heatmapWeeks = 12

    /// The habits of the list that are scheduled on `day`.
    static func scheduled(_ habits: [Habit], on day: Date, calendar: Calendar) -> [Habit] {
        habits.filter { $0.isScheduled(on: day, calendar: calendar) }
    }

    /// `true` when no habit of the list is scheduled on `day`. An off day does not break or extend a streak.
    static func isOffDay(_ habits: [Habit], on day: Date, calendar: Calendar) -> Bool {
        scheduled(habits, on: day, calendar: calendar).isEmpty
    }

    /// `true` when at least one habit is scheduled on `day` and every scheduled habit is done.
    static func isDone(_ habits: [Habit], on day: Date, calendar: Calendar) -> Bool {
        let due = scheduled(habits, on: day, calendar: calendar)
        return !due.isEmpty && due.allSatisfy { $0.isDone(on: day, calendar: calendar) }
    }

    /// The number of habits that are scheduled on `day` and done.
    static func doneCount(_ habits: [Habit], on day: Date, calendar: Calendar) -> Int {
        scheduled(habits, on: day, calendar: calendar).filter { $0.isDone(on: day, calendar: calendar) }.count
    }

    /// Consecutive done days up to and including `today`. Off days are skipped.
    /// When today is not done yet, the count ends at yesterday.
    static func streak(_ habits: [Habit], today: Date, calendar: Calendar) -> Int {
        let end = calendar.startOfDay(for: today)
        // The walk stops at the first logged day, so a list with no scheduled day still ends.
        guard let first = habits.flatMap(\.history.keys).min()?.date(calendar: calendar) else { return 0 }
        var day = end
        var count = 0
        while day >= first {
            if isDone(habits, on: day, calendar: calendar) {
                count += 1
            } else if day != end && !isOffDay(habits, on: day, calendar: calendar) {
                break
            }
            guard let previous = calendar.date(byAdding: .day, value: -1, to: day) else { break }
            day = previous
        }
        return count
    }

    /// The longest run of done days from the first logged day to `today`. Off days are skipped.
    static func bestStreak(_ habits: [Habit], today: Date, calendar: Calendar) -> Int {
        let end = calendar.startOfDay(for: today)
        guard var day = habits.flatMap(\.history.keys).min()?.date(calendar: calendar), day <= end else { return 0 }
        var best = 0
        var run = 0
        while day <= end {
            if isDone(habits, on: day, calendar: calendar) {
                run += 1
            } else if !isOffDay(habits, on: day, calendar: calendar) {
                run = 0
            }
            best = max(best, run)
            guard let next = calendar.date(byAdding: .day, value: 1, to: day) else { break }
            day = next
        }
        return best
    }

    /// Done habit-days divided by scheduled habit-days, from the first day of the month to `today`, in percent.
    /// For one habit this is done days divided by scheduled days. With no scheduled day it is 0.
    static func monthPercent(_ habits: [Habit], today: Date, calendar: Calendar) -> Int {
        let end = calendar.startOfDay(for: today)
        guard var day = calendar.dateInterval(of: .month, for: end)?.start else { return 0 }
        var done = 0
        var due = 0
        while day <= end {
            done += doneCount(habits, on: day, calendar: calendar)
            due += scheduled(habits, on: day, calendar: calendar).count
            guard let next = calendar.date(byAdding: .day, value: 1, to: day) else { break }
            day = next
        }
        guard due > 0 else { return 0 }
        return Int((Double(done) / Double(due) * 100).rounded())
    }

    /// The heatmap share of one day, 0...1. An off day gives 0.
    /// One habit gives its value / goal. More habits give the share of scheduled habits done.
    static func share(_ habits: [Habit], on day: Date, calendar: Calendar) -> Double {
        let due = scheduled(habits, on: day, calendar: calendar)
        if habits.count == 1, let habit = due.first {
            return min(1, Double(habit.value(on: day, calendar: calendar)) / Double(max(habit.goal, 1)))
        }
        guard !due.isEmpty else { return 0 }
        return Double(doneCount(habits, on: day, calendar: calendar)) / Double(due.count)
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
