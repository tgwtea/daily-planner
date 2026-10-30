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

## Decisions

- **Decided (2026-10-30):** +5 extends the focus session only. The block and later blocks on the timeline do not move.
- **Decided (2026-10-30):** At zero, the app plays a haptic and the end sound. "Done" becomes the main action. The timer counts the overrun time. The block is not marked done automatically.
- **Decided (2026-10-30):** The user can start Focus on any task that is not done, from its context menu. The session length is the block duration. The timeline does not move.
- **Decided (2026-10-30):** The "More" menu holds: Edit block, Show or hide the Live Activity, End without done, Sound on or off.
- **Decided (2026-10-30):** Dynamic Island: minimal shows the progress ring. Compact shows the icon and the remaining time. Expanded shows the title, the ring, the timer, and the Pause, +5, and Done buttons.

## Related

[Block completion](block-completion-and-routines.md), [Settings](settings-and-appearance.md).
