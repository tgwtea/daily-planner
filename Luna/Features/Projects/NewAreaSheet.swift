import SwiftUI

/// A small sheet to add an area: name and icon. See docs/features/projects-and-areas.md#decisions.
struct NewAreaSheet: View {
    /// The SF Symbols that a user can give an area.
    static let icons: [IconChoiceGrid.Icon] = [
        ("briefcase", "Briefcase"), ("house", "House"), ("heart", "Heart"), ("book", "Book"),
        ("graduationcap", "School"), ("figure.run", "Sport"), ("paintpalette", "Art"), ("airplane", "Travel"),
    ]

    @Environment(PlannerStore.self) private var store
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var icon = icons[0].symbol
    @FocusState private var isNameFocused: Bool

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Name", text: $name)
                        .focused($isNameFocused)
                        .submitLabel(.done)
                        .onSubmit(save)
                }
                .listRowBackground(Color.surfacePrimary)
                Section("Icon") {
                    IconChoiceGrid(icons: Self.icons, selection: $icon)
                }
                .listRowBackground(Color.surfacePrimary)
            }
            .scrollContentBackground(.hidden)
            .background(Color.bgCanvas)
            .navigationTitle("New Area")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", role: .cancel) { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save", action: save)
                        .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
            .onAppear { isNameFocused = true }
        }
        .presentationDetents([.medium, .large])
    }

    private func save() {
        guard store.addArea(name: name, icon: icon) != nil else { return }
        dismiss()
    }
}

#Preview("Dark") {
    Color.bgCanvas.sheet(isPresented: .constant(true)) { NewAreaSheet() }
        .sampleEnvironment()
        .preferredColorScheme(.dark)
}

#Preview("Light") {
    Color.bgCanvas.sheet(isPresented: .constant(true)) { NewAreaSheet() }
        .sampleEnvironment()
        .preferredColorScheme(.light)
}
