import SwiftUI

/// The Habits tab: a history card and one card per habit. See docs/screens/habits.md.
struct HabitsScreen: View {
    @Environment(PlannerStore.self) private var store
    @Environment(\.appClock) private var clock
    @Environment(\.calendar) private var calendar

    /// The habit that the history card shows. `nil` shows all habits.
    @State private var selectedHabitID: Habit.ID?

    var body: some View {
        TimelineView(.everyMinute) { _ in
            let today = clock.now()
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    LargeTitleHeader(title: "Habits", subtitle: subtitle(today: today), subtitlePosition: .below)
                        // The header keeps its own margin, as on Today.
                        .padding(.horizontal, -LunaSpacing.screenMargin)
                    if store.habits.isEmpty {
                        HabitsEmptyView()
                    } else {
                        historyCard(today: today)
                        VStack(spacing: 10) {
                            ForEach(store.habits) { habit in
                                HabitCard(
                                    habit: habit, today: today, calendar: calendar,
                                    isSelected: habit.id == selectedHabitID,
                                    onLog: { store.logHabit(id: habit.id, on: today, calendar: calendar) },
                                    onSelect: { select(habit.id) }
                                )
                            }
                        }
                    }
                }
                .padding(.horizontal, LunaSpacing.screenMargin)
                .padding(.top, 14)
                .padding(.bottom, LunaTabBar.height + LunaSpacing.sectionGap)
            }
            .scrollIndicators(.hidden)
        }
        .background(Color.bgCanvas)
        .toolbar(.hidden, for: .navigationBar)
    }

    private func historyCard(today: Date) -> some View {
        let selected = store.habits.first { $0.id == selectedHabitID }
        return HabitHistoryCard(
            title: selected?.name ?? "All habits",
            habits: selected.map { [$0] } ?? store.habits,
            color: selected?.color ?? .slate,
            today: today,
            calendar: calendar
        )
    }

    private func subtitle(today: Date) -> String {
        let done = HabitStats.doneCount(store.habits, on: today, calendar: calendar)
        return "\(today.formatted(.dateTime.weekday(.wide))) · \(done) of \(store.habits.count) done today"
    }

    /// A second tap on the selected habit shows all habits again.
    private func select(_ id: Habit.ID) {
        selectedHabitID = selectedHabitID == id ? nil : id
    }
}

#Preview("Dark") {
    NavigationStack { HabitsScreen() }
        .sampleEnvironment()
        .preferredColorScheme(.dark)
}

#Preview("Light") {
    NavigationStack { HabitsScreen() }
        .sampleEnvironment()
        .preferredColorScheme(.light)
}

#Preview("Empty") {
    NavigationStack { HabitsScreen() }
        .environment(PlannerStore())
        .preferredColorScheme(.dark)
}
