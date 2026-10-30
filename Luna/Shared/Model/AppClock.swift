import SwiftUI

/// The source of "now" for the app. Views read the time from `\.appClock`, never from `Date()`,
/// so that previews and the sample-data launch show the mockup day.
struct AppClock: Sendable {
    let now: @Sendable () -> Date

    /// The real time.
    static let system = AppClock { Date() }

    /// A time that never moves. For previews and tests.
    static func fixed(_ date: Date) -> AppClock {
        AppClock { date }
    }

    /// Starts at `start` and moves with real time from the moment of the call.
    static func running(from start: Date) -> AppClock {
        let launch = Date()
        return AppClock { start.addingTimeInterval(Date().timeIntervalSince(launch)) }
    }
}

extension EnvironmentValues {
    @Entry var appClock: AppClock = .system
}
