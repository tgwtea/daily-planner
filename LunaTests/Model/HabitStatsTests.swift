import Foundation
import Testing
@testable import Luna

@Suite struct HabitStatsTests {
    private let calendar = TestCalendar.utc
    /// Thursday, October 29, 2026.
    private let today = TestCalendar.date(2026, 10, 29, 10, 20)

    /// A habit done on each day `daysBack` before today (0 is today).
    private func habit(
        goal: Int = 1, weekdays: Set<Weekday> = Set(Weekday.allCases), doneDaysBack: [Int], partial: [Int: Int] = [:]
    ) -> Habit {
        var history: [Date: Int] = [:]
        for daysBack in doneDaysBack {
            history[day(daysBack)] = goal
        }
        for (daysBack, value) in partial {
            history[day(daysBack)] = value
        }
        return Habit(name: "Habit", icon: "circle", color: .slate, goal: goal, subtitle: "", weekdays: weekdays, history: history)
    }

    private func day(_ daysBack: Int) -> Date {
        calendar.date(byAdding: .day, value: -daysBack, to: calendar.startOfDay(for: today))!
    }

    // MARK: Streak

    @Test func streakIncludesTodayWhenDone() {
        let habit = habit(doneDaysBack: [0, 1, 2, 4])
        #expect(HabitStats.streak([habit], today: today, calendar: calendar) == 3)
    }

    @Test func streakEndsAtYesterdayWhenTodayIsNotDone() {
        let habit = habit(goal: 8, doneDaysBack: [1, 2], partial: [0: 5])
        #expect(HabitStats.streak([habit], today: today, calendar: calendar) == 2)
    }

    @Test func streakIsZeroAfterAMissedYesterday() {
        let habit = habit(doneDaysBack: [2, 3])
        #expect(HabitStats.streak([habit], today: today, calendar: calendar) == 0)
    }

    @Test func combinedStreakNeedsEveryHabit() {
        let a = habit(doneDaysBack: [0, 1, 2, 3])
        let b = habit(doneDaysBack: [0, 1, 3])
        #expect(HabitStats.streak([a, b], today: today, calendar: calendar) == 2)
        #expect(HabitStats.streak([], today: today, calendar: calendar) == 0)
    }

    @Test func bestStreakFindsLongestRun() {
        let habit = habit(doneDaysBack: [0, 1, 5, 6, 7, 8, 20])
        #expect(HabitStats.bestStreak([habit], today: today, calendar: calendar) == 4)
        #expect(HabitStats.bestStreak([Self.emptyHabit], today: today, calendar: calendar) == 0)
    }

    // MARK: Weekday schedules
    // Today is Thursday. Days back: 1 Wednesday, 3 Monday, 6 Friday, 8 Wednesday, 10 Monday.

    private let mondayWednesdayFriday: Set<Weekday> = [.monday, .wednesday, .friday]

    @Test func offDaysDoNotBreakStreak() {
        let habit = habit(weekdays: mondayWednesdayFriday, doneDaysBack: [1, 3, 6, 8])
        #expect(HabitStats.streak([habit], today: today, calendar: calendar) == 4)
    }

    @Test func missedScheduledDayEndsStreak() {
        // Monday (3 back) is missed.
        let habit = habit(weekdays: mondayWednesdayFriday, doneDaysBack: [1, 6, 8])
        #expect(HabitStats.streak([habit], today: today, calendar: calendar) == 1)
    }

    @Test func scheduledTodayNotDoneEndsStreakAtLastScheduledDay() {
        let habit = habit(weekdays: [.thursday], doneDaysBack: [7, 14], partial: [0: 0])
        #expect(HabitStats.streak([habit], today: today, calendar: calendar) == 2)
    }

    @Test func doneOnOffDayCountsInStreak() {
        // Today is an off day, but the habit is logged. It counts and does not end the run.
        let habit = habit(weekdays: mondayWednesdayFriday, doneDaysBack: [0, 1])
        #expect(HabitStats.streak([habit], today: today, calendar: calendar) == 1)
    }

    @Test func noScheduledDayGivesZeroStreak() {
        let habit = habit(weekdays: [], doneDaysBack: [0, 1, 2])
        #expect(HabitStats.streak([habit], today: today, calendar: calendar) == 0)
        #expect(HabitStats.bestStreak([habit], today: today, calendar: calendar) == 0)
    }

    @Test func combinedStreakChecksOnlyScheduledHabits() {
        let daily = habit(doneDaysBack: [0, 1, 2, 3])
        // Not done on Monday (3 back), its only day.
        let mondays = habit(weekdays: [.monday], doneDaysBack: [])
        #expect(HabitStats.streak([daily, mondays], today: today, calendar: calendar) == 3)
        #expect(!HabitStats.isOffDay([daily, mondays], on: today, calendar: calendar))
        #expect(HabitStats.isOffDay([mondays], on: today, calendar: calendar))
    }

