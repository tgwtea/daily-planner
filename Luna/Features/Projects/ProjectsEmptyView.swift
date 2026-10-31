import SwiftUI

/// The Projects tab with no projects. The mockup has none. Checkpoint 1b.6 adds the add action.
struct ProjectsEmptyView: View {
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
        }
        .multilineTextAlignment(.center)
        .padding(.vertical, 40)
        .frame(maxWidth: .infinity)
        .background(Color.surfacePrimary, in: RoundedRectangle(cornerRadius: LunaRadius.card))
        .accessibilityElement(children: .combine)
    }
}

#Preview("Dark") {
    ProjectsEmptyView()
        .padding(LunaSpacing.screenMargin)
        .frame(maxHeight: .infinity)
        .background(Color.bgCanvas)
        .preferredColorScheme(.dark)
}

#Preview("Light") {
    ProjectsEmptyView()
        .padding(LunaSpacing.screenMargin)
        .frame(maxHeight: .infinity)
        .background(Color.bgCanvas)
        .preferredColorScheme(.light)
}
