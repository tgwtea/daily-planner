import SwiftUI

/// One project: a progress ring in the project color, the name, the date line, and the open count.
/// See docs/screens/projects.md. Rows do not navigate until checkpoint 1b.6.
struct ProjectRow: View {
    let project: Project
    let progress: ProjectProgress
    let calendar: Calendar

    var body: some View {
        let meta = project.timing.text(calendar: calendar)
        HStack(spacing: 14) {
            ProgressRing(progress: progress.fraction, color: project.color.color, diameter: 24, lineWidth: 3)
                .frame(width: 28)
            VStack(alignment: .leading, spacing: 3) {
                Text(project.name)
                    .lunaTextStyle(.rowTitle)
                    .foregroundStyle(Color.textPrimary)
                Text(meta)
                    .lunaTextStyle(.meta)
                    .monospacedDigit()
                    .foregroundStyle(Color.textSecondary)
            }
            Spacer(minLength: 8)
            Text(progress.open, format: .number)
                .lunaTextStyle(.label)
                .fontWeight(.regular)
                .monospacedDigit()
                .foregroundStyle(Color.textTertiary)
        }
        .padding(.vertical, 14)
        .padding(.horizontal, LunaSpacing.rowHorizontalPadding)
        .frame(minHeight: LunaSpacing.minHitTarget)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(project.name)
        .accessibilityValue("\(meta), \(progress.percent) percent done, \(progress.open) open")
    }
}

#if DEBUG
private struct ProjectRowPreview: View {
    @Environment(PlannerStore.self) private var store

    var body: some View {
        GroupedList {
            ForEach(store.projects) { project in
                ProjectRow(project: project, progress: ProjectProgress(projectID: project.id, in: store), calendar: .current)
            }
        }
        .padding(LunaSpacing.screenMargin)
        .frame(maxHeight: .infinity)
        .background(Color.bgCanvas)
    }
}

#Preview("Dark") {
    ProjectRowPreview().sampleEnvironment().preferredColorScheme(.dark)
}

#Preview("Light") {
    ProjectRowPreview().sampleEnvironment().preferredColorScheme(.light)
}
#endif
