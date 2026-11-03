import Foundation

/// Reads a day, a time, and a duration out of one line of English text. See docs/features/quick-add-parsing.md.
/// The first match of each kind counts. The parser removes it from the title. A later match stays in the title.
enum QuickAddParser {
    enum Issue: String, Equatable, Sendable {
        case duration = "Enter a smaller duration."
        case time = "Enter a valid time. Minutes must be 00 to 59."
        case date = "Enter a valid date."
        case nonexistentTime = "This time does not exist on this date. Choose another time."
    }

    struct Result: Equatable {
        var issues: [Issue] = []
        /// The text without the matched tokens, with spaces collapsed.
        var title: String
        /// The start of the parsed day.
        var day: Date?
        /// Minutes after midnight.
        var minute: Int?
        /// `nil` for no duration token, and for a zero duration such as "0m".
        var durationMinutes: Int?
        /// The text range of each matched token. Pickers replace a token in place.
        var dayRange: Range<String.Index>?
        var timeRange: Range<String.Index>?
        var durationRange: Range<String.Index>?
    }

    /// `calendar.locale` sets the order of a numeric date such as "3/11". `nil` uses the current locale.
    static func parse(_ text: String, now: Date, calendar: Calendar) -> Result {
        var result = Result(title: "")
        let today = calendar.startOfDay(for: now)

        if let match = firstMatch(duration, in: text) {
            result.durationRange = match.range
            if let value = Int(match.groups[0] ?? "") {
                let multiplier = match.groups[1]?.lowercased().hasPrefix("h") == true ? 60 : 1
                let (minutes, overflow) = value.multipliedReportingOverflow(by: multiplier)
                if overflow { result.issues.append(.duration) }
                else { result.durationMinutes = minutes > 0 ? minutes : nil }
            } else {
                result.issues.append(.duration)
            }
        }

        if let match = firstMatch(amPMTime, in: text) {
            result.timeRange = match.range
            if let hour = Int(match.groups[0] ?? ""), (1...12).contains(hour),
               let minute = Int(match.groups[1] ?? "0"), (0...59).contains(minute) {
                let isPM = match.groups[2]?.lowercased() == "pm"
                result.minute = (hour % 12 + (isPM ? 12 : 0)) * 60 + minute
            } else { result.issues.append(.time) }
        } else if let match = firstMatch(twentyFourHourTime, in: text) {
            result.timeRange = match.range
            if let hour = Int(match.groups[0] ?? ""), (0...23).contains(hour),
               let minute = Int(match.groups[1] ?? ""), (0...59).contains(minute) {
                result.minute = hour * 60 + minute
            } else { result.issues.append(.time) }
        }

        // Exact picker dates take precedence over all partial date patterns.
        if let match = firstMatch(exactDate, in: text) {
            result.dayRange = match.range
            let gregorian = DayKey.gregorian(calendar)
            let parts = DateComponents(year: Int(match.groups[0] ?? ""), month: Int(match.groups[1] ?? ""), day: Int(match.groups[2] ?? ""))
            if let year = parts.year, year > 0, let date = gregorian.date(from: parts),
               gregorian.component(.year, from: date) == year,
               gregorian.component(.month, from: date) == parts.month,
               gregorian.component(.day, from: date) == parts.day {
                result.day = date
            } else { result.issues.append(.date) }
        } else if let (range, day) = day(in: text, today: today, calendar: calendar) {
            result.dayRange = range
            result.day = day
        }

        var rest = text
        let ranges = [
            result.issues.contains(.duration) ? nil : result.durationRange,
            result.issues.contains(.time) ? nil : result.timeRange,
            result.issues.contains(.date) ? nil : result.dayRange
        ].compactMap { $0 }
        var removedFrom = text.endIndex
        for range in ranges.sorted(by: { $0.lowerBound > $1.lowerBound }) where range.upperBound <= removedFrom {
            rest.replaceSubrange(range, with: " ")
            removedFrom = range.lowerBound
        }
        result.title = rest.split(whereSeparator: \.isWhitespace).joined(separator: " ")
        return result
    }

    // MARK: Day

    /// The day token that comes first in the text: a day word, a weekday name, or a date.
    private static func day(in text: String, today: Date, calendar: Calendar) -> (Range<String.Index>, Date)? {
        var candidates: [(Range<String.Index>, Date)] = []

        if let match = firstMatch(dayWord, in: text) {
            let word = match.groups[0]?.lowercased() ?? ""
            let offset = word == "tomorrow" || word == "tmrw" ? 1 : 0
            if let day = calendar.date(byAdding: .day, value: offset, to: today) {
                candidates.append((match.range, day))
            }
        }

        if let match = firstMatch(weekdayName, in: text),
           let weekday = weekday(named: match.groups[0] ?? ""),
           let day = nextDay(of: weekday, after: today, calendar: calendar) {
            candidates.append((match.range, day))
        }

        if let match = firstMatch(monthDay, in: text),
           let month = month(named: match.groups[0] ?? ""), let dayNumber = Int(match.groups[1] ?? ""),
           let day = date(month: month, day: dayNumber, onOrAfter: today, calendar: DayKey.gregorian(calendar)) {
            candidates.append((match.range, day))
        }

        if let match = firstMatch(dayMonth, in: text),
           let dayNumber = Int(match.groups[0] ?? ""), let month = month(named: match.groups[1] ?? ""),
           let day = date(month: month, day: dayNumber, onOrAfter: today, calendar: DayKey.gregorian(calendar)) {
            candidates.append((match.range, day))
        }

        if let match = firstMatch(numericDate, in: text),
           let first = Int(match.groups[0] ?? ""), let second = Int(match.groups[1] ?? "") {
            let dayFirst = isDayFirst(calendar.locale ?? .current)
            let (month, dayNumber) = dayFirst ? (second, first) : (first, second)
            if let day = date(month: month, day: dayNumber, onOrAfter: today, calendar: calendar) {
                candidates.append((match.range, day))
            }
        }

        return candidates.min { $0.0.lowerBound < $1.0.lowerBound }
    }

