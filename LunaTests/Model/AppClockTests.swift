import Foundation
import Testing
@testable import Luna

@Suite struct AppClockTests {
    private let start = TestCalendar.date(2026, 10, 29, 10, 20)

    @Test func fixedClockNeverMoves() async throws {
        let clock = AppClock.fixed(start)
        try await Task.sleep(for: .milliseconds(20))
        #expect(clock.now() == start)
    }

    @Test func runningClockStartsAtDateAndAdvances() async throws {
        let clock = AppClock.running(from: start)
        let first = clock.now()
        #expect(first >= start)
        #expect(first < start.addingTimeInterval(1))
        try await Task.sleep(for: .milliseconds(20))
        #expect(clock.now() > first)
    }
}
