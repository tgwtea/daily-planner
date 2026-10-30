import SwiftUI

@main
struct LunaApp: App {
    @State private var store: PlannerStore
    @State private var router = AppRouter()
    @AppStorage(SettingsKey.theme) private var theme = AppTheme.defaultValue
    private let clock: AppClock

    init() {
        #if DEBUG
        if ProcessInfo.processInfo.arguments.contains(SampleData.launchArgument) {
            _store = State(initialValue: .sample())
            clock = .running(from: SampleData.now)
            return
        }
        #endif
        _store = State(initialValue: PlannerStore())
        clock = .system
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(store)
                .environment(router)
                .environment(\.appClock, clock)
                .preferredColorScheme(theme.colorScheme)
        }
    }
}
