import Foundation
import Testing
@testable import Luna

@Suite struct AppRouterTests {
    @Test func startsOnTodayWithTabBarShown() {
        let router = AppRouter()
        #expect(router.selectedTab == .today)
        #expect(!router.isTabBarHidden)
    }

    @Test func openQuickAddKeepsTab() {
        let router = AppRouter()
        router.selectedTab = .habits
        router.openQuickAdd()
        #expect(router.isQuickAddPresented)
        #expect(router.selectedTab == .habits)
        #expect(router.isTabBarHidden)
        router.isQuickAddPresented = false
        #expect(!router.isTabBarHidden)
    }

    @Test func pushAndPopUseSelectedTabPath() {
        let router = AppRouter()
        router.push(.calendar)
        #expect(router.paths[.today] == [.calendar])
        #expect(router.isTabBarHidden)

        router.selectedTab = .inbox
        #expect(!router.isTabBarHidden)

        router.selectedTab = .today
        router.pop()
        #expect(router.paths[.today] == [])
        #expect(!router.isTabBarHidden)
    }

    @Test func editBlockHidesTabBarUntilCleared() {
        let router = AppRouter()
        router.editingBlockID = UUID()
        #expect(router.isTabBarHidden)
        router.editingBlockID = nil
        #expect(!router.isTabBarHidden)
    }

    @Test func focusHidesTabBarUntilCleared() {
        let router = AppRouter()
        router.focusBlockID = UUID()
        #expect(router.isTabBarHidden)
        router.focusBlockID = nil
        #expect(!router.isTabBarHidden)
    }

    @Test func tabsAreFourWithoutSettings() {
        #expect(AppTab.allCases == [.today, .inbox, .projects, .habits])
    }

    @Test func pushSettingsFromTodayHidesTabBar() {
        let router = AppRouter()
        router.push(.settings)
        router.push(.theme)
        #expect(router.paths[.today] == [.settings, .theme])
        #expect(router.isTabBarHidden)
        router.pop()
        router.pop()
        #expect(!router.isTabBarHidden)
    }

    @Test func pushSmartListAndProjectHideTabBar() {
        let router = AppRouter()
        router.selectedTab = .projects
        router.push(.smartList(.logbook))
        #expect(router.paths[.projects] == [.smartList(.logbook)])
        #expect(router.isTabBarHidden)
        router.pop()
        let id = UUID()
        router.selectedTab = .inbox
        router.push(.project(id))
        #expect(router.paths[.inbox] == [.project(id)])
        #expect(router.isTabBarHidden)
    }
}
