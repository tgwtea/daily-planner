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

    @Test func openQuickAddStoresPrefill() {
        let router = AppRouter()
        let day = TestCalendar.date(2026, 10, 30)
        router.openQuickAdd(.anytime(day: day))
        #expect(router.quickAddPrefill == .anytime(day: day))
        router.openQuickAdd()
        #expect(router.quickAddPrefill == QuickAddPrefill.none)
    }

    @Test func showTodaySelectsTabAndDay() {
        let router = AppRouter()
        router.selectedTab = .inbox
        let now = TestCalendar.date(2026, 10, 29, 10, 20)
        router.showToday(on: TestCalendar.date(2026, 10, 30, 9), now: now, calendar: TestCalendar.utc)
        #expect(router.selectedTab == .today)
        #expect(router.todayDay == TestCalendar.date(2026, 10, 30))
        router.showToday(on: TestCalendar.date(2026, 10, 29, 15), now: now, calendar: TestCalendar.utc)
        #expect(router.todayDay == nil)
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
