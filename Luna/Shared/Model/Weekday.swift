import Foundation

/// A day of the week in a habit schedule, Monday first. See docs/features/habits.md.
enum Weekday: Int, CaseIterable, Identifiable, Sendable {
    case monday, tuesday, wednesday, thursday, friday, saturday, sunday

    var id: Self { self }

    init(of date: Date, calendar: Calendar) {
        // `weekday` is 1 for Sunday. Monday is case 0.
        self = Weekday(rawValue: (calendar.component(.weekday, from: date) + 5) % 7) ?? .monday
    }

    var name: String {
        switch self {
        case .monday: "Monday"
        case .tuesday: "Tuesday"
        case .wednesday: "Wednesday"
        case .thursday: "Thursday"
        case .friday: "Friday"
        case .saturday: "Saturday"
        case .sunday: "Sunday"
        }
    }

    /// One letter, as in the habit card week row.
    var initial: String { String(name.prefix(1)) }

    /// Three letters, for example "Mon".
    var shortName: String { String(name.prefix(3)) }

    /// A short text for a weekday set: "Every day", "Weekdays", "Weekends", or "Mon, Wed, Fri".
    static func summary(of days: Set<Weekday>) -> String {
        let weekdays: Set<Weekday> = [.monday, .tuesday, .wednesday, .thursday, .friday]
        switch days {
        case Set(allCases): return "Every day"
        case weekdays: return "Weekdays"
        case [.saturday, .sunday]: return "Weekends"
        case []: return "No days"
        default: return allCases.filter(days.contains).map(\.shortName).joined(separator: ", ")
        }
    }
}
