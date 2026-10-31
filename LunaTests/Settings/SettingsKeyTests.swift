import Testing
@testable import Luna

@Suite struct SettingsKeyTests {
    @Test func keysAreUnique() {
        #expect(Set(SettingsKey.all).count == SettingsKey.all.count)
    }

    @Test func listHoldsEveryKey() {
        #expect(SettingsKey.all.count == 11)
        #expect(SettingsKey.all.contains(SettingsKey.planSuggestions))
    }
}
