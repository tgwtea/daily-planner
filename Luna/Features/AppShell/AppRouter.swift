import Foundation
import Observation

/// The navigation state of the app: the selected tab, the path of each tab, and the open sheet or cover.
@Observable
final class AppRouter {
    var selectedTab: AppTab = .today
    var paths: [AppTab: [AppRoute]] = [:]
    var isQuickAddPresented = false
    /// What the open Quick add sheet starts with.
    var quickAddPrefill: QuickAddPrefill = .none
    /// The day that Today shows. `nil` follows the current day of the clock.
    var todayDay: Date?
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

    /// Opens Quick add. The selected tab does not change.
    func openQuickAdd(_ prefill: QuickAddPrefill = .none) {
        quickAddPrefill = prefill
        isQuickAddPresented = true
    }

    /// Selects Today and shows `day` there. The current day sets `todayDay` to `nil`.
    func showToday(on day: Date, now: Date, calendar: Calendar) {
        selectedTab = .today
        todayDay = calendar.isDate(day, inSameDayAs: now) ? nil : calendar.startOfDay(for: day)
    }

    /// Pushes a route onto the path of the selected tab.
    func push(_ route: AppRoute) {
        paths[selectedTab, default: []].append(route)
    }

    func pop() {
        _ = paths[selectedTab]?.popLast()
    }
}
