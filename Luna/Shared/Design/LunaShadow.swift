import SwiftUI

/// Shadow tokens from docs/design/design-reference.md#materials-and-elevation.
/// Content cards have no shadow. Only floating controls and overlays use one.
enum LunaShadow {
    /// Floating controls: CSS `0 6 20`, black 36% (14% light).
    case floating
    /// Overlays, sheets, and the drag ghost: CSS `0 -18 48`, black 44% (16% light).
    case overlay

    var y: CGFloat {
        switch self {
        case .floating: 6
        case .overlay: -18
        }
    }

    /// Half of the CSS blur value. A SwiftUI shadow radius spreads about twice as far as a CSS blur.
    var radius: CGFloat {
        switch self {
        case .floating: 10
        case .overlay: 24
        }
    }

    func opacity(for colorScheme: ColorScheme) -> Double {
        switch (self, colorScheme) {
        case (.floating, .light): 0.14
        case (.floating, _): 0.36
        case (.overlay, .light): 0.16
        case (.overlay, _): 0.44
        }
    }
}

extension View {
    func lunaShadow(_ shadow: LunaShadow) -> some View {
        modifier(LunaShadowModifier(shadow: shadow))
    }
}

private struct LunaShadowModifier: ViewModifier {
    let shadow: LunaShadow
    @Environment(\.colorScheme) private var colorScheme

    func body(content: Content) -> some View {
        content.shadow(
            color: .black.opacity(shadow.opacity(for: colorScheme)),
            radius: shadow.radius,
            y: shadow.y
        )
    }
}
