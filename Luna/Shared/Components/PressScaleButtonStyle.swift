import SwiftUI

/// Scales the label while pressed. No scale under Reduce Motion.
/// Use a `LunaMotion.PressScale` value for `scale`.
struct PressScaleButtonStyle: ButtonStyle {
    let scale: CGFloat
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(Self.effectiveScale(scale, isPressed: configuration.isPressed, reduceMotion: reduceMotion))
            .animation(.easeOut(duration: LunaMotion.instant), value: configuration.isPressed)
    }

    /// The scale to draw: `scale` while pressed, else 1. Always 1 under Reduce Motion.
    static func effectiveScale(_ scale: CGFloat, isPressed: Bool, reduceMotion: Bool) -> CGFloat {
        isPressed && !reduceMotion ? scale : 1
    }
}
