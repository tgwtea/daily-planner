import SwiftUI

/// Text styles from docs/design/design-reference.md#typography.
///
/// Each style has the mockup size in points and scales with Dynamic Type
/// relative to the nearest system text style.
enum LunaTextStyle: CaseIterable, Sendable {
    case lockScreenClock
    case focusTimer
    case largeTitle
    case calendarTitle
    case editTitle
    case sheetTitle
    case liveActivityTimer
    case sectionHeading
    case rowTitle
    case dayNumber
    case body
    case label
    case meta
    case timeLabel
    case tabLabel

    var size: CGFloat {
        switch self {
        case .lockScreenClock: 104
        case .focusTimer: 72
        case .largeTitle: 34
        case .calendarTitle: 28
        case .editTitle: 26
        case .sheetTitle: 24
        case .liveActivityTimer: 30
        case .sectionHeading: 20
        case .rowTitle, .dayNumber: 17
        case .body: 16
        case .label: 15
        case .meta: 13
        case .timeLabel: 12
        case .tabLabel: 10
        }
    }

    var weight: Font.Weight {
        switch self {
        case .lockScreenClock, .focusTimer, .largeTitle, .calendarTitle,
             .editTitle, .sheetTitle, .liveActivityTimer:
            .bold
        case .sectionHeading, .rowTitle, .dayNumber, .label, .tabLabel:
            .semibold
        case .timeLabel:
            .medium
        case .body, .meta:
            .regular
        }
    }

    /// Letter spacing as a fraction of the font size (CSS `em`).
    var trackingEm: CGFloat {
        switch self {
        case .lockScreenClock: -0.045
        case .focusTimer: -0.035
        case .largeTitle: -0.025
        case .calendarTitle, .editTitle, .sheetTitle, .liveActivityTimer: -0.02
        case .sectionHeading: -0.01
        default: 0
        }
    }

    /// The Dynamic Type style that the size scales with.
    var relativeTo: Font.TextStyle {
        switch self {
        case .lockScreenClock, .focusTimer, .largeTitle: .largeTitle
        case .calendarTitle, .editTitle: .title
        case .sheetTitle, .liveActivityTimer: .title2
        case .sectionHeading: .title3
        case .rowTitle, .dayNumber: .headline
        case .body: .body
        case .label: .subheadline
        case .meta: .footnote
        case .timeLabel: .caption
        case .tabLabel: .caption2
        }
    }

    /// Times, counts, and timers use tabular figures.
    var usesTabularFigures: Bool {
        switch self {
        case .lockScreenClock, .focusTimer, .liveActivityTimer, .dayNumber, .timeLabel: true
        default: false
        }
    }
}

extension View {
    /// Applies the font, tracking, and figure style of a Luna text style.
    func lunaTextStyle(_ style: LunaTextStyle) -> some View {
        modifier(LunaTextStyleModifier(style: style))
    }
}

private struct LunaTextStyleModifier: ViewModifier {
    let style: LunaTextStyle
    @ScaledMetric private var size: CGFloat

    init(style: LunaTextStyle) {
        self.style = style
        _size = ScaledMetric(wrappedValue: style.size, relativeTo: style.relativeTo)
    }

    func body(content: Content) -> some View {
        let font = Font.system(size: size, weight: style.weight)
        content
            .font(style.usesTabularFigures ? font.monospacedDigit() : font)
            .tracking(size * style.trackingEm)
    }
}
