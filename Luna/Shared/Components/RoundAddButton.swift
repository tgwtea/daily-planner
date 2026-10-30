import SwiftUI

/// A 34 pt round "+" button for band headers and Anytime.
/// See docs/design/design-reference.md#reusable-patterns.
struct RoundAddButton: View {
    /// For example "Add to Morning".
    var label: String
    var action: () -> Void

    static let diameter: CGFloat = 34

    var body: some View {
        Button(action: action) {
            Image(systemName: "plus")
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(Color.iconSecondary)
                .frame(width: Self.diameter, height: Self.diameter)
                .background(Color.surfacePrimary, in: Circle())
                .frame(minWidth: LunaSpacing.minHitTarget, minHeight: LunaSpacing.minHitTarget)
                .contentShape(Rectangle())
        }
        .buttonStyle(PressScaleButtonStyle(scale: LunaMotion.PressScale.iconButton))
        .accessibilityLabel(label)
    }
}

#Preview("Dark") {
    RoundAddButton(label: "Add to Anytime") {}
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.bgCanvas)
        .preferredColorScheme(.dark)
}

#Preview("Light") {
    RoundAddButton(label: "Add to Anytime") {}
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.bgCanvas)
        .preferredColorScheme(.light)
}
