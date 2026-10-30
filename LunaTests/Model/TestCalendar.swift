import Foundation
@testable import Luna

/// A fixed Gregorian calendar, so that tests do not depend on the machine's time zone.
enum TestCalendar {
    static func make(timeZone: String = "UTC") -> Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: timeZone)!
        return calendar
    }

    static let utc = make()

    static func date(_ year: Int, _ month: Int, _ day: Int, _ hour: Int = 0, _ minute: Int = 0, calendar: Calendar = utc) -> Date {
        calendar.date(from: DateComponents(year: year, month: month, day: day, hour: hour, minute: minute))!
    }

    static func task(start: Date, minutes: Int) -> Block {
        Block(kind: .task, title: "Task", start: start, durationMinutes: minutes, icon: "circle", color: .rose)
    }
}
