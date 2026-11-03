import Foundation

/// One parsed chip under the Quick add text field. See docs/screens/quick-add.md#layout-top-to-bottom.
struct QuickAddChip: Identifiable, Equatable {
    enum Kind: Hashable {
        case day, time, band, destination, duration, repeatRule, checklist, color
    }

    var kind: Kind
    var title: String
    var systemImage: String?
    /// The color dot of the color chip.
    var dot: BlockColor?
    var accessibilityLabel: String

    var id: Kind { kind }
}

extension QuickAddDraft {
    /// The chips in the mockup order: day, time and band (or the destination), duration, then color.
    /// The repeat and checklist chips show only for a block.
    func chips(_ context: QuickAddContext) -> [QuickAddChip] {
        var chips: [QuickAddChip] = []
        let calendar = context.calendar
        let destination = destination(context)

        if let day = day(context) {
            let title = Self.dayTitle(day, context)
            chips.append(QuickAddChip(kind: .day, title: title, systemImage: "calendar", accessibilityLabel: "Day, \(title)"))
        }

        if case .block(let start, _) = destination {
            let time = start.formatted(Self.style(Date.FormatStyle(date: .omitted, time: .shortened), calendar))
            let band = context.schedule.band(forMinute: Timeline.minuteOfDay(start, calendar: calendar))
            chips.append(QuickAddChip(kind: .time, title: time, systemImage: "clock", accessibilityLabel: "Time, \(time)"))
            chips.append(QuickAddChip(
                kind: .band, title: band.displayName, systemImage: band.systemImage,
                accessibilityLabel: "Band, \(band.displayName)"
            ))
        } else if case .anytime = destination {
            chips.append(QuickAddChip(kind: .destination, title: "Anytime", systemImage: "clock", accessibilityLabel: "Anytime"))
        } else if case .inbox = destination {
            chips.append(QuickAddChip(kind: .destination, title: "Inbox", systemImage: "tray", accessibilityLabel: "Inbox"))
        }

        if let minutes = parsed(context).durationMinutes {
            let title = DurationFormat.string(minutes: minutes)
            chips.append(QuickAddChip(kind: .duration, title: title, systemImage: "timer", accessibilityLabel: "Duration, \(title)"))
        }

        if destination.isBlock {
            if repeatRule != .never {
                chips.append(QuickAddChip(
                    kind: .repeatRule, title: repeatRule.displayName, systemImage: "repeat",
                    accessibilityLabel: "Repeat, \(repeatRule.displayName)"
                ))
            }
            let count = cleanSteps.count
            if count > 0 {
                let title = "\(count) \(count == 1 ? "step" : "steps")"
                chips.append(QuickAddChip(kind: .checklist, title: title, systemImage: "checklist", accessibilityLabel: "Checklist, \(title)"))
            }
        }

        chips.append(QuickAddChip(
            kind: .color, title: color.displayName, dot: color, accessibilityLabel: "Color, \(color.displayName)"
        ))
        return chips
    }

    /// "Today", "Tomorrow", or a short date such as "Fri, Nov 6".
    static func dayTitle(_ day: Date, _ context: QuickAddContext) -> String {
        let calendar = context.calendar
        let today = calendar.startOfDay(for: context.now)
        if calendar.isDate(day, inSameDayAs: today) { return "Today" }
        if let tomorrow = calendar.date(byAdding: .day, value: 1, to: today), calendar.isDate(day, inSameDayAs: tomorrow) {
            return "Tomorrow"
        }
        var format = Date.FormatStyle().weekday(.abbreviated).month(.abbreviated).day()
        if calendar.component(.year, from: day) != calendar.component(.year, from: today) {
            format = format.year()
        }
        return day.formatted(style(format, calendar))
    }

    /// The style in the calendar, time zone, and locale of `calendar`.
    private static func style(_ style: Date.FormatStyle, _ calendar: Calendar) -> Date.FormatStyle {
        var style = style
        style.calendar = calendar
        style.timeZone = calendar.timeZone
        style.locale = calendar.locale ?? .current
        return style
    }
}
