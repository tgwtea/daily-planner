import SwiftUI

/// The Habits tab: a history card and one card per habit. See docs/screens/habits.md.
/// A swipe or a long press edits or archives a habit. A drag reorders the habits.
struct HabitsScreen: View {
    /// The habit that the editor sheet shows.
    private enum EditorTarget: Identifiable {
        case new
        case edit(Habit.ID)

        var id: String {
            switch self {
            case .new: "new"
            case .edit(let id): id.uuidString
            }
        }
    }

    @Environment(PlannerStore.self) private var store
    @Environment(AppRouter.self) private var router
    @Environment(\.appClock) private var clock
    @Environment(\.calendar) private var calendar
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    /// The habit that the history card shows. `nil` shows all habits.
    @State private var selectedHabitID: Habit.ID?
    @State private var editorTarget: EditorTarget?

    var body: some View {
        TimelineView(.everyMinute) { _ in
            let today = clock.now()
            List {
                LargeTitleHeader(title: "Habits", subtitle: subtitle(today: today), subtitlePosition: .below) {
                    addButton
                }
                .padding(.top, 14)
                .padding(.bottom, 6)
                .cardRow(insets: EdgeInsets())
                if store.habits.isEmpty {
                    HabitsEmptyView { editorTarget = .new }
                        .cardRow()
                } else {
                    historyCard(today: today)
                        .padding(.bottom, 10)
                        .cardRow()
                    ForEach(store.habits) { habit in
                        habitCard(habit, today: today)
                    }
                    .onMove { store.moveHabits(fromOffsets: $0, toOffset: $1) }
                }
                if !store.archivedHabits.isEmpty {
                    archivedRow
                        .padding(.top, 10)
                        .cardRow()
                }
            }
            .listStyle(.plain)
            .environment(\.defaultMinListRowHeight, 0)
            .contentMargins(.bottom, LunaTabBar.height + LunaSpacing.sectionGap, for: .scrollContent)
            .scrollContentBackground(.hidden)
            .scrollIndicators(.hidden)
        }
        .background(Color.bgCanvas)
        .toolbar(.hidden, for: .navigationBar)
        .sheet(item: $editorTarget) { target in
            switch target {
            case .new: HabitEditorSheet(habitID: nil)
            case .edit(let id): HabitEditorSheet(habitID: id)
            }
        }
    }

    private func habitCard(_ habit: Habit, today: Date) -> some View {
        HabitCard(
            habit: habit, today: today, calendar: calendar,
            isSelected: habit.id == selectedHabitID,
            onLog: { store.logHabit(id: habit.id, on: today, calendar: calendar) },
            onSelect: { select(habit.id) }
        )
        .contextMenu {
            Button("Edit", systemImage: "pencil") { editorTarget = .edit(habit.id) }
            Button("Archive", systemImage: "archivebox") { archive(habit.id) }
        }
        .swipeActions(edge: .leading) {
            Button("Edit", systemImage: "pencil") { editorTarget = .edit(habit.id) }
                .tint(Color.surfaceTertiary)
        }
        .swipeActions(edge: .trailing) {
            Button("Archive", systemImage: "archivebox") { archive(habit.id) }
                .tint(BlockColor.plum.color)
        }
        .accessibilityAction(named: "Edit") { editorTarget = .edit(habit.id) }
        .accessibilityAction(named: "Archive") { archive(habit.id) }
        .padding(.vertical, 5)
        .cardRow()
    }

    private var addButton: some View {
        Button { editorTarget = .new } label: {
            Image(systemName: "plus")
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(Color.textPrimary)
                .frame(width: LunaSpacing.minHitTarget, height: LunaSpacing.minHitTarget)
                .lunaGlass(in: Circle())
                .contentShape(Circle())
        }
        .buttonStyle(PressScaleButtonStyle(scale: LunaMotion.PressScale.standard))
        .accessibilityLabel("New habit")
    }

    private var archivedRow: some View {
        GroupedList {
            // A `NavigationLink` in a `List` adds a second chevron.
            Button { router.push(.archivedHabits) } label: {
                GroupedRow(
                    title: "Archived",
                    systemImage: "archivebox",
                    value: String(store.archivedHabits.count),
                    showsChevron: true
                )
            }
            .buttonStyle(.plain)
        }
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

    /// Counts only the habits that are scheduled today.
    private func subtitle(today: Date) -> String {
        let scheduled = HabitStats.scheduled(store.habits, on: today, calendar: calendar)
        let done = HabitStats.doneCount(scheduled, on: today, calendar: calendar)
        return "\(today.formatted(.dateTime.weekday(.wide))) · \(done) of \(scheduled.count) done today"
    }

    /// A second tap on the selected habit shows all habits again.
    private func select(_ id: Habit.ID) {
        selectedHabitID = selectedHabitID == id ? nil : id
    }

    private func archive(_ id: Habit.ID) {
        if selectedHabitID == id { selectedHabitID = nil }
        withAnimation(LunaMotion.animation(.easeInOut(duration: LunaMotion.normal), reduceMotion: reduceMotion)) {
            store.archiveHabit(id: id)
        }
    }
}

private extension View {
    /// A `List` row that shows only its own content: no row background, no separator, the screen margin.
    func cardRow(insets: EdgeInsets = EdgeInsets(top: 0, leading: LunaSpacing.screenMargin, bottom: 0, trailing: LunaSpacing.screenMargin)) -> some View {
        listRowInsets(insets)
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
    }
}

#Preview("Dark") {
    NavigationStack { HabitsScreen() }
        .environment(AppRouter())
        .sampleEnvironment()
        .preferredColorScheme(.dark)
}

#Preview("Light") {
    NavigationStack { HabitsScreen() }
        .environment(AppRouter())
        .sampleEnvironment()
        .preferredColorScheme(.light)
}

#Preview("Empty") {
    NavigationStack { HabitsScreen() }
        .environment(AppRouter())
        .environment(PlannerStore())
        .preferredColorScheme(.dark)
}
