import Foundation
import Testing
@testable import Luna

/// The examples and edge cases of docs/features/quick-add-parsing.md.
@Suite struct QuickAddParserTests {
    /// Thursday, October 29, 2026, 10:20 AM.
    private let now = TestCalendar.date(2026, 10, 29, 10, 20)

    private func calendar(_ locale: String = "en_US") -> Calendar {
        var calendar = TestCalendar.utc
        calendar.locale = Locale(identifier: locale)
        return calendar
    }

    private func parse(_ text: String, locale: String = "en_US") -> QuickAddParser.Result {
        QuickAddParser.parse(text, now: now, calendar: calendar(locale))
    }

    private func day(_ month: Int, _ day: Int, year: Int = 2026) -> Date {
        TestCalendar.date(year, month, day)
    }

    // MARK: Spec examples

    @Test func dentistExample() {
        let result = parse("Call the dentist tomorrow 9am 15m")
        #expect(result.title == "Call the dentist")
        #expect(result.day == day(10, 30))
        #expect(result.minute == 9 * 60)
        #expect(result.durationMinutes == 15)
    }

    @Test func gymExample() {
        let result = parse("gym tmrw 7am 45m")
        #expect(result.title == "gym")
        #expect(result.day == day(10, 30))
        #expect(result.minute == 7 * 60)
        #expect(result.durationMinutes == 45)
    }

    // MARK: Duration

    @Test(arguments: [
        ("Read 20m", 20), ("Read 20 min", 20), ("Read 20mins", 20),
        ("Read 2h", 120), ("Read 1 hr", 60), ("Read 2hrs", 120), ("Read 1H", 60),
    ] as [(String, Int)])
    func durationForms(text: String, minutes: Int) {
        let result = parse(text)
        #expect(result.durationMinutes == minutes)
        #expect(result.title == "Read")
    }

    @Test func fiveKStaysInTitle() {
        let result = parse("Run 5k 30m")
        #expect(result.title == "Run 5k")
        #expect(result.durationMinutes == 30)
    }

    @Test func onlyTheFirstDurationCounts() {
        let result = parse("Deep work 1h 30m")
        #expect(result.durationMinutes == 60)
        #expect(result.title == "Deep work 30m")
    }

    @Test func zeroDurationIsNoDuration() {
        let result = parse("Stretch 0m")
        #expect(result.durationMinutes == nil)
        #expect(result.title == "Stretch")
    }

    // MARK: Time

    @Test(arguments: [
        ("Lunch 12pm", 12 * 60), ("Sleep 12am", 0), ("Call 9:30am", 9 * 60 + 30),
        ("Call 9:30 PM", 21 * 60 + 30), ("Call 11 pm", 23 * 60),
    ] as [(String, Int)])
    func amPMTimes(text: String, minute: Int) {
        #expect(parse(text).minute == minute)
    }

    @Test(arguments: [("Review 14:30", 14 * 60 + 30), ("Review 9:05", 9 * 60 + 5), ("Review 0:00", 0), ("Review 23:59", 23 * 60 + 59)] as [(String, Int)])
    func twentyFourHourTimes(text: String, minute: Int) {
        let result = parse(text)
        #expect(result.minute == minute)
        #expect(result.title == "Review")
    }

    @Test func bareNumberIsNotATime() {
        let result = parse("Dinner at 7")
        #expect(result.minute == nil)
        #expect(result.title == "Dinner at 7")
    }

    @Test(arguments: ["Nap 13pm", "Nap 24:00", "Nap 9:75"])
    func impossibleTimesAreNotTimes(text: String) {
        #expect(parse(text).minute == nil)
    }

    @Test func amPMWinsOverTwentyFourHour() {
        let result = parse("Swap 14:00 then 9am")
        #expect(result.minute == 9 * 60)
        #expect(result.title == "Swap 14:00 then")
    }

    // MARK: Day words

    @Test func todayAndTonightAreToday() {
        #expect(parse("Read today").day == day(10, 29))
        let tonight = parse("Movie tonight")
        #expect(tonight.day == day(10, 29))
        #expect(tonight.minute == nil)
        #expect(tonight.title == "Movie")
    }

    @Test func caseDoesNotMatter() {
        let result = parse("GYM TOMORROW 7AM 45M")
        #expect(result.title == "GYM")
        #expect(result.day == day(10, 30))
        #expect(result.minute == 7 * 60)
        #expect(result.durationMinutes == 45)
    }

    @Test func noTokensKeepTheText() {
        let result = parse("  Buy   milk  ")
        #expect(result.title == "Buy milk")
        #expect(result.day == nil)
        #expect(result.minute == nil)
        #expect(result.durationMinutes == nil)
    }

    // MARK: Weekdays

    @Test(arguments: [("mon", 11, 2), ("Tuesday", 11, 3), ("wed", 11, 4), ("fri", 10, 30), ("saturday", 10, 31), ("Sun", 11, 1)] as [(String, Int, Int)])
    func weekdayIsTheNextSuchDay(name: String, month: Int, dayNumber: Int) {
        #expect(parse("Plan \(name)").day == day(month, dayNumber))
    }

    @Test func sameWeekdayIsNextWeek() {
        // Today is a Thursday. "thu" is 7 days ahead (decided 2026-10-31).
        #expect(parse("Plan thu").day == day(11, 5))
        #expect(parse("Plan thursday").day == day(11, 5))
    }

    @Test func weekdayInsideAWordIsNotADay() {
        let result = parse("Sunrise walk")
        #expect(result.day == nil)
        #expect(result.title == "Sunrise walk")
    }

    // MARK: Dates

    @Test(arguments: ["Trip nov 3", "Trip Nov 3rd", "Trip november 3", "Trip 3 nov", "Trip 3rd November"])
    func monthNameDates(text: String) {
        let result = parse(text)
        #expect(result.day == day(11, 3))
        #expect(result.title == "Trip")
    }

    @Test func numericDateFollowsLocaleOrder() {
        #expect(parse("Trip 3/11", locale: "en_US").day == day(3, 11, year: 2027))
        #expect(parse("Trip 3/11", locale: "en_GB").day == day(11, 3))
    }

    @Test func pastDateGoesToNextYear() {
        #expect(parse("Taxes mar 1").day == day(3, 1, year: 2027))
        #expect(parse("Review oct 29").day == day(10, 29))
    }

    @Test func impossibleDateIsNotADay() {
        let result = parse("Party feb 30")
        #expect(result.day == nil)
        #expect(result.title == "Party feb 30")
    }

    @Test func firstDayTokenWins() {
        let result = parse("Call fri tomorrow")
        #expect(result.day == day(10, 30))
        #expect(result.title == "Call tomorrow")
    }

    @Test func allNewTokensTogether() {
        let result = parse("Flight to Lisbon nov 6 14:30 2h")
        #expect(result.title == "Flight to Lisbon")
        #expect(result.day == day(11, 6))
        #expect(result.minute == 14 * 60 + 30)
        #expect(result.durationMinutes == 120)
    }

    @Test func dayInTimeZoneOfCalendar() {
        // 10:20 PM in New York is already October 30 in UTC.
        let newYork = TestCalendar.make(timeZone: "America/New_York")
        let lateNow = TestCalendar.date(2026, 10, 29, 22, 20, calendar: newYork)
        let result = QuickAddParser.parse("Read tomorrow", now: lateNow, calendar: newYork)
        #expect(result.day == TestCalendar.date(2026, 10, 30, calendar: newYork))
    }
}
