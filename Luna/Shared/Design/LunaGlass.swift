import SwiftUI

extension View {
    /// System glass, or the opaque fallback with a border under Reduce Transparency.
    /// See docs/design/design-reference.md#materials-and-elevation.
    func lunaGlass(in shape: some Shape) -> some View {
        modifier(LunaGlassModifier(shape: AnyShape(shape)))
    }
}

private struct LunaGlassModifier: ViewModifier {
    let shape: AnyShape
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency

    func body(content: Content) -> some View {
        if reduceTransparency {
            content
                .background(Color.glassFallback, in: shape)
                .overlay(shape.stroke(Color.glassBorder, lineWidth: 1))
                .lunaShadow(.floating)
        } else {
            content.glassEffect(.regular, in: shape)
        }
    }
}
