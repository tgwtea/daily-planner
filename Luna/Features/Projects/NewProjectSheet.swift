import SwiftUI

/// A small sheet to add a project: name, color, and area. See docs/features/projects-and-areas.md#decisions.
struct NewProjectSheet: View {
    @Environment(PlannerStore.self) private var store
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @State private var color = BlockColor.slate
    @State private var areaID: Area.ID?
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
                Section("Color") {
                    ColorChoiceRow(selection: $color)
                }
                .listRowBackground(Color.surfacePrimary)
                Section {
                    Picker("Area", selection: $areaID) {
                        Text("None").tag(Area.ID?.none)
                        ForEach(store.areas) { area in
                            Label(area.name, systemImage: area.icon).tag(Area.ID?.some(area.id))
                        }
                    }
                }
                .listRowBackground(Color.surfacePrimary)
            }
            .scrollContentBackground(.hidden)
            .background(Color.bgCanvas)
            .navigationTitle("New Project")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", role: .cancel) { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save", action: save)
                        .disabled(isNameEmpty)
                }
            }
            .onAppear { isNameFocused = true }
        }
        .presentationDetents([.medium, .large])
    }

    private var isNameEmpty: Bool {
        name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    private func save() {
        guard store.addProject(name: name, color: color, areaID: areaID) != nil else { return }
        dismiss()
    }
}

/// The five block colors as round buttons. The selected color has a ring.
struct ColorChoiceRow: View {
    @Binding var selection: BlockColor

    var body: some View {
        HStack(spacing: 0) {
            ForEach(BlockColor.allCases) { color in
                Button {
                    selection = color
                } label: {
                    Circle()
                        .fill(color.color)
                        .frame(width: 28, height: 28)
                        .padding(4)
                        .overlay {
                            if color == selection {
                                Circle().strokeBorder(Color.textPrimary, lineWidth: 2)
                            }
                        }
                        .frame(maxWidth: .infinity, minHeight: LunaSpacing.minHitTarget)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .accessibilityLabel(color.displayName)
                .accessibilityAddTraits(color == selection ? .isSelected : [])
            }
        }
    }
}

#Preview("Dark") {
    Color.bgCanvas.sheet(isPresented: .constant(true)) { NewProjectSheet() }
        .sampleEnvironment()
        .preferredColorScheme(.dark)
}

#Preview("Light") {
    Color.bgCanvas.sheet(isPresented: .constant(true)) { NewProjectSheet() }
        .sampleEnvironment()
        .preferredColorScheme(.light)
}
