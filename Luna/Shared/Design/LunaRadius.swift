import CoreGraphics

/// Corner radius tokens from docs/design/design-reference.md#shape.
/// Buttons, chips, and the tab bar use `Capsule`. Icon buttons and check marks use `Circle`.
enum LunaRadius {
    static let iconBox: CGFloat = 8
    static let textField: CGFloat = 12
    /// Anytime and Inbox icon tiles (mockup: 12–14 pt).
    static let iconTile: CGFloat = 12
    static let iconPickerCell: CGFloat = 16
    static let groupedList: CGFloat = 20
    static let card: CGFloat = 24
    static let dialog: CGFloat = 28
    static let sheet: CGFloat = 36
    /// Half of the 52 pt timeline pill width.
    static let timelinePill: CGFloat = 26
}
