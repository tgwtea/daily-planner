import Foundation
import Testing
@testable import Luna

@Suite struct WeekTests {
    private let calendar = TestCalendar.utc

    @Test func weekStartsOnMonday() {
        let days = Week.days(containing: TestCalendar.date(2026, 10, 29, 10, 20), calendar: calendar)
        #expect(days.count == 7)
        #expect(days.first == TestCalendar.date(2026, 10, 26))
        #expect(days.last == TestCalendar.date(2026, 11, 1))
    }

    @Test func sundayBelongsToThePreviousMonday() {
        let days = Week.days(containing: TestCalendar.date(2026, 11, 1), calendar: calendar)
        #expect(days.first == TestCalendar.date(2026, 10, 26))
    }

    @Test func mondayStartsItsOwnWeek() {
        let days = Week.days(containing: TestCalendar.date(2026, 11, 2, 8), calendar: calendar)
        #expect(days.first == TestCalendar.date(2026, 11, 2))
    }

    @Test func shiftMovesWholeWeeks() {
        let thursday = TestCalendar.date(2026, 10, 29, 10, 20)
        #expect(Week.shift(thursday, weeks: 1, calendar: calendar) == TestCalendar.date(2026, 11, 5))
        #expect(Week.shift(thursday, weeks: -1, calendar: calendar) == TestCalendar.date(2026, 10, 22))
    }
}
