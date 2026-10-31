import SwiftUI

/// The projects of one area under an icon and name header. See docs/screens/projects.md.
/// Projects with no area use a section with no header.
struct AreaSection: View {
    /// `nil` for the projects with no area.
    let area: Area?
    let projects: [Project]
    let calendar: Calendar

    @Environment(PlannerStore.self) private var store

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let area {
                HStack(spacing: 8) {
                    Image(systemName: area.icon)
                        .font(.system(size: 16, weight: .medium))
                        .accessibilityHidden(true)
                    Text(area.name)
                        .lunaTextStyle(.label)
                }
                .foregroundStyle(Color.textSecondary)
                .padding(.horizontal, 4)
                .accessibilityAddTraits(.isHeader)
            }
            GroupedList {
                ForEach(projects) { project in
                    NavigationLink(value: AppRoute.project(project.id)) {
                        ProjectRow(project: project, progress: ProjectProgress(projectID: project.id, in: store), calendar: calendar)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}

#if DEBUG
private struct AreaSectionPreview: View {
    @Environment(PlannerStore.self) private var store

    var body: some View {
        VStack(spacing: 28) {
            ForEach(store.areas) { area in
                AreaSection(area: area, projects: store.projects(inArea: area.id), calendar: .current)
            }
        }
        .padding(LunaSpacing.screenMargin)
        .frame(maxHeight: .infinity)
        .background(Color.bgCanvas)
    }
}

#Preview("Dark") {
    AreaSectionPreview().sampleEnvironment().preferredColorScheme(.dark)
}

#Preview("Light") {
    AreaSectionPreview().sampleEnvironment().preferredColorScheme(.light)
}
#endif
