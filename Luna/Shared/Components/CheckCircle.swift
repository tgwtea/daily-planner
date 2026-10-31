import SwiftUI

/// A round check button for blocks, steps, Anytime tasks, habits, and proposals.
/// See docs/design/design-reference.md#reusable-patterns.
struct CheckCircle: View {
    enum Size {
        /// Routine and Edit block steps.
        case small
        /// Blocks and Anytime tasks.
        case regular
        /// Habits.
        case large

        var diameter: CGFloat {
            switch self {
            case .small: 18
            case .regular: 26
            case .large: 30
            }
        }

        var ringWidth: CGFloat { self == .small ? 1.75 : 2 }
        var checkSize: CGFloat {
            switch self {
            case .small: 11
            case .regular: 14
            case .large: 16
            }
        }
    }

    var isOn: Bool
    /// The ring color when on, and the fill. Usually the block color.
    var tint: Color
    /// The ring color when off. `nil` uses `tint`.
    var offRing: Color?
    var checkColor: Color = BlockColor.ink
    var size: Size = .regular
    var label = "Complete"
    /// A number in the circle while it is off. A multi-count habit shows its count.
    var count: Int?
    var action: () -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        Button(action: action) {
            ZStack {
                Circle().fill(isOn ? tint : .clear)
                Circle().strokeBorder(isOn ? tint : (offRing ?? tint), lineWidth: size.ringWidth)
                Image(systemName: "checkmark")
                    .font(.system(size: size.checkSize, weight: .heavy))
                    .foregroundStyle(checkColor)
                    .opacity(isOn ? 1 : 0)
                if let count, !isOn {
                    // 11 pt bold.
                    Text(count, format: .number)
                        .font(.caption2.weight(.bold))
                        .monospacedDigit()
                        .foregroundStyle(Color.textPrimary)
                        .minimumScaleFactor(0.6)
                }
            }
            .frame(width: size.diameter, height: size.diameter)
            .animation(LunaMotion.animation(.easeOut(duration: LunaMotion.fast), reduceMotion: reduceMotion), value: isOn)
            .frame(minWidth: LunaSpacing.minHitTarget, minHeight: LunaSpacing.minHitTarget)
            .contentShape(Rectangle())
        }
        .buttonStyle(PressScaleButtonStyle(scale: LunaMotion.PressScale.checkMark))
        .accessibilityLabel(label)
        .accessibilityAddTraits(isOn ? .isSelected : [])
    }
}

#Preview("Dark") {
    CheckCirclePreview().preferredColorScheme(.dark)
}

#Preview("Light") {
    CheckCirclePreview().preferredColorScheme(.light)
}

private struct CheckCirclePreview: View {
    @State private var on = [false, true, false, true, false, true]

    var body: some View {
        HStack(spacing: 0) {
            CheckCircle(isOn: on[0], tint: BlockColor.slate.color) { on[0].toggle() }
            CheckCircle(isOn: on[1], tint: BlockColor.slate.color) { on[1].toggle() }
            CheckCircle(isOn: on[2], tint: BlockColor.rose.color, offRing: .borderStrong, size: .small) { on[2].toggle() }
            CheckCircle(isOn: on[3], tint: BlockColor.rose.color, size: .small) { on[3].toggle() }
            CheckCircle(isOn: on[4], tint: BlockColor.sage.color, size: .large, count: 5) { on[4].toggle() }
            CheckCircle(isOn: on[5], tint: .textPrimary, offRing: .borderStrong, checkColor: .textInverse) { on[5].toggle() }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.bgCanvas)
    }
}
