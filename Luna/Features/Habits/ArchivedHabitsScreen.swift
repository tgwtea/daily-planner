import SwiftUI

/// The pushed list of archived habits. A swipe restores or deletes a habit. See docs/screens/archived-habits.md.
struct ArchivedHabitsScreen: View {
    @Environment(PlannerStore.self) private var store
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var deletingHabit: Habit?

    var body: some View {
        List {
            if store.archivedHabits.isEmpty {
                ListEmptyView(systemImage: "archivebox", message: "Habits you archive show here.")
                    .listRowInsets(EdgeInsets())
                    .listRowBackground(Color.clear)
            } else {
                Section {
                    ForEach(store.archivedHabits) { habit in
                        row(habit)
                    }
                } footer: {
                    Text("Swipe right to restore a habit. Swipe left to delete it and its history.")
                        .lunaTextStyle(.meta)
                        .foregroundStyle(Color.textTertiary)
                }
                .listRowBackground(Color.surfacePrimary)
                .listRowSeparatorTint(Color.dividerDefault)
            }
        }
        .listStyle(.insetGrouped)
        .contentMargins(.horizontal, LunaSpacing.screenMargin, for: .scrollContent)
        .scrollContentBackground(.hidden)
        .background(Color.bgCanvas)
        .navigationTitle("Archived")
        .navigationBarTitleDisplayMode(.large)
        .confirmationDialog(
            "Delete \(deletingHabit?.name ?? "habit")?",
            isPresented: isDeleting,
            titleVisibility: .visible,
            presenting: deletingHabit
        ) { habit in
            Button("Delete Habit", role: .destructive) {
                withRowAnimation { store.deleteArchivedHabit(id: habit.id) }
            }
        } message: { _ in
            Text("This deletes the habit and its history. You cannot undo this.")
        }
    }

    private func row(_ habit: Habit) -> some View {
        HStack(spacing: 12) {
            IconTile(systemImage: habit.icon, color: habit.color, size: 36, cornerRadius: 12)
            VStack(alignment: .leading, spacing: 2) {
                Text(habit.name)
                    .lunaTextStyle(.rowTitle)
                    .foregroundStyle(Color.textPrimary)
                Text(Weekday.summary(of: habit.weekdays))
                    .lunaTextStyle(.meta)
                    .foregroundStyle(Color.textSecondary)
            }
            .lineLimit(1)
            Spacer(minLength: 0)
        }
        .padding(.vertical, 6)
        .accessibilityElement(children: .combine)
        .swipeActions(edge: .leading) {
            Button("Restore", systemImage: "arrow.uturn.backward") {
                withRowAnimation { store.restoreHabit(id: habit.id) }
            }
            .tint(BlockColor.sage.color)
        }
        .swipeActions(edge: .trailing) {
            Button("Delete", systemImage: "trash", role: .destructive) { deletingHabit = habit }
        }
        .accessibilityAction(named: "Restore") { withRowAnimation { store.restoreHabit(id: habit.id) } }
        .accessibilityAction(named: "Delete") { deletingHabit = habit }
    }

    private var isDeleting: Binding<Bool> {
        Binding(get: { deletingHabit != nil }, set: { if !$0 { deletingHabit = nil } })
    }

    private func withRowAnimation(_ body: () -> Void) {
        withAnimation(LunaMotion.animation(.easeInOut(duration: LunaMotion.normal), reduceMotion: reduceMotion), body)
    }
}

#Preview("Dark") {
    ArchivedHabitsPreview().preferredColorScheme(.dark)
}

#Preview("Light") {
    ArchivedHabitsPreview().preferredColorScheme(.light)
}

#Preview("Empty") {
    NavigationStack { ArchivedHabitsScreen() }
        .environment(PlannerStore())
        .preferredColorScheme(.dark)
}

private struct ArchivedHabitsPreview: View {
    @State private var store: PlannerStore = {
        let store = PlannerStore.sample()
        for id in store.habits.prefix(2).map(\.id) {
            store.archiveHabit(id: id)
        }
        return store
    }()

    var body: some View {
        NavigationStack { ArchivedHabitsScreen() }
            .environment(store)
    }
}
