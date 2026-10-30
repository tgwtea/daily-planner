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
            rootView
                .environment(store)
                .environment(router)
                .environment(\.appClock, clock)
                .preferredColorScheme(theme.colorScheme)
        }
    }

    @ViewBuilder private var rootView: some View {
        #if DEBUG
        if ProcessInfo.processInfo.arguments.contains(ComponentsGallery.launchArgument) {
            ComponentsGallery()
        } else {
            RootView()
        }
        #else
        RootView()
        #endif
    }
}
