import SwiftUI
import Testing
@testable import Luna

@Suite struct AppThemeTests {
    @Test func defaultIsDark() {
        #expect(AppTheme.defaultValue == .dark)
    }

    @Test func mapsToColorScheme() {
        #expect(AppTheme.dark.colorScheme == .dark)
        #expect(AppTheme.light.colorScheme == .light)
        #expect(AppTheme.system.colorScheme == nil)
    }

    @Test func rawValuesAreStable() {
        #expect(AppTheme.allCases.map(\.rawValue) == ["dark", "light", "system"])
    }
}
