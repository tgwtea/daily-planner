# Habits

Status: Partial (implemented on v2; v3 gap: hide streaks and the "optional" copy, 1d.9)
Code: `Luna/Shared/Model/Habit.swift`, `Weekday.swift`, `HabitDraft.swift`, `HabitStats.swift`, `PlannerStore.swift` (`logHabit`, `addHabit`, `updateHabit`, `archiveHabit`, `restoreHabit`, `deleteArchivedHabit`, `moveHabits`), `Luna/Features/Habits/`, `Luna/Features/Today/HabitStripView.swift`
Screens: [Today](../screens/today.md), [Habits](../screens/habits.md), [Habit editor](../screens/habit-editor.md), [Archived habits](../screens/archived-habits.md)

## Purpose

Track small daily goals. Streaks are optional to show. Habits are optional: a missed day is not marked or counted against the user.

## Observed

- A habit has: name, icon, color, value today, goal, streak, subtitle, and a per-day done history.
- A goal can be more than 1 (Water: 8 glasses).
- Tap to log: value + 1. When the value is at the goal, a tap resets it to 0.
- Done today: value ≥ goal.
- Today's ring shows value / goal as a stroke. A done habit fills its circle with its color.
- The Habits subtitle shows "N of M done today".
- The habit card's week row shows Monday to Sunday. Past days come from history. Today follows the done state. Future days are empty.
- The history card shows a 12-week heatmap for one habit and three numbers: day streak, this month %, best streak. In the mockup these values are static.

v3 (3ak):
- A "Show streaks" switch (on Habits, and in Settings › Appearance). Off: no flame and no streak numbers. Each card shows "N this week". The history card shows "86% This month" and "5 of 7 This week".
- The Habits subtitle ends with "all optional". Footer: "Habits are optional. Missing a day isn't marked or counted against you."
- The "Habits on Today" setting hides the habit strip on Today.

## Assumptions

- The streak counts consecutive done days up to and including today, or up to yesterday if today is not done yet. An off day is skipped. It does not break or extend the streak.
- An off day is a day that is not in the weekday set of the habit. For all habits together, an off day is a day on which no habit is scheduled.
- A log on an off day counts as a done day in the streak. Logging is not blocked on an off day.
- "This month" is done scheduled habit-days divided by scheduled habit-days in the elapsed month. With no scheduled day it is 0%.
- Heatmap shade for one habit is value / goal per day. An off day has a share of 0. A cell with a share above 0 mixes the habit color with the canvas at 35–100%. A share of 0 and a future day use `surface-tertiary`. The columns are weeks, oldest first. Each column runs Monday to Sunday.
- A new habit is scheduled every day. A habit needs at least one weekday. The goal is 1 to 99.
- An empty detail shows the schedule as the card subtitle, for example "Mon, Wed, Fri". In code: `Weekday.summary(of:)`.
- Archive moves a habit to `PlannerStore.archivedHabits` with its history. Restore adds it at the end of the habit list.
- Streak and percent math is a pure function with unit tests.
- A habit stores its count per day in `history`, keyed by the start of the day. "Value today" is the history value of today.
- The sample data builds 12 weeks of history that match the mockup week row. The mockup gives Read a streak of 4, but its week row (Wednesday done, Tuesday not done) gives a streak of 1. The computed streak shows 1. This is an intended difference.

## Decisions

- **Decided (2026-10-30):** Habit management (create, edit, archive, reorder) is roadmap checkpoint 1b.7, after 1b.3. It uses an editor sheet (name, icon, color, goal, weekdays), a swipe to archive, and drag to reorder. 1b.3 uses the sample habits.
- **Decided (2026-10-30):** Each habit has a set of weekdays. A day that is not in the set does not break the streak.
- **Decided (2026-10-30):** The history card combines all habits. A heatmap cell shows the share of scheduled habits done that day. A tap on a habit card filters the history card to that habit.
- **Decided (2026-10-30):** No HealthKit input in v1. Logging is manual.
- **Decided (2026-10-31):** For all habits together, a day is done only when every habit is done. The day streak and best streak count these days. "This month" is done habit-days divided by scheduled habit-days in the elapsed month.
- **Decided (2026-10-31):** A tap on a Today habit ring logs the day that Today shows. On a future day the rings do not log.
- **Decided (2026-10-31):** An "Archived" row at the bottom of the Habits tab pushes the archived list. A swipe there restores a habit, or deletes it and its history after a confirmation.
- **Decided (2026-10-31):** The editor has an optional free-text detail. It is the card subtitle.
- **Decided (2026-10-31):** A leading swipe edits a habit. A trailing swipe archives it. A long press shows a menu with Edit and Archive. A tap on the card still selects it for the history card.
- **Decided (2026-10-31):** On an off day, the Today strip hides the habit. "N of M done today" counts only scheduled habits. The habit card week row marks off days.

## Unresolved

- Is the reset-at-goal tap intended, or should a separate undo exist? See [open-questions.md](../open-questions.md#habits).

## Related

[Settings](settings-and-appearance.md).