    /// The next `weekday` 1 to 7 days after `today`. On a Monday, "mon" is next Monday (decided 2026-10-31).
    static func nextDay(of weekday: Weekday, after today: Date, calendar: Calendar) -> Date? {
        let current = Weekday(of: today, calendar: calendar)
        let offset = (weekday.rawValue - current.rawValue + 7) % 7
        return calendar.date(byAdding: .day, value: offset == 0 ? 7 : offset, to: today)
    }

    /// The date in the year of `today`, or in the next year when that date is already past.
    /// `nil` for a date that does not exist, such as "feb 30".
    private static func date(month: Int, day: Int, onOrAfter today: Date, calendar: Calendar) -> Date? {
        let year = calendar.component(.year, from: today)
        for candidateYear in [year, year + 1] {
            let parts = DateComponents(year: candidateYear, month: month, day: day)
            guard let date = calendar.date(from: parts),
                  calendar.component(.month, from: date) == month,
                  calendar.component(.day, from: date) == day
            else { continue }
            if date >= today { return date }
        }
        return nil
    }

    private static func weekday(named name: String) -> Weekday? {
        let prefix = name.lowercased().prefix(3)
        return Weekday.allCases.first { $0.shortName.lowercased() == prefix }
    }

    private static func month(named name: String) -> Int? {
        let prefix = name.lowercased().prefix(3)
        return monthPrefixes.firstIndex(of: String(prefix)).map { $0 + 1 }
    }

    /// `true` when the locale writes the day before the month in a short numeric date.
    private static func isDayFirst(_ locale: Locale) -> Bool {
        let format = DateFormatter.dateFormat(fromTemplate: "Md", options: 0, locale: locale) ?? "M/d"
        guard let dayIndex = format.firstIndex(of: "d"), let monthIndex = format.firstIndex(of: "M") else { return false }
        return dayIndex < monthIndex
    }

    // MARK: Patterns

    private static let monthPrefixes = ["jan", "feb", "mar", "apr", "may", "jun", "jul", "aug", "sep", "oct", "nov", "dec"]
    private static let monthPattern =
        "(jan(?:uary)?|feb(?:ruary)?|mar(?:ch)?|apr(?:il)?|may|june?|july?|aug(?:ust)?|sep(?:t(?:ember)?)?|oct(?:ober)?|nov(?:ember)?|dec(?:ember)?)\\.?"

    private static let duration = regex("\\b(\\d+)\\s?(m|min|mins|h|hr|hrs)\\b")
    private static let amPMTime = regex("(?<![\\w:])(\\d+)(?::(\\d+))?\\s?(am|pm)\\b")
    private static let twentyFourHourTime = regex("(?<![\\w:])(\\d+):(\\d+)(?![\\w:])")
    private static let exactDate = regex("(?<![\\w-])(\\d{4})-(\\d{2})-(\\d{2})(?![\\w-])")
    private static let dayWord = regex("\\b(today|tonight|tomorrow|tmrw)\\b")
    private static let weekdayName = regex(
        "\\b(mon(?:day)?|tue(?:s(?:day)?)?|wed(?:nesday)?|thu(?:r(?:s(?:day)?)?)?|fri(?:day)?|sat(?:urday)?|sun(?:day)?)\\b"
    )
    private static let monthDay = regex("\\b\(monthPattern)\\s+(\\d{1,2})(?:st|nd|rd|th)?\\b")
    private static let dayMonth = regex("\\b(\\d{1,2})(?:st|nd|rd|th)?\\s+\(monthPattern)(?![a-z])")
    private static let numericDate = regex("\\b(\\d{1,2})/(\\d{1,2})\\b")

    private static func regex(_ pattern: String) -> NSRegularExpression {
        // The patterns are constants. A bad pattern is a programming error.
        try! NSRegularExpression(pattern: pattern, options: [.caseInsensitive])
    }

    private struct Match {
        var range: Range<String.Index>
        /// The capture groups after group 0. A group that did not take part is `nil`.
        var groups: [String?]
    }

    private static func firstMatch(_ regex: NSRegularExpression, in text: String) -> Match? {
        let all = NSRange(text.startIndex..., in: text)
        guard let result = regex.firstMatch(in: text, range: all), let range = Range(result.range, in: text) else { return nil }
        let groups = (1..<result.numberOfRanges).map { index in
            Range(result.range(at: index), in: text).map { String(text[$0]) }
        }
        return Match(range: range, groups: groups)
    }
}
