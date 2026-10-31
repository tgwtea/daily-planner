import SwiftUI

/// The Projects tab with no projects. The mockup has none.
struct ProjectsEmptyView: View {
    var onNewProject: () -> Void

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "folder")
                .font(.title2)
                .foregroundStyle(Color.iconSecondary)
                .accessibilityHidden(true)
            Text("No projects yet")
                .lunaTextStyle(.rowTitle)
                .foregroundStyle(Color.textPrimary)
            Text("Projects you add show here, grouped by area.")
                .lunaTextStyle(.meta)
                .foregroundStyle(Color.textSecondary)
            ChipButton(title: "New Project", systemImage: "plus", action: onNewProject)
                .fixedSize()
                .padding(.top, 8)
        }
        .multilineTextAlignment(.center)
        .padding(.vertical, 40)
        .frame(maxWidth: .infinity)
        .background(Color.surfacePrimary, in: RoundedRectangle(cornerRadius: LunaRadius.card))
        .accessibilityElement(children: .contain)
    }
}

#Preview("Dark") {
    ProjectsEmptyView {}
        .padding(LunaSpacing.screenMargin)
        .frame(maxHeight: .infinity)
        .background(Color.bgCanvas)
        .preferredColorScheme(.dark)
}

#Preview("Light") {
    ProjectsEmptyView {}
        .padding(LunaSpacing.screenMargin)
        .frame(maxHeight: .infinity)
        .background(Color.bgCanvas)
        .preferredColorScheme(.light)
}
