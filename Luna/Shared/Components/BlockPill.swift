import SwiftUI

/// The 52 pt capsule that shows a block on the timeline.
/// See docs/design/design-reference.md#reusable-patterns and docs/screens/today.md.
///
/// The pill is decoration. The block row states the done and active state in text.
struct BlockPill: View {
    enum Appearance: Equatable {
        case planned(BlockColor)
        case done(BlockColor)
        /// The block runs now. `progress` is 0...1 of its duration.
        case active(BlockColor, progress: Double)
        case event(isPast: Bool)
    }

    static let width: CGFloat = 52

    var appearance: Appearance
    var systemImage: String?
    var height: CGFloat
    /// A routine pill shows its icon at the top. Other pills center it.
    var iconAtTop = false
    var accessibilityLabel: String
    var action: (() -> Void)?

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        if let action {
            Button(action: action) { pill }
                .buttonStyle(PressScaleButtonStyle(scale: LunaMotion.PressScale.pill))
                .accessibilityLabel(accessibilityLabel)
        } else {
            pill.accessibilityHidden(true)
        }
    }

    private var pill: some View {
        Capsule()
            .fill(fill)
            .frame(width: Self.width, height: height)
            .overlay(alignment: iconAtTop ? .top : .center) {
                if let systemImage = appearance.isEvent ? "calendar" : systemImage {
                    Image(systemName: systemImage)
                        .font(.system(size: 20, weight: .regular))
                        .foregroundStyle(iconColor)
                        .padding(.top, iconAtTop ? (Self.width - 20) / 2 : 0)
                }
            }
            .animation(LunaMotion.animation(LunaMotion.selectionSpring, reduceMotion: reduceMotion), value: appearance)
            .contentShape(Capsule())
    }

    private var fill: AnyShapeStyle {
        switch appearance {
        case .planned(let color): AnyShapeStyle(color.color)
        case .done(let color): AnyShapeStyle(color.doneColor)
        case .active(let color, let progress):
            // A hard stop: full color down to the progress point, then the done tint.
            AnyShapeStyle(LinearGradient(
                stops: [
                    .init(color: color.color, location: 0),
                    .init(color: color.color, location: progress),
                    .init(color: color.doneColor, location: progress),
                    .init(color: color.doneColor, location: 1),
                ],
                startPoint: .top,
                endPoint: .bottom
            ))
        case .event(let isPast): AnyShapeStyle(isPast ? Color.surfaceSecondary : Color.surfaceTertiary)
        }
    }

    private var iconColor: Color {
        switch appearance {
        case .planned, .active: BlockColor.ink
        case .done: BlockColor.ink.opacity(BlockColor.doneInkOpacity)
        case .event(let isPast): isPast ? .textTertiary : .textPrimary
        }
    }
}

extension BlockPill.Appearance {
    /// The appearance of a block at `now`. Done wins over active.
    init(block: Block, now: Date) {
        guard let color = block.color, block.kind != .event else {
            self = .event(isPast: block.end <= now)
            return
        }
        if block.isDone {
            self = .done(color)
        } else if Timeline.isActive(block, at: now) {
            self = .active(color, progress: Timeline.progress(of: block, at: now))
        } else {
            self = .planned(color)
        }
    }

    var isEvent: Bool {
        if case .event = self { true } else { false }
    }
}

#Preview("Dark") {
    BlockPillPreview().preferredColorScheme(.dark)
}

#Preview("Light") {
    BlockPillPreview().preferredColorScheme(.light)
}

private struct BlockPillPreview: View {
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            BlockPill(appearance: .planned(.slate), systemImage: "laptopcomputer", height: 97, accessibilityLabel: "Deep work") {}
            BlockPill(appearance: .active(.rose, progress: 0.4), systemImage: "doc.text", height: 82, accessibilityLabel: "Write") {}
            BlockPill(appearance: .done(.sage), systemImage: "dumbbell", height: 67, accessibilityLabel: "Gym") {}
            BlockPill(appearance: .planned(.sand), systemImage: "sunrise", height: 164, iconAtTop: true, accessibilityLabel: "Morning routine") {}
            BlockPill(appearance: .event(isPast: false), height: 67, accessibilityLabel: "Standup")
            BlockPill(appearance: .event(isPast: true), height: 67, accessibilityLabel: "Sync")
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.bgCanvas)
    }
}