    @Test func bestStreakSkipsOffDays() {
        // Runs: 20, 17, 15, 13 (4 scheduled days), then 10 and 8 missed, then 6, 3, 1.
        let habit = habit(weekdays: mondayWednesdayFriday, doneDaysBack: [1, 3, 6, 13, 15, 17, 20])
        #expect(HabitStats.bestStreak([habit], today: today, calendar: calendar) == 4)
    }

    @Test func monthPercentCountsScheduledDaysOnly() {
        // October 1–29 has 12 Mondays, Wednesdays, and Fridays. 3 done: 25%. Thursday (0 back) is an off day.
        let habit = habit(weekdays: mondayWednesdayFriday, doneDaysBack: [0, 1, 3, 6])
        #expect(HabitStats.monthPercent([habit], today: today, calendar: calendar) == 25)
        #expect(HabitStats.monthPercent([self.habit(weekdays: [], doneDaysBack: [0])], today: today, calendar: calendar) == 0)
    }

    @Test func shareIgnoresHabitsOnTheirOffDay() {
        let daily = habit(doneDaysBack: [0])
        let offToday = habit(weekdays: mondayWednesdayFriday, doneDaysBack: [])
        #expect(HabitStats.share([daily, offToday], on: today, calendar: calendar) == 1)
        #expect(HabitStats.share([habit(weekdays: mondayWednesdayFriday, doneDaysBack: [0])], on: today, calendar: calendar) == 0)
        #expect(HabitStats.doneCount([daily, offToday], on: today, calendar: calendar) == 1)
        #expect(HabitStats.scheduled([daily, offToday], on: today, calendar: calendar).count == 1)
    }

    // MARK: Month

    @Test func monthPercentUsesElapsedDays() {
        // October 29 is day 29. Done on 10 of 29 days: 34%.
        let habit = habit(doneDaysBack: Array(0..<10))
        #expect(HabitStats.monthPercent([habit], today: today, calendar: calendar) == 34)
    }

    @Test func monthPercentOnFirstDay() {
        let first = TestCalendar.date(2026, 11, 1, 9)
        let done = Habit(name: "A", icon: "circle", color: .rose, goal: 1, subtitle: "", history: [calendar.startOfDay(for: first): 1])
        #expect(HabitStats.monthPercent([done], today: first, calendar: calendar) == 100)
        // The October history does not count in November.
        #expect(HabitStats.monthPercent([habit(doneDaysBack: [0, 1])], today: first, calendar: calendar) == 0)
    }

    @Test func combinedMonthPercentCountsHabitDays() {
        // Two habits over 29 days: 58 habit-days. 29 + 0 done: 50%.
        let a = habit(doneDaysBack: Array(0..<29))
        let b = habit(doneDaysBack: [])
        #expect(HabitStats.monthPercent([a, b], today: today, calendar: calendar) == 50)
        #expect(HabitStats.monthPercent([], today: today, calendar: calendar) == 0)
    }

    // MARK: Heatmap

    @Test func heatmapHas84CellsAndFutureDaysAreNil() {
        let cells = HabitStats.heatmap([habit(doneDaysBack: [0])], today: today, calendar: calendar)
        #expect(cells.count == 84)
        // Thursday is row 3 of the last column. Friday to Sunday are in the future.
        #expect(cells[80] == 1)
        #expect(cells[81...].allSatisfy { $0 == nil })
        #expect(cells[..<81].allSatisfy { $0 != nil })
    }

    @Test func heatmapColumnsRunMondayToSunday() {
        // Monday, October 26 is 3 days back: row 0 of the last column.
        let cells = HabitStats.heatmap([habit(doneDaysBack: [3])], today: today, calendar: calendar)
        #expect(cells[77] == 1)
        #expect(cells[78] == 0)
    }

    @Test func shareIsValueOverGoalForOneHabit() {
        let water = habit(goal: 8, doneDaysBack: [], partial: [0: 2])
        #expect(HabitStats.share([water], on: today, calendar: calendar) == 0.25)
    }

    @Test func shareIsDoneHabitsForMany() {
        let a = habit(doneDaysBack: [0])
        let b = habit(goal: 8, doneDaysBack: [], partial: [0: 7])
        #expect(HabitStats.share([a, b], on: today, calendar: calendar) == 0.5)
    }

    @Test func heatStrengthRunsFrom35To100Percent() {
        #expect(HabitStats.heatStrength(0) == 0.35)
        #expect(HabitStats.heatStrength(1) == 1)
        #expect(HabitStats.heatStrength(2) == 1)
    }

    // MARK: Sample data

    @Test func sampleStreaksMatchSpec() {
        let store = PlannerStore.sample()
        let streaks = store.habits.map { HabitStats.streak([$0], today: SampleData.now, calendar: SampleData.calendar) }
        // The mockup shows 4 for Read. Its week row gives 1. See docs/features/habits.md.
        #expect(streaks == [12, 23, 1, 0, 6])
        #expect(HabitStats.doneCount(store.habits, on: SampleData.now, calendar: SampleData.calendar) == 1)
    }

    private static let emptyHabit = Habit(name: "Empty", icon: "circle", color: .sage, goal: 1, subtitle: "")
}
