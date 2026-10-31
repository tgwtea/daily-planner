import Foundation

/// A project in an area. See docs/features/projects-and-areas.md.
struct Project: Identifiable, Hashable, Sendable {
    /// The date line of a project row: "No date", "Ongoing", "Due Nov 14", "Dec 18 – 27".
    enum Timing: Hashable, Sendable {
        case noDate
        case ongoing
        case due(Date)
        case span(Date, Date)

        /// The meta line text in the locale of `calendar`, for example "Due Nov 14".
        /// A span uses the locale's interval format: "Dec 18 – 27" in en_US, "18 – 27 Dec" in en_GB.
        func text(calendar: Calendar) -> String {
            let locale = calendar.locale ?? .autoupdatingCurrent
            switch self {
            case .noDate:
                return "No date"
            case .ongoing:
                return "Ongoing"
            case .due(let date):
                let style = Date.FormatStyle(locale: locale, calendar: calendar, timeZone: calendar.timeZone)
                return "Due \(style.month(.abbreviated).day().format(date))"
            case .span(let start, let end):
                let style = Date.IntervalFormatStyle(locale: locale, calendar: calendar, timeZone: calendar.timeZone)
                return (start..<max(start, end)).formatted(style.month(.abbreviated).day())
            }
        }
    }

    var id = UUID()
    var name: String
    var color: BlockColor
    var areaID: UUID?
    var timing: Timing = .noDate
}
