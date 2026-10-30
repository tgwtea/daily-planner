import Foundation

/// A block cannot cross midnight. It ends at 11:59 PM at the latest (decided 2026-10-30).
enum DayLimit {
    /// 11:59 PM on the start day.
    static func latestEnd(forStart start: Date, calendar: Calendar) -> Date? {
        calendar.date(bySettingHour: 23, minute: 59, second: 0, of: start)
    }

    /// The minutes from the start to 11:59 PM. It counts real time, so a daylight saving day works.
    static func maxDuration(forStart start: Date, calendar: Calendar) -> Int {
        guard let latestEnd = latestEnd(forStart: start, calendar: calendar) else { return 0 }
        return max(0, Int(latestEnd.timeIntervalSince(start) / 60))
    }

    /// The duration cut to end at 11:59 PM, or `nil` when less than 1 minute is left.
    static func clampedDuration(_ minutes: Int, start: Date, calendar: Calendar) -> Int? {
        let clamped = min(minutes, maxDuration(forStart: start, calendar: calendar))
        return clamped >= 1 ? clamped : nil
    }
}
