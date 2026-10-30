import SwiftUI

@main
struct LunaApp: App {
    @State private var store: PlannerStore
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
            ContentView()
                .environment(store)
                .environment(\.appClock, clock)
        }
    }
}
