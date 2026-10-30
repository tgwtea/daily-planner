import Foundation
import Observation

/// The navigation state of the app: the selected tab, the path of each tab, and the open sheet or cover.
@Observable
final class AppRouter {
    var selectedTab: AppTab = .today
    var paths: [AppTab: [AppRoute]] = [:]
    var isQuickAddPresented = false
    var editingBlockID: Block.ID?
    var focusBlockID: Block.ID?

    /// The tab bar and the "+" button hide on pushed screens and while Quick add, Edit block, or Focus is open.
    /// See docs/screens/README.md#navigation-map.
    var isTabBarHidden: Bool {
        isQuickAddPresented
            || editingBlockID != nil
            || focusBlockID != nil
            || !(paths[selectedTab] ?? []).isEmpty
    }

    /// The "+" button next to the tab bar. The selected tab does not change.
    func openQuickAdd() {
        isQuickAddPresented = true
    }

    /// Pushes a route onto the path of the selected tab.
    func push(_ route: AppRoute) {
        paths[selectedTab, default: []].append(route)
    }

    func pop() {
        _ = paths[selectedTab]?.popLast()
    }
}
