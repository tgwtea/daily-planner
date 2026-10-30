import SwiftUI

/// Motion tokens from docs/design/design-reference.md#motion.
enum LunaMotion {
    /// Press feedback.
    static let instant: TimeInterval = 0.12
    /// Check fill, selection, tab change.
    static let fast: TimeInterval = 0.18
    /// Chevron rotate, pill color, progress bars.
    static let normal: TimeInterval = 0.25
    /// Ring progress, swipe reveal, hero pill height.
    static let slow: TimeInterval = 0.35

    /// The slight-overshoot spring for selection and pill changes.
    static let selectionSpring = Animation.spring(duration: 0.25, bounce: 0.15)

    /// The scale of a control while the user presses it.
    enum PressScale {
        static let standard: CGFloat = 0.97
        static let iconButton: CGFloat = 0.94
        /// Check marks and the "+" button (mockup: 0.88–0.92).
        static let checkMark: CGFloat = 0.90
    }

    /// Returns `nil` when Reduce Motion is on, so that the change happens at once.
    static func animation(_ animation: Animation, reduceMotion: Bool) -> Animation? {
        reduceMotion ? nil : animation
    }
}
