import SwiftUI

/// A capsule button with an icon, a label, an optional count, and an optional chevron.
/// Band headers, Anytime, Plan, and quick-add chips use it.
/// See docs/design/design-reference.md#reusable-patterns.
struct ChipButton: View {
    var title: String
    var systemImage: String?
    var count: Int?
    /// `nil` hides the chevron. `false` turns it −90°.
    var isExpanded: Bool?
    /// The 30 pt quick-add size. The default is 34 pt.
    var isCompact = false
    var action: () -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                if let systemImage {
                    Image(systemName: systemImage)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(Color.iconSecondary)
                }
                Text(title)
                if let count {
                    Text(count, format: .number)
                        .monospacedDigit()
                        .foregroundStyle(Color.textTertiary)
                }
                if let isExpanded {
                    Image(systemName: "chevron.down")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(Color.iconSecondary)
                        .rotationEffect(.degrees(isExpanded ? 0 : -90))
                        .animation(
                            LunaMotion.animation(.easeInOut(duration: LunaMotion.normal), reduceMotion: reduceMotion),
                            value: isExpanded
                        )
                }
            }
            .lunaTextStyle(.label)
            .foregroundStyle(Color.textPrimary)
            .padding(.horizontal, 12)
            .frame(minHeight: isCompact ? 30 : 34)
            .background(Color.surfacePrimary, in: Capsule())
            .frame(minHeight: LunaSpacing.minHitTarget)
            .contentShape(Rectangle())
        }
        .buttonStyle(PressScaleButtonStyle(scale: LunaMotion.PressScale.standard))
        .accessibilityLabel(Self.accessibilityLabel(title: title, count: count))
        .accessibilityValue(isExpanded.map { $0 ? "Expanded" : "Collapsed" } ?? "")
    }

    /// "Morning, 4 items", or the title alone without a count.
    static func accessibilityLabel(title: String, count: Int?) -> String {
        guard let count else { return title }
        return "\(title), \(count) \(count == 1 ? "item" : "items")"
    }
}

#Preview("Dark") {
    ChipButtonPreview().preferredColorScheme(.dark)
}

#Preview("Light") {
    ChipButtonPreview().preferredColorScheme(.light)
}

private struct ChipButtonPreview: View {
    @State private var expanded = true

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ChipButton(title: "Morning", systemImage: "sunrise", count: 4, isExpanded: expanded) { expanded.toggle() }
            ChipButton(title: "Anytime", systemImage: "clock", count: 3, isExpanded: true) {}
            ChipButton(title: "Plan", systemImage: "sparkles") {}
            ChipButton(title: "Today", systemImage: "calendar", isCompact: true) {}
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.bgCanvas)
    }
}
