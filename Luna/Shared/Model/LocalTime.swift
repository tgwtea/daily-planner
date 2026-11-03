import Foundation

/// Converts a wall-clock minute into an exact local time. Durations remain elapsed minutes.
enum LocalTime {
    static func date(minute: Int, on day: Date, calendar: Calendar) -> Date? {
        guard (0..<1440).contains(minute), let interval = calendar.dateInterval(of: .day, for: day) else { return nil }
        let match = DateComponents(hour: minute / 60, minute: minute % 60, second: 0)
        guard let date = calendar.nextDate(
            after: interval.start.addingTimeInterval(-1), matching: match,
            matchingPolicy: .strict, repeatedTimePolicy: .first, direction: .forward
        ), date < interval.end else { return nil }
        return date
    }

    /// A band boundary advances to the next valid minute if a clock change removes it.
    static func boundary(minute: Int, on day: Date, calendar: Calendar) -> Date? {
        guard (0...1440).contains(minute) else { return nil }
        for candidate in minute..<1440 {
            if let date = date(minute: candidate, on: day, calendar: calendar) { return date }
        }
        return calendar.dateInterval(of: .day, for: day)?.end
    }
}
