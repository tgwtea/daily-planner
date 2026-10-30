import Foundation

/// The Monday-to-Sunday week of the week strip. See docs/screens/today.md.
enum Week {
    /// The seven days (start of day) of the week that contains `day`, Monday first.
    static func days(containing day: Date, calendar: Calendar) -> [Date] {
        let start = calendar.startOfDay(for: day)
        // `weekday` is 1 for Sunday. Monday is 0 days after the week start.
        let daysSinceMonday = (calendar.component(.weekday, from: start) + 5) % 7
        guard let monday = calendar.date(byAdding: .day, value: -daysSinceMonday, to: start) else { return [] }
        return (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: monday) }
    }

    /// The same weekday `weeks` weeks later (negative for earlier).
    static func shift(_ day: Date, weeks: Int, calendar: Calendar) -> Date {
        calendar.date(byAdding: .day, value: weeks * 7, to: calendar.startOfDay(for: day)) ?? day
    }
}
