import SwiftUI

/// The app shell: five tabs, the custom tab bar with the "+" button, and the root sheets and cover.
/// The system tab bar stays hidden. A 5-tab system bar fills the width, so the "+" circle cannot sit next to it.
/// See docs/screens/README.md#navigation-map.
struct RootView: View {
    @Environment(AppRouter.self) private var router
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        @Bindable var router = router
        TabView(selection: $router.selectedTab) {
            ForEach(AppTab.allCases, id: \.self) { tab in
                Tab(tab.title, systemImage: tab.systemImage, value: tab) {
                    NavigationStack(path: path(for: tab)) {
                        tabRoot(tab)
                            .navigationDestination(for: AppRoute.self) { route in
                                RouteScreen(route: route)
                            }
                    }
                    .toolbar(.hidden, for: .tabBar)
                }
            }
        }
        .overlay(alignment: .bottom) {
            if !router.isTabBarHidden {
                LunaTabBar()
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    // The tab bar stays at the bottom while the Inbox title alert shows the keyboard.
                    .ignoresSafeArea(.keyboard)
            }
        }
        .animation(
            LunaMotion.animation(.easeInOut(duration: LunaMotion.normal), reduceMotion: reduceMotion),
            value: router.isTabBarHidden
        )
        .sheet(isPresented: $router.isQuickAddPresented) {
            QuickAddSheet()
        }
        .sheet(isPresented: Binding(
            get: { router.editingBlockID != nil },
            set: { if !$0 { router.editingBlockID = nil } }
        )) {
            if let id = router.editingBlockID {
                EditBlockSheet(blockID: id)
                    .presentationDetents([.large])
            }
        }
        .fullScreenCover(isPresented: Binding(
            get: { router.focusBlockID != nil },
            set: { if !$0 { router.focusBlockID = nil } }
        )) {
            if let id = router.focusBlockID {
                FocusScreen(blockID: id)
            }
        }
    }

    private func path(for tab: AppTab) -> Binding<[AppRoute]> {
        Binding(get: { router.paths[tab] ?? [] }, set: { router.paths[tab] = $0 })
    }

    @ViewBuilder
    private func tabRoot(_ tab: AppTab) -> some View {
        switch tab {
        case .today:
            TodayScreen()
        case .inbox:
            InboxScreen()
        case .projects:
            ProjectsScreen()
        case .habits:
            HabitsScreen()
        default:
            PlaceholderScreen(title: tab.title) { EmptyView() }
        }
    }
}

/// The destination of a pushed route.
private struct RouteScreen: View {
    @Environment(PlannerStore.self) private var store
    let route: AppRoute

    var body: some View {
        switch route {
        case .calendar:
            PlaceholderScreen(title: "Calendar") { EmptyView() }
        case .project(let id):
            let name = store.projects.first { $0.id == id }?.name ?? "Project"
            PlaceholderScreen(title: name) { EmptyView() }
        }
    }
}

#Preview("Dark") {
    RootView()
        .environment(AppRouter())
        .sampleEnvironment()
        .preferredColorScheme(.dark)
}

#Preview("Light") {
    RootView()
        .environment(AppRouter())
        .sampleEnvironment()
        .preferredColorScheme(.light)
}
