# Focus

Status: Planned
Artboards: 3v, 3w, 3y (and 3x, 3z for its sheets)
Features: [Focus and Live Activity](../features/focus-and-live-activity.md)

## Purpose

Help the user stay on one task: an optional timer, the next step, the checklist, and the next fixed commitment.

## Layout (top to bottom)

1. A glass "Minimize" button, a capsule with the block icon and title, and a glass "Show check-in" button.
2. Segmented control: "Timer", "No timer".
3. **Focus ring** with the big time in the center:
   - Timer: "39:48" and "left on the timer". After zero: "+05:12" and "Timer done. Keep going as long as you like."
   - No timer: the elapsed time and "focused, no timer".
   - Paused: "Paused".
4. An end line: "Ends at 11:30 AM · then you decide", "Block ends at 11:30", or "Block ended at 11:30. Focus keeps going until you end it."
5. **Focus anchor:** "Next step" with the first open step (or "Checklist done. Add a next step?"). A disclosure "Checklist · 1 of 3" that shows the steps.
6. A line with a lock: "Fixed · Office hours at 3:00 PM" (the next fixed block or event today).
7. Controls: "+5" (Extend, timer mode only), Pause/Resume (78 pt primary), End (square icon).
8. An "I'm stuck" capsule (compass), when the setting is on.
9. **Check-in card** (3y, when check-ins are on): "Still with it?", "A check-in every 20 minutes, because you turned it on. Not answering is fine.", and four buttons: "Still focusing", "Need a moment", "Help me get back on track", "Turn off check-ins".

## Navigation

- Opened by "Focus" on the active block, by the Focus mini-player, and by "Focus now" on a project pick-up card.
- **Decided (2026-10-30, kept):** a full-screen cover.
- Minimize returns to Today. The Focus mini-player then shows in the bottom accessory.
- End opens the [End Focus sheet](end-focus-sheet.md). "I'm stuck" opens the [I'm stuck sheet](stuck-sheet.md).

## Interactions

- Tap the next step: mark that step done (toast "Step done").
- "+5" adds 5 minutes to the timer (from zero if it ran out). Toast "Extended 5 min".
- Check-in: "Need a moment" pauses. "Help me get back on track" opens the I'm stuck sheet. "Turn off check-ins" sets the setting off.
- **Decided (2026-11-03):** the v2 "Done" control and the "More" menu are gone. Ending never checks off the task. This replaces the 2026-10-30 rules "Done marks the block done" and "at zero, show Done as the main action".

## Accessibility and iOS notes

- The timer text has a label in words ("39 minutes 48 seconds left"). Do not announce every second.
- `.sensoryFeedback` on pause and end when Haptics is on. Keep the screen awake. **Assumption.**

## Open questions

None. See [Focus and Live Activity](../features/focus-and-live-activity.md#decisions).
