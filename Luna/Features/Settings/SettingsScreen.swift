import SwiftUI

struct SettingsScreen: View {
    @Environment(AppRouter.self) private var router
    @Environment(\.calendar) private var calendar

    @BandScheduleStorage private var schedule
    @AppStorage(SettingsKey.showCalendarEvents) private var showCalendarEvents = true
    @AppStorage(SettingsKey.showFreeTime) private var showFreeTime = true
    @AppStorage(SettingsKey.scrollToNow) private var scrollToNow = true
    @AppStorage(SettingsKey.liveActivity) private var liveActivity = true
    @AppStorage(SettingsKey.haptics) private var haptics = true
    @AppStorage(SettingsKey.endOfBlockSound) private var endOfBlockSound = false
    @AppStorage(SettingsKey.planSuggestions) private var planSuggestions = true
    @AppStorage(SettingsKey.theme) private var theme = AppTheme.defaultValue

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {
                LargeTitleHeader(title: "Settings")
                    .padding(.horizontal, -LunaSpacing.screenMargin)

                GroupedSection(header: "Day bands", footer: "Blocks move into the band their start time falls in.") {
                    ForEach(Band.allCases) { band in
                        Button { router.push(.bandStart(band)) } label: {
                            GroupedRow(
                                title: band.displayName,
                                systemImage: band.systemImage,
                                value: BandStartText.label(minute: schedule.start(of: band), calendar: calendar),
                                showsChevron: true
                            )
                        }
                    }
                }

                GroupedSection(header: "Timeline") {
                    toggleRow("Show calendar events", isOn: $showCalendarEvents)
                    toggleRow("Show free time", isOn: $showFreeTime)
                    toggleRow("Scroll to now on open", isOn: $scrollToNow)
                }

                GroupedSection(header: "Calendars", footer: "Events are read-only. Luna never edits your calendar.") {
                    // The calendar picker comes with calendar access in checkpoint 2.2.
                    GroupedRow(
                        title: "Apple Calendar",
                        subtitle: "Work, Personal, Family",
                        systemImage: "calendar",
                        value: "On",
                        showsChevron: true
                    )
                }

                GroupedSection(header: "Focus") {
                    toggleRow("Live Activity", isOn: $liveActivity)
                    toggleRow("Haptics", isOn: $haptics)
                    toggleRow("End-of-block sound", isOn: $endOfBlockSound)
                }

                GroupedSection(
                    header: "Plan my day",
                    footer: "When on, Plan suggests times for Inbox tasks. Nothing is scheduled until you add it."
                ) {
                    toggleRow("Suggestions", isOn: $planSuggestions)
                }

                GroupedSection(header: "Appearance") {
                    Button { router.push(.theme) } label: {
                        GroupedRow(title: "Theme", value: theme.displayName, showsChevron: true)
                    }
                }
            }
            .buttonStyle(.plain)
            .padding(.horizontal, LunaSpacing.screenMargin)
            .padding(.top, 14)
            .padding(.bottom, LunaTabBar.height + LunaSpacing.sectionGap)
        }
        .scrollIndicators(.hidden)
        .background(Color.bgCanvas)
        .toolbar(.hidden, for: .navigationBar)
    }

    private func toggleRow(_ title: String, isOn: Binding<Bool>) -> some View {
        GroupedRow(title: title) {
            Toggle(title, isOn: isOn)
                .labelsHidden()
                .toggleStyle(.luna)
        }
    }
}

#Preview("Dark") {
    NavigationStack { SettingsScreen() }
        .environment(AppRouter())
        .preferredColorScheme(.dark)
}

#Preview("Light") {
    NavigationStack { SettingsScreen() }
        .environment(AppRouter())
        .preferredColorScheme(.light)
}
