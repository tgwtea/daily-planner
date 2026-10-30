import SwiftUI

/// The Today tab: one day as a timeline. See docs/screens/today.md.
struct TodayScreen: View {
    @Environment(PlannerStore.self) private var store
    @Environment(AppRouter.self) private var router
    @Environment(\.appClock) private var clock
    @Environment(\.calendar) private var calendar
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @AppStorage(SettingsKey.scrollToNow) private var scrollToNow = true
    @AppStorage(SettingsKey.showFreeTime) private var showFreeTime = true

    /// `nil` follows the current day of the clock.
    @State private var pickedDay: Date?
    @State private var collapsedBands: Set<Band> = []
    @State private var isAnytimeExpanded = true
    @State private var didScrollToNow = false

    /// Settings edits the band starts in 1b.5.
    private let schedule = BandSchedule.standard

    var body: some View {
        TimelineView(.everyMinute) { _ in
            let now = clock.now()
            let day = pickedDay ?? now
            let plan = DayPlan.make(
                blocks: store.blocks(on: day, calendar: calendar),
                schedule: schedule, calendar: calendar, showFreeTime: showFreeTime
            )
            ScrollViewReader { proxy in
                ScrollView {
                    content(day: day, now: now, plan: plan)
                        .padding(.bottom, 170)
                }
                .scrollIndicators(.hidden)
                .onAppear { scrollToNowIfNeeded(plan: plan, day: day, now: now, proxy: proxy) }
            }
        }
        .background(Color.bgCanvas)
        .toolbar(.hidden, for: .navigationBar)
        .overlay(alignment: .bottom) {
            if !store.inboxItems.isEmpty {
                // Temporary: the Inbox drawer comes in 1c.2 (decided 2026-10-31).
                InboxPill(count: store.inboxItems.count) { router.selectedTab = .inbox }
                    .padding(.bottom, LunaTabBar.height + LunaSpacing.unit)
            }
        }
    }

    private func content(day: Date, now: Date, plan: DayPlan) -> some View {
        let isToday = calendar.isDate(day, inSameDayAs: now)
        return VStack(alignment: .leading, spacing: 0) {
            LargeTitleHeader(title: isToday ? "Today" : TimeText.weekday(day), subtitle: TimeText.dateLine(day)) {
                headerButtons(isToday: isToday)
            }
            .padding(.top, 14)

            WeekStripView(selectedDay: dayBinding(now: now), today: now, calendar: calendar) { date in
                !store.blocks(on: date, calendar: calendar).isEmpty
            }
            .padding(.top, 18)

            HabitStripView(habits: store.habits, day: day, calendar: calendar)
                .padding(.top, 18)

            Group {
                if plan.isEmpty {
                    EmptyDayView(day: day, schedule: schedule, calendar: calendar)
                        .padding(.top, 20)
                } else {
                    timeline(day: day, now: now, plan: plan)
                        .padding(.top, 22)
                }
            }
            .padding(.horizontal, LunaSpacing.screenMargin)
        }
    }

    private func timeline(day: Date, now: Date, plan: DayPlan) -> some View {
        VStack(alignment: .leading, spacing: 22) {
            AnytimeSection(tasks: store.anytimeTasks(on: day, calendar: calendar), isExpanded: $isAnytimeExpanded)
            ForEach(plan.sections) { section in
                BandSectionView(
                    section: section,
                    now: now,
                    overlappingIDs: plan.overlappingIDs,
                    isCollapsed: collapsedBinding(section.band)
                )
            }
            let count = plan.doneCount
            if count.total > 0 {
                Text("\(count.done) of \(count.total) blocks done")
                    .lunaTextStyle(.meta)
                    .monospacedDigit()
                    .foregroundStyle(Color.textTertiary)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 6)
            }
        }
    }

    @ViewBuilder
    private func headerButtons(isToday: Bool) -> some View {
        if !isToday {
            ChipButton(title: "Today", isCompact: true) {
                withAnimation(LunaMotion.animation(.easeOut(duration: LunaMotion.fast), reduceMotion: reduceMotion)) {
                    pickedDay = nil
                }
            }
            .fixedSize()
        }
        // The Plan sheet comes in 1c.4.
        ChipButton(title: "Plan", systemImage: "sparkles") {}
            .fixedSize()
        Button("Calendar", systemImage: "calendar") { router.push(.calendar) }
            .labelStyle(.iconOnly)
            .font(.system(size: 18, weight: .medium))
            .foregroundStyle(Color.textPrimary)
            .frame(width: LunaSpacing.minHitTarget, height: LunaSpacing.minHitTarget)
            .lunaGlass(in: Circle())
            .contentShape(Circle())
            .buttonStyle(PressScaleButtonStyle(scale: LunaMotion.PressScale.iconButton))
    }

    private func dayBinding(now: Date) -> Binding<Date> {
        Binding(
            get: { pickedDay ?? now },
            set: { pickedDay = calendar.isDate($0, inSameDayAs: now) ? nil : $0 }
        )
    }

    private func collapsedBinding(_ band: Band) -> Binding<Bool> {
        Binding(
            get: { collapsedBands.contains(band) },
            set: { if $0 { collapsedBands.insert(band) } else { collapsedBands.remove(band) } }
        )
    }

    /// Scrolls once to the active block, or to the next block of today ("Scroll to now on open").
    private func scrollToNowIfNeeded(plan: DayPlan, day: Date, now: Date, proxy: ScrollViewProxy) {
        guard scrollToNow, !didScrollToNow, calendar.isDate(day, inSameDayAs: now) else { return }
        didScrollToNow = true
        let blocks = plan.blocks.filter { !collapsedBands.contains(Timeline.band(of: $0, schedule: schedule, calendar: calendar)) }
        guard let target = blocks.first(where: { Timeline.isActive($0, at: now) }) ?? blocks.first(where: { $0.start > now })
        else { return }
        Task { @MainActor in
            proxy.scrollTo(target.id, anchor: UnitPoint(x: 0.5, y: 0.35))
        }
    }
}

#Preview("Dark") {
    NavigationStack { TodayScreen() }
        .environment(AppRouter())
        .sampleEnvironment()
        .preferredColorScheme(.dark)
}

#Preview("Light") {
    NavigationStack { TodayScreen() }
        .environment(AppRouter())
        .sampleEnvironment()
        .preferredColorScheme(.light)
}
