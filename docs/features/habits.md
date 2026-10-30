# Habits

Status: Planned
Screens: [Today](../screens/today.md), [Habits](../screens/habits.md)

## Purpose

Track small daily goals and keep streaks.

## Observed

- A habit has: name, icon, color, value today, goal, streak, subtitle, and a per-day done history.
- A goal can be more than 1 (Water: 8 glasses).
- Tap to log: value + 1. When the value is at the goal, a tap resets it to 0.
- Done today: value ≥ goal.
- Today's ring shows value / goal as a stroke. A done habit fills its circle with its color.
- The Habits subtitle shows "N of M done today".
- The habit card's week row shows Monday to Sunday. Past days come from history. Today follows the done state. Future days are empty.
- The history card shows a 12-week heatmap for one habit and three numbers: day streak, this month %, best streak. In the mockup these values are static.

## Assumptions

- The streak counts consecutive done days up to and including today, or up to yesterday if today is not done yet.
- "This month" is the done-day count divided by the elapsed days in the month.
- Heatmap shade is value / goal per day.
- Streak and percent math is a pure function with unit tests.

## Decisions

- **Decided (2026-10-30):** Habit management (create, edit, archive, reorder) is roadmap checkpoint 1b.7, after 1b.3. It uses an editor sheet (name, icon, color, goal, weekdays), a swipe to archive, and drag to reorder. 1b.3 uses the sample habits.
- **Decided (2026-10-30):** Each habit has a set of weekdays. A day that is not in the set does not break the streak.
- **Decided (2026-10-30):** The history card combines all habits. A heatmap cell shows the share of scheduled habits done that day. A tap on a habit card filters the history card to that habit.
- **Decided (2026-10-30):** No HealthKit input in v1. Logging is manual.

## Unresolved

- Is the reset-at-goal tap intended, or should a separate undo exist? See [open-questions.md](../open-questions.md#habits).

## Related

[Settings](settings-and-appearance.md).
