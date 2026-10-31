import SwiftUI

/// A pushed project: a progress header, notes, and the Scheduled, Anytime, and Done groups.
/// The toolbar "+" adds an Anytime task to the project. See docs/screens/project-detail.md.
struct ProjectDetailScreen: View {
    let projectID: Project.ID

    @Environment(PlannerStore.self) private var store
    @Environment(\.calendar) private var calendar
    @State private var isAdding = false
    @State private var draftTitle = ""

    var body: some View {
        if let project = store.projects.first(where: { $0.id == projectID }) {
            content(project)
        } else {
            ContentUnavailableView("No project", systemImage: "folder", description: Text("This project does not exist."))
                .background(Color.bgCanvas)
        }
    }

    private func content(_ project: Project) -> some View {
        let progress = ProjectProgress(projectID: projectID, in: store)
        let items = ProjectItems(projectID: projectID, in: store)
        return ScrollView {
            VStack(alignment: .leading, spacing: LunaSpacing.sectionGap) {
                header(project, progress: progress)
                GroupedList {
                    TextField("Notes", text: notesBinding(project), axis: .vertical)
                        .lunaTextStyle(.body)
                        .foregroundStyle(Color.textPrimary)
                        .lineLimit(1...8)
                        .padding(.vertical, LunaSpacing.rowVerticalPadding)
                        .padding(.horizontal, LunaSpacing.rowHorizontalPadding)
                        .frame(minHeight: LunaSpacing.minHitTarget)
                }
                if progress.total == 0 {
                    ListEmptyView(systemImage: "checklist", message: "No tasks yet. Tap + to add one.")
                }
                group("Scheduled", items.scheduled)
                group("Anytime", items.anytime)
                group("Done", items.done)
            }
            .padding(.horizontal, LunaSpacing.screenMargin)
            .padding(.vertical, LunaSpacing.sectionHeaderGap)
        }
        .scrollIndicators(.hidden)
        .scrollDismissesKeyboard(.interactively)
        .background(Color.bgCanvas)
        .navigationTitle(project.name)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Add task", systemImage: "plus") {
                    draftTitle = ""
                    isAdding = true
                }
            }
        }
        .alert("New task", isPresented: $isAdding) {
            TextField("Title", text: $draftTitle)
            Button("Add") { store.addAnytimeTask(title: draftTitle, projectID: projectID) }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("The task goes to Anytime in \(project.name).")
        }
    }

    private func header(_ project: Project, progress: ProjectProgress) -> some View {
        HStack(spacing: 16) {
            ProgressRing(progress: progress.fraction, color: project.color.color, diameter: 60, lineWidth: 5) {
                Text("\(progress.percent)%")
                    .lunaTextStyle(.label)
                    .monospacedDigit()
                    .foregroundStyle(Color.textPrimary)
                    .minimumScaleFactor(0.6)
            }
            VStack(alignment: .leading, spacing: 3) {
                Text(project.timing.text(calendar: calendar))
                    .lunaTextStyle(.rowTitle)
                    .foregroundStyle(Color.textPrimary)
                Text("\(progress.open) open · \(progress.done) done")
                    .lunaTextStyle(.meta)
                    .monospacedDigit()
                    .foregroundStyle(Color.textSecondary)
            }
            Spacer(minLength: 0)
        }
        .padding(LunaSpacing.cardPadding)
        .background(Color.surfacePrimary, in: RoundedRectangle(cornerRadius: LunaRadius.card))
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Progress")
        .accessibilityValue(
            "\(progress.percent) percent done, \(project.timing.text(calendar: calendar)), \(progress.open) open, \(progress.done) done"
        )
    }

    @ViewBuilder
    private func group(_ title: String, _ items: [ListItem]) -> some View {
        if !items.isEmpty {
            GroupedSection(header: title) {
                ForEach(items) { ListItemRow(item: $0, showsProject: false) }
            }
        }
    }

    private func notesBinding(_ project: Project) -> Binding<String> {
        Binding(get: { project.notes }, set: { store.setNotes(projectID: projectID, notes: $0) })
    }
}

#if DEBUG
private struct ProjectDetailPreview: View {
    @Environment(PlannerStore.self) private var store

    var body: some View {
        NavigationStack { ProjectDetailScreen(projectID: store.projects[0].id) }
    }
}

#Preview("Dark") {
    ProjectDetailPreview().sampleEnvironment().preferredColorScheme(.dark)
}

#Preview("Light") {
    ProjectDetailPreview().sampleEnvironment().preferredColorScheme(.light)
}
#endif
