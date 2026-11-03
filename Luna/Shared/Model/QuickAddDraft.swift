import Foundation

/// What a "+" button puts into Quick add before the user types (decided 2026-10-30).
/// A token in the text wins over the pre-fill.
enum QuickAddPrefill: Hashable, Sendable {
    /// The header "+", the tab bar "+", "Add block", and "Add to Inbox".
    case none
    /// A band "+": the next free time in that band.
    case time(Date)
    /// The Anytime "+": an Anytime task on that day.
    case anytime(day: Date)

    /// The pre-fill of a band "+": the first free 30 min slot of the band, or the band start when the band is full.
    static func band(
        _ band: Band, day: Date, blocks: [Block], now: Date, schedule: BandSchedule, calendar: Calendar
    ) -> QuickAddPrefill {
        if let start = SlotSearch.firstFreeSlot(
            durationMinutes: QuickAddDraft.defaultDuration, in: band, day: day,
            blocks: blocks, now: now, schedule: schedule, calendar: calendar
        ) {
            return .time(start)
        }
        let dayStart = calendar.startOfDay(for: day)
        return .time(LocalTime.boundary(minute: schedule.start(of: band), on: dayStart, calendar: calendar) ?? dayStart)
    }
}

/// The values that Quick add reads besides the draft.
struct QuickAddContext {
    var now: Date
    var calendar: Calendar
    var schedule: BandSchedule = .standard
}

/// The state of the Quick add sheet. The text is the one source for the day, time, and duration.
/// The pickers write tokens into the text, so the text and the chips stay in sync.
/// See docs/features/quick-add-parsing.md.
struct QuickAddDraft {
    static let defaultDuration = 30
    /// The choices of the Duration tool.
    static let durationChoices = [15, 30, 45, 60, 90, 120]

    enum Destination: Equatable {
        case block(start: Date, durationMinutes: Int)
        case anytime(day: Date)
        case inbox(durationMinutes: Int)
        case invalid([QuickAddParser.Issue])

        var isBlock: Bool {
            if case .block = self { return true }
            return false
        }
    }

    var text = ""
    var prefill: QuickAddPrefill = .none
    var color: BlockColor = .rose
    var icon = "phone"
    var repeatRule: RepeatRule = .never
    var steps: [String] = []

    func parsed(_ context: QuickAddContext) -> QuickAddParser.Result {
        QuickAddParser.parse(text, now: context.now, calendar: context.calendar)
    }

    // MARK: Values

    /// The day from the text, else from the pre-fill.
    func day(_ context: QuickAddContext) -> Date? {
        if let day = parsed(context).day { return day }
        switch prefill {
        case .none: return nil
        case .time(let start): return context.calendar.startOfDay(for: start)
        case .anytime(let day): return context.calendar.startOfDay(for: day)
        }
    }

    /// The time from the text, else from a band pre-fill.
    func minute(_ context: QuickAddContext) -> Int? {
        if let minute = parsed(context).minute { return minute }
        if case .time(let start) = prefill { return Timeline.minuteOfDay(start, calendar: context.calendar) }
        return nil
    }

    /// Where Save puts the item.
    /// - A time gives a block on the day (default today). A block ends at 11:59 PM at the latest.
    /// - No time, with a day word or the Anytime pre-fill, gives an Anytime task on that day (decided 2026-10-30).
    /// - Else the item goes to the Inbox.
    func destination(_ context: QuickAddContext) -> Destination {
        let calendar = context.calendar
        let parsed = parsed(context)
        guard parsed.issues.isEmpty else { return .invalid(parsed.issues) }
        let duration = parsed.durationMinutes ?? Self.defaultDuration
        let day = day(context)
        if let minute = minute(context) {
            let dayStart = day ?? calendar.startOfDay(for: context.now)
            guard let start = LocalTime.date(minute: minute, on: dayStart, calendar: calendar) else {
                return .invalid([.nonexistentTime])
            }
            if let clamped = DayLimit.clampedDuration(duration, start: start, calendar: calendar) {
                return .block(start: start, durationMinutes: clamped)
            }
            // An 11:59 PM start leaves no time for a block. The item becomes an Anytime task on that day.
            return .anytime(day: dayStart)
        }
        if let day { return .anytime(day: day) }
        return .inbox(durationMinutes: duration)
    }

    /// The step titles without empty lines.
    var cleanSteps: [String] {
        steps.map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }.filter { !$0.isEmpty }
    }

    // MARK: Picker edits

    /// Writes the exact local date, including its Gregorian year.
    mutating func setDay(_ date: Date, _ context: QuickAddContext) {
        write(DayKey(date, calendar: context.calendar).token, over: parsed(context).dayRange)
    }

    func issues(_ context: QuickAddContext) -> [QuickAddParser.Issue] {
        if case .invalid(let issues) = destination(context) { return issues }
        return []
    }

    /// Writes the time as an am/pm token, for example "9:30am".
    mutating func setTime(minute: Int, _ context: QuickAddContext) {
        let hour = minute / 60 % 24
        let token = "\((hour + 11) % 12 + 1):\(String(format: "%02d", minute % 60))\(hour < 12 ? "am" : "pm")"
        write(token, over: parsed(context).timeRange)
    }

    /// Writes the duration as a token: "45m", or "2h" for whole hours.
    mutating func setDuration(_ minutes: Int, _ context: QuickAddContext) {
        let token = minutes % 60 == 0 ? "\(minutes / 60)h" : "\(minutes)m"
        write(token, over: parsed(context).durationRange)
    }

    /// Replaces the token range, or adds the token and a space at the end of the text.
    private mutating func write(_ token: String, over range: Range<String.Index>?) {
        if let range {
            text.replaceSubrange(range, with: token)
        } else {
            let separator = text.isEmpty || text.last?.isWhitespace == true ? "" : " "
            text += separator + token + " "
        }
    }

}
