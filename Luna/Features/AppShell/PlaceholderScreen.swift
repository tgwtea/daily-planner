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

#Preview("Dark") {
    NavigationStack {
        PlaceholderScreen(title: "Settings") { EmptyView() }
    }
    .environment(AppRouter())
    .sampleEnvironment()
    .preferredColorScheme(.dark)
}

#Preview("Light") {
    NavigationStack {
        PlaceholderScreen(title: "Settings") { EmptyView() }
    }
    .environment(AppRouter())
    .sampleEnvironment()
    .preferredColorScheme(.light)
}
