import SwiftUI

/// An empty titled screen for a tab or a route that a later checkpoint builds.
struct PlaceholderScreen<Actions: View>: View {
    let title: String
    @ViewBuilder var actions: Actions

    var body: some View {
        VStack(spacing: LunaSpacing.sectionHeaderGap) {
            actions
        }
        .buttonStyle(.bordered)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.bgCanvas)
        .navigationTitle(title)
    }
}

/// A temporary button that pushes the first project. Checkpoint 1b.4 removes it.
struct ProjectsShellActions: View {
    @Environment(AppRouter.self) private var router
    @Environment(PlannerStore.self) private var store

    var body: some View {
        let firstProject = store.projects.first?.id
        Button("Open project") {
            if let firstProject { router.push(.project(firstProject)) }
        }
        .disabled(firstProject == nil)
    }
}

#Preview("Dark") {
    NavigationStack {
        PlaceholderScreen(title: "Projects") { ProjectsShellActions() }
    }
    .environment(AppRouter())
    .sampleEnvironment()
    .preferredColorScheme(.dark)
}

#Preview("Light") {
    NavigationStack {
        PlaceholderScreen(title: "Projects") { ProjectsShellActions() }
    }
    .environment(AppRouter())
    .sampleEnvironment()
    .preferredColorScheme(.light)
}
