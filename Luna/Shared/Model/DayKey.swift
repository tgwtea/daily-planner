import Foundation

/// A local Gregorian date. A time-zone change does not move a recorded habit to another date.
struct DayKey: Hashable, Comparable, Sendable {
    let year: Int
    let month: Int
    let day: Int

    init(_ date: Date, calendar: Calendar) {
        let parts = Self.gregorian(calendar).dateComponents([.year, .month, .day], from: date)
        year = parts.year!
        month = parts.month!
        day = parts.day!
    }

    func date(calendar: Calendar) -> Date? {
        Self.gregorian(calendar).date(from: DateComponents(year: year, month: month, day: day))
    }

    static func gregorian(_ calendar: Calendar) -> Calendar {
        var result = Calendar(identifier: .gregorian)
        result.timeZone = calendar.timeZone
        result.locale = calendar.locale
        return result
    }

    static func < (lhs: Self, rhs: Self) -> Bool {
        (lhs.year, lhs.month, lhs.day) < (rhs.year, rhs.month, rhs.day)
    }

    var token: String { String(format: "%04d-%02d-%02d", year, month, day) }
}
