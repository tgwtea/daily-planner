# Focus and Live Activity

Status: Planned
Screens: [Today](../screens/today.md), [Focus](../screens/focus.md), [Live Activity](../screens/live-activity.md)

## Purpose

Run a countdown for the active block on screen, on the lock screen, and in the Dynamic Island.

## Observed

- Only the active block offers Focus. Today shows a "Focus" button and the remaining time inside the block.
- The timer counts down once a second. In the sample, 39:48 is left of a 1 h 30 min block.
- Controls: Pause/Resume, +5 minutes, Done.
- Done marks the block done and returns to Today.
- The ring and the progress bar show elapsed time as a fraction of the block duration.
- "Ends at" is now plus the remaining time. "Up next" names the next block.
- The Live Activity shows the same title, color, icon, timer, progress, and controls.
- Settings has switches: Live Activity, Haptics, End-of-block sound.

## Assumptions

- Store the session as an end date and a paused-remaining value, not as a ticking counter. Compute the display from the clock. This survives the app being suspended.
- Remaining time starts as `block end − now`.
- +5 moves the end date. It does not change the block on the timeline. See Unresolved.
- Live Activity needs a widget extension, ActivityKit, and App Intents. Add it with an ADR.
- At zero, play the end sound if it is on, and post a local notification if the app is in the background.

## Unresolved

- Does +5 extend the block on the timeline and push later blocks? See [open-questions.md](../open-questions.md#focus).
- What happens at zero: auto-done, or a prompt?
- Can you start Focus on a block that is not active?
- What does "More" contain?

## Related

[Block completion](block-completion-and-routines.md), [Settings](settings-and-appearance.md).
