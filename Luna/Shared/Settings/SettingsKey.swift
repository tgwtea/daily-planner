enum SettingsKey {
    static let theme = "theme"
    static let scrollToNow = "scrollToNow"
    static let showFreeTime = "showFreeTime"
    static let showCalendarEvents = "showCalendarEvents"
    static let morningStart = "morningStart"
    static let afternoonStart = "afternoonStart"
    static let nightStart = "nightStart"
    static let liveActivity = "liveActivity"
    static let haptics = "haptics"
    static let endOfBlockSound = "endOfBlockSound"
    static let planSuggestions = "planSuggestions"
    /// The last Quick add color and icon. The next Quick add starts with them.
    static let quickAddColor = "quickAddColor"
    static let quickAddIcon = "quickAddIcon"

    static let all = [
        theme, scrollToNow, showFreeTime, showCalendarEvents,
        morningStart, afternoonStart, nightStart,
        liveActivity, haptics, endOfBlockSound, planSuggestions,
        quickAddColor, quickAddIcon,
    ]
}
