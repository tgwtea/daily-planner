# Live Activity

Status: Planned
v3: Existing. Changes: "End" replaces "Done", and the subtitle covers the no-timer mode.
Artboards: 3aa
Features: [Focus and Live Activity](../features/focus-and-live-activity.md)

## Purpose

Show the running focus session on the lock screen and in the Dynamic Island.

## Layout

The mockup draws a lock screen: lock icon, "Thursday, October 29", a 104 pt clock "10:20". iOS draws these. The app provides only the parts below.

**Lock screen card** (glass, radius 28, padding 18):

1. A 40 × 56 pt pill in the block color with the icon. The title (17 pt semibold). A subtitle "Focus · ends 11:00 AM", "Focus · open-ended" (no timer or timer done), or "Paused". The time (30 pt bold) on the trailing side: time left, "+mm:ss" after the timer, or elapsed time without a timer.
2. A 6 pt progress bar in the block color.
3. Three 40 pt capsule buttons: Pause/Resume, "+5 min", End. **Decided (2026-11-03):** End opens the app on the [End Focus sheet](end-focus-sheet.md). It never marks the task done.

**Dynamic Island (compact):** leading, a 24 pt circle in the block color with the icon. Trailing, the remaining time in the block color (15 pt semibold).

## Interactions

- **Observed:** the three buttons do the same as on [Focus](focus.md).

## iOS notes

- Needs ActivityKit and a widget extension target. Add it with an ADR.
- Buttons need App Intents (`LiveActivityIntent`).
- Use `Text(timerInterval:)` for the countdown so the system updates it.
- The expanded and minimal Dynamic Island layouts are not in the mockup.
- The Settings switch "Live Activity" turns this on or off.

## Open questions

None. The Dynamic Island layouts are in [Focus and Live Activity](../features/focus-and-live-activity.md#decisions).
