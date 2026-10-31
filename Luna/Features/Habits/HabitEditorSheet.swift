import SwiftUI

/// The sheet to add or edit a habit: name, detail, icon, color, goal, and days. See docs/screens/habit-editor.md.
/// Save writes the draft to the store. Cancel discards it.
struct HabitEditorSheet: View {
    /// The SF Symbols that a user can give a habit. The first five are the sample habits.
    static let icons: [IconChoiceGrid.Icon] = [
        ("waterbottle", "Water"), ("figure.stand", "Stretch"), ("book", "Read"), ("wind", "Breathe"),
        ("figure.walk", "Walk"), ("figure.run", "Run"), ("dumbbell", "Workout"), ("bed.double", "Sleep"),
        ("leaf", "Plants"), ("pills", "Medicine"), ("pencil", "Write"), ("music.note", "Music"),
    ]

    /// `nil` adds a new habit.
    let habitID: Habit.ID?

    @Environment(PlannerStore.self) private var store
    @Environment(\.dismiss) private var dismiss
    @State private var draft = HabitDraft()
    @State private var didLoad = false
    @FocusState private var isNameFocused: Bool

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Name", text: $draft.name)
                        .focused($isNameFocused)
                        .submitLabel(.done)
                    TextField("Detail, for example 20 minutes", text: $draft.detail)
                        .submitLabel(.done)
                }
                .listRowBackground(Color.surfacePrimary)
                Section("Icon") {
                    IconChoiceGrid(icons: Self.icons, selection: $draft.icon)
                }
                .listRowBackground(Color.surfacePrimary)
                Section("Color") {
                    ColorChoiceRow(selection: $draft.color)
                }
                .listRowBackground(Color.surfacePrimary)
                Section("Goal") {
                    Stepper(value: $draft.goal, in: HabitDraft.goalRange) {
                        Text("\(draft.goal) a day")
                            .monospacedDigit()
                    }
                }
                .listRowBackground(Color.surfacePrimary)
                Section {
                    WeekdayPicker(selection: $draft.weekdays)
                } header: {
                    Text("Days")
                } footer: {
                    Text(draft.weekdays.isEmpty
                        ? "Pick at least one day."
                        : "\(Weekday.summary(of: draft.weekdays)). Other days do not break the streak.")
                }
                .listRowBackground(Color.surfacePrimary)
            }
            .scrollContentBackground(.hidden)
            .background(Color.bgCanvas)
            .navigationTitle(habitID == nil ? "New Habit" : "Edit Habit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", role: .cancel) { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save", action: save)
                        .disabled(!draft.isValid)
                }
            }
            .onAppear(perform: load)
        }
        .presentationDetents([.large])
    }

    private func load() {
        guard !didLoad else { return }
        didLoad = true
        if let habitID, let habit = store.habits.first(where: { $0.id == habitID }) {
            draft = HabitDraft(habit: habit)
        } else {
            draft.icon = Self.icons[0].symbol
            isNameFocused = true
        }
    }

    private func save() {
        if let habitID {
            store.updateHabit(id: habitID, draft: draft)
        } else {
            guard store.addHabit(draft) != nil else { return }
        }
        dismiss()
    }
}

#Preview("New, dark") {
    Color.bgCanvas.sheet(isPresented: .constant(true)) { HabitEditorSheet(habitID: nil) }
        .sampleEnvironment()
        .preferredColorScheme(.dark)
}

#Preview("Edit, light") {
    HabitEditorEditPreview().preferredColorScheme(.light)
}

private struct HabitEditorEditPreview: View {
    @State private var store = PlannerStore.sample()

    var body: some View {
        Color.bgCanvas.sheet(isPresented: .constant(true)) { HabitEditorSheet(habitID: store.habits.first?.id) }
            .environment(store)
    }
}
