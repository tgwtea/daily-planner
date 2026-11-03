import Foundation
import Testing
@testable import Luna

@Suite struct HabitDraftTests {
    @Test func newDraftNeedsAName() {
        var draft = HabitDraft()
        #expect(!draft.isValid)
        draft.name = "  \n "
        #expect(draft.trimmedName == nil)
        #expect(!draft.isValid)
        draft.name = " Read "
        #expect(draft.trimmedName == "Read")
        #expect(draft.isValid)
    }

    @Test func draftNeedsADayAndAGoalInRange() {
        var draft = HabitDraft()
        draft.name = "Read"
        draft.weekdays = []
        #expect(!draft.isValid)
        draft.weekdays = [.sunday]
        draft.goal = 0
        #expect(!draft.isValid)
        draft.goal = 100
        #expect(!draft.isValid)
        draft.goal = 99
        #expect(draft.isValid)
    }

    @Test func roundTripKeepsHabitFields() {
        let habit = Habit(
            name: "Water", icon: "waterbottle", color: .slate, goal: 8, subtitle: "8 glasses a day",
            weekdays: [.monday, .friday], history: [DayKey(TestCalendar.date(2026, 10, 29), calendar: TestCalendar.utc): 5]
        )
        var copy = habit
        copy.name = "Changed"
        HabitDraft(habit: habit).apply(to: &copy)
        #expect(copy == habit)
    }

    @Test func applyTrimsTheDetail() {
        var habit = Habit(name: "Read", icon: "book", color: .sand, goal: 1, subtitle: "")
        var draft = HabitDraft(habit: habit)
        draft.detail = "  20 minutes "
        draft.apply(to: &habit)
        #expect(habit.subtitle == "20 minutes")
    }
}
