import Foundation

/// The time and date text of Today. See docs/features/timeline-and-day-bands.md.
enum TimeText {
    /// "9:30": the locale's hour cycle without AM/PM.
    static func time(_ date: Date) -> String {
        date.formatted(.dateTime.hour(.defaultDigits(amPM: .omitted)).minute(.twoDigits))
    }

    /// "9:30 – 11:00".
    static func range(_ block: Block) -> String {
        "\(time(block.start)) – \(time(block.end))"
    }

    /// "8:00" for a minute after midnight on `day`.
    static func time(minute: Int, on day: Date, calendar: Calendar) -> String {
        let date = calendar.date(byAdding: .minute, value: minute, to: calendar.startOfDay(for: day)) ?? day
        return time(date)
    }

    /// "Thursday, October 29".
    static func dateLine(_ day: Date) -> String {
        day.formatted(.dateTime.weekday(.wide).month(.wide).day())
    }

    /// "Thursday".
    static func weekday(_ day: Date) -> String {
        day.formatted(.dateTime.weekday(.wide))
    }

    /// "39:48": minutes and seconds left. Hours fold into the minutes.
    static func countdown(seconds: Int) -> String {
        let seconds = max(0, seconds)
        return String(format: "%02d:%02d", seconds / 60, seconds % 60)
    }
}
