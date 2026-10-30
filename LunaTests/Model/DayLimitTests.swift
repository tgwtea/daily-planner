import Foundation
import Testing
@testable import Luna

@Suite struct DayLimitTests {
    private let calendar = TestCalendar.utc
    private let elevenPM = TestCalendar.date(2026, 10, 29, 23, 0)

    @Test func durationEndingAt2359Fits() {
        #expect(DayLimit.clampedDuration(59, start: elevenPM, calendar: calendar) == 59)
        #expect(TestCalendar.task(start: elevenPM, minutes: 59).fitsDay(calendar: calendar))
    }

    @Test func durationPast2359IsClamped() {
        #expect(DayLimit.clampedDuration(60, start: elevenPM, calendar: calendar) == 59)
        #expect(!TestCalendar.task(start: elevenPM, minutes: 60).fitsDay(calendar: calendar))
    }

    @Test func startAt2359HasNoRoom() {
        let start = TestCalendar.date(2026, 10, 29, 23, 59)
        #expect(DayLimit.maxDuration(forStart: start, calendar: calendar) == 0)
        #expect(DayLimit.clampedDuration(15, start: start, calendar: calendar) == nil)
    }

    @Test func daylightSavingEndDayHasExtraHour() {
        // New York falls back on November 1, 2026. The day has 25 hours.
        let newYork = TestCalendar.make(timeZone: "America/New_York")
        let start = TestCalendar.date(2026, 11, 1, 0, 30, calendar: newYork)
        #expect(DayLimit.maxDuration(forStart: start, calendar: newYork) == 24 * 60 + 29)
    }
}
