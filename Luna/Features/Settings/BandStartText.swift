import Foundation

/// The clock text for a band start, for example "6:00 AM".
enum BandStartText {
    static func label(minute: Int, calendar: Calendar) -> String {
        var components = DateComponents()
        components.hour = minute / 60
        components.minute = minute % 60
        let date = calendar.date(from: components) ?? .now
        return date.formatted(.dateTime.hour().minute())
    }
}
