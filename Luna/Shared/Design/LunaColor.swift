import SwiftUI
import UIKit

/// Semantic color roles from docs/design/design-reference.md#color.
///
/// Each role resolves for the current appearance and the Increase Contrast setting.
/// Views use these roles only. They never use raw hex values.
extension Color {
    // MARK: Backgrounds

    static let bgCanvas = dynamic(dark: .hex(0x000000), light: .hex(0xFFFFFF))
    static let bgSecondary = dynamic(dark: .hex(0x1A1A1A), light: .hex(0xF5F5F5))

    // MARK: Surfaces

    static let surfacePrimary = dynamic(dark: .hex(0x1C1C1E), light: .hex(0xF2F2F3))
    static let surfaceSecondary = dynamic(dark: .hex(0x2C2C2E), light: .hex(0xE8E8EA))
    static let surfaceTertiary = dynamic(dark: .hex(0x3A3A3C), light: .hex(0xD6D6D9))
    static let surfaceInteractive = dynamic(dark: .hex(0x3C3C3C), light: .hex(0xE3E3E6))
    static let surfaceRaised = dynamic(dark: .hex(0x434343), light: .hex(0xFFFFFF))
    static let surfaceHover = dynamic(dark: .white(0.06), light: .black(0.04))

    // MARK: Text and icons

    static let textPrimary = dynamic(dark: .hex(0xFFFFFF), light: .hex(0x111111))
    static let textSecondary = dynamic(
        dark: .hex(0x98989D), light: .hex(0x6B6B70),
        highContrastDark: .hex(0xC7C7CC), highContrastLight: .hex(0x3D3D40)
    )
    static let textTertiary = dynamic(
        dark: .hex(0x7C7C81), light: .hex(0x86868B),
        highContrastDark: .hex(0x98989D), highContrastLight: .hex(0x6B6B70)
    )
    static let textInverse = dynamic(dark: .hex(0x000000), light: .hex(0xFFFFFF))
    static let iconSecondary = dynamic(dark: .hex(0x98989D), light: .hex(0x6B6B70))

    // MARK: Borders and dividers

    static let borderSubtle = dynamic(
        dark: .white(0.08), light: .black(0.06),
        highContrastDark: .white(0.20), highContrastLight: .black(0.18)
    )
    static let borderStandard = dynamic(
        dark: .white(0.12), light: .black(0.10),
        highContrastDark: .white(0.32), highContrastLight: .black(0.28)
    )
    static let borderStrong = dynamic(dark: .white(0.24), light: .black(0.22))
    static let dividerDefault = dynamic(
        dark: .white(0.10), light: .black(0.08),
        highContrastDark: .white(0.24), highContrastLight: .black(0.20)
    )

    // MARK: Actions and overlays

    static let actionPrimaryBackground = dynamic(dark: .hex(0xFFFFFF), light: .hex(0x000000))
    static let actionPrimaryForeground = dynamic(dark: .hex(0x000000), light: .hex(0xFFFFFF))
    static let overlayScrim = dynamic(dark: .black(0.54), light: .black(0.24))
    /// The lighter scrim behind the Inbox drawer.
    static let drawerScrim = Color(uiColor: .black(0.18))

    // MARK: Glass

    static let glassBackground = dynamic(
        dark: UIColor(red: 58 / 255, green: 58 / 255, blue: 60 / 255, alpha: 0.74),
        light: UIColor(red: 246 / 255, green: 246 / 255, blue: 248 / 255, alpha: 0.78)
    )
    /// The opaque glass color under Reduce Transparency.
    static let glassFallback = dynamic(dark: .hex(0x2C2C2E), light: .hex(0xF9F9F9))
    static let glassBorder = dynamic(dark: .white(0.12), light: .black(0.08))
    static let glassItemHover = dynamic(dark: .white(0.10), light: .black(0.06))
}

extension Color {
    /// An opaque sRGB color from a `0xRRGGBB` value.
    init(hex: UInt32) {
        self.init(uiColor: .hex(hex))
    }
}

private extension Color {
    /// A color that resolves per appearance. An unspecified appearance uses dark, the design default.
    static func dynamic(
        dark: UIColor,
        light: UIColor,
        highContrastDark: UIColor? = nil,
        highContrastLight: UIColor? = nil
    ) -> Color {
        Color(uiColor: UIColor { traits in
            let highContrast = traits.accessibilityContrast == .high
            if traits.userInterfaceStyle == .light {
                return highContrast ? (highContrastLight ?? light) : light
            }
            return highContrast ? (highContrastDark ?? dark) : dark
        })
    }
}

private extension UIColor {
    static func hex(_ value: UInt32) -> UIColor {
        UIColor(
            red: CGFloat((value >> 16) & 0xFF) / 255,
            green: CGFloat((value >> 8) & 0xFF) / 255,
            blue: CGFloat(value & 0xFF) / 255,
            alpha: 1
        )
    }

    static func white(_ alpha: CGFloat) -> UIColor {
        UIColor(white: 1, alpha: alpha)
    }

    static func black(_ alpha: CGFloat) -> UIColor {
        UIColor(white: 0, alpha: alpha)
    }
}
