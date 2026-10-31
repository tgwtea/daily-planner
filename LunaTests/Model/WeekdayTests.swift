import Foundation
import Testing
@testable import Luna

@Suite struct WeekdayTests {
    private let calendar = TestCalendar.utc

    @Test func casesRunMondayToSunday() {
        #expect(Weekday.allCases.first == .monday)
        #expect(Weekday.allCases.last == .sunday)
        #expect(Weekday.allCases.map(\.initial) == ["M", "T", "W", "T", "F", "S", "S"])
    }

    @Test func mapsCalendarDates() {
        #expect(Weekday(of: TestCalendar.date(2026, 10, 26), calendar: calendar) == .monday)
        #expect(Weekday(of: TestCalendar.date(2026, 10, 29, 23, 59), calendar: calendar) == .thursday)
        #expect(Weekday(of: TestCalendar.date(2026, 11, 1), calendar: calendar) == .sunday)
    }

    @Test func summaryNamesCommonSets() {
        #expect(Weekday.summary(of: Set(Weekday.allCases)) == "Every day")
        #expect(Weekday.summary(of: [.monday, .tuesday, .wednesday, .thursday, .friday]) == "Weekdays")
        #expect(Weekday.summary(of: [.sunday, .saturday]) == "Weekends")
        #expect(Weekday.summary(of: [.friday, .monday, .wednesday]) == "Mon, Wed, Fri")
        #expect(Weekday.summary(of: []) == "No days")
    }

    @Test func habitIsScheduledOnItsWeekdays() {
        let habit = Habit(name: "Run", icon: "figure.run", color: .rose, goal: 1, subtitle: "", weekdays: [.thursday])
        #expect(habit.isScheduled(on: TestCalendar.date(2026, 10, 29), calendar: calendar))
        #expect(!habit.isScheduled(on: TestCalendar.date(2026, 10, 30), calendar: calendar))
    }
}
