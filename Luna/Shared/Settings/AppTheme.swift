import SwiftUI

/// The theme choice in Settings. Dark is the default.
/// See docs/features/settings-and-appearance.md#decisions.
enum AppTheme: String, CaseIterable, Sendable {
    case dark
    case light
    case system

    static let defaultValue = AppTheme.dark

    /// The value for `preferredColorScheme`. `nil` follows the system.
    var colorScheme: ColorScheme? {
        switch self {
        case .dark: .dark
        case .light: .light
        case .system: nil
        }
    }
}
