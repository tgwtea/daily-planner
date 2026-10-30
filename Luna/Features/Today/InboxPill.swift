import SwiftUI

/// The glass "Inbox 5 ⌃" capsule that floats above the tab bar on Today. See docs/screens/today.md.
struct InboxPill: View {
    var count: Int
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: "tray")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(Color.iconSecondary)
                Text("Inbox")
                Text(count, format: .number)
                    .monospacedDigit()
                    .foregroundStyle(Color.textTertiary)
                Image(systemName: "chevron.up")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(Color.iconSecondary)
            }
            .font(.subheadline.weight(.semibold))
            .foregroundStyle(Color.textPrimary)
            .padding(.horizontal, 14)
            .frame(height: 36)
            .lunaGlass(in: Capsule())
            .frame(minHeight: LunaSpacing.minHitTarget)
            .contentShape(Capsule())
        }
        .buttonStyle(PressScaleButtonStyle(scale: LunaMotion.PressScale.standard))
        .accessibilityLabel(ChipButton.accessibilityLabel(title: "Inbox", count: count))
    }
}

#Preview("Dark") {
    InboxPill(count: 5) {}
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.bgCanvas)
        .preferredColorScheme(.dark)
}

#Preview("Light") {
    InboxPill(count: 5) {}
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.bgCanvas)
        .preferredColorScheme(.light)
}
