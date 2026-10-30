import CoreGraphics

/// Spacing and size tokens from docs/design/design-reference.md#spacing-and-size.
/// Where the mockup gives a range, the token is a value on the 4 pt rhythm inside that range.
enum LunaSpacing {
    static let unit: CGFloat = 4
    static let screenMargin: CGFloat = 20
    static let weekStripMargin: CGFloat = 12
    /// Gap between sections (mockup: 22–28 pt).
    static let sectionGap: CGFloat = 24
    /// Gap between a section header and its group (mockup: 8–14 pt).
    static let sectionHeaderGap: CGFloat = 12
    /// Grouped list row padding (mockup: 10–14 pt vertical, 14–16 pt horizontal).
    static let rowVerticalPadding: CGFloat = 12
    static let rowHorizontalPadding: CGFloat = 16
    static let cardPadding: CGFloat = 20
    static let minHitTarget: CGFloat = 44

    /// Timeline grid columns. The text column takes the rest of the width.
    enum Timeline {
        static let timeColumn: CGFloat = 44
        static let pillColumn: CGFloat = 52
        static let checkColumn: CGFloat = 44
        static let columnGap: CGFloat = 12
    }
}
