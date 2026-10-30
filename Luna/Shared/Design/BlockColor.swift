import SwiftUI

/// The five muted colors a user can give a block, habit, or project.
/// See docs/design/design-reference.md#block-colors. The case order is the order in pickers.
enum BlockColor: String, CaseIterable, Identifiable, Sendable {
    case rose, slate, sage, sand, plum

    /// The color of an icon or check mark on a block color, in both themes.
    static let ink = Color(hex: 0x151517)

    /// The ink opacity for the icon of a done block.
    static let doneInkOpacity = 0.55

    var id: Self { self }

    var displayName: String {
        switch self {
        case .rose: "Rose"
        case .slate: "Slate"
        case .sage: "Sage"
        case .sand: "Sand"
        case .plum: "Plum"
        }
    }

    /// The sRGB conversion of the oklch source value. The same value is used in both themes.
    var color: Color {
        switch self {
        case .rose: Color(hex: 0xD09293)
        case .slate: Color(hex: 0x88A5BF)
        case .sage: Color(hex: 0x93B99A)
        case .sand: Color(hex: 0xD4BA8E)
        case .plum: Color(hex: 0xAE86AA)
        }
    }

    /// The fill of a done block: 38% block color, 62% canvas.
    /// The mockup mixes in oklch. The perceptual color space is the nearest native match.
    var doneColor: Color {
        color.mix(with: .bgCanvas, by: 0.62, in: .perceptual)
    }
}
