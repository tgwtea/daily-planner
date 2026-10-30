/// The `@AppStorage` keys of the app, in one place.
/// See docs/features/settings-and-appearance.md.
enum SettingsKey {
    static let theme = "theme"
    /// Today scrolls to the now line on open. Default on. Settings edits it in 1b.5.
    static let scrollToNow = "scrollToNow"
    /// Today shows free gap rows. Default on. Settings edits it in 1b.5.
    static let showFreeTime = "showFreeTime"
}
