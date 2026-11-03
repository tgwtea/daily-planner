# Focus and Live Activity

Status: Planned
Screens: [Today](../screens/today.md), [Focus](../screens/focus.md), [I'm stuck sheet](../screens/stuck-sheet.md), [End Focus sheet](../screens/end-focus-sheet.md), [Live Activity](../screens/live-activity.md)

## Purpose

Help the user stay on one task, with an optional timer, on screen, on the lock screen, and in the Dynamic Island. Ending a session never decides that the task is done.

## Observed (v3)

- Focus is entered manually: "Focus" on the active block, the Focus mini-player, or "Focus now" on a project pick-up card.
- Two modes: **Timer** (counts down from the block end) and **No timer** (counts up). The Settings default is "Until block ends" with "Start with a timer" on.
- When the timer reaches zero, Focus keeps going. The time shows the overrun ("+05:12") and "Timer done. Keep going as long as you like." When the block ends, the line says "Block ended at 11:30. Focus keeps going until you end it."
- Controls: Extend "+5" (timer mode only; from zero if the timer ran out), Pause/Resume, End.
- End opens the End Focus sheet: "Mark done" records the focused time and marks the block done; "Not yet, keep it open" records the time only. See [Block completion](block-completion-and-routines.md).
- **Focus anchor:** the next open step (tap it to mark it done), the checklist ("Checklist · 1 of 3"), and the next fixed commitment today ("Fixed · Office hours at 3:00 PM": the next Fixed block or event).
- Minimize returns to Today. The Focus mini-player shows in the bottom accessory with "Focusing · 39:48" and a pause button. Today shows the block as focusing and the Now · Next bar says "Now · focusing 39:48".
- The Live Activity shows the title, color, icon, the time, progress, and Pause, "+5 min", End.
- Settings › Focus: Default timer, Start with a timer, Show "I'm stuck", Check-ins (off) and the interval (20 min), Live Activity, Haptics, End-of-timer sound. Footer: "When a block ends, Focus keeps going until you end it. Ending never checks off the task."

## I'm stuck

- A capsule on Focus, when the "Show "I'm stuck"" setting is on.
- The sheet shows where the user is (block, project, minutes in), what is done (done steps, the note), and one small next step. "Make it smaller" gives a smaller step. "Pause and step away" pauses.
- The small step comes from the on-device model. **Assumption:** without the model, show the first open step and hide "Make it smaller".

## Check-ins

- Off by default. When on, a card shows every 20 minutes: "Still with it?" with "Still focusing", "Need a moment" (pauses), "Help me get back on track" (opens I'm stuck), "Turn off check-ins".
- "Not answering is fine. Nothing is recorded." Luna never infers attention.

## Assumptions

- Store the session as a start date, an optional end date, paused intervals, and the mode. Compute the display from the clock. This survives suspension.
- Live Activity needs a widget extension, ActivityKit, and App Intents. Add it with an ADR.
- At timer zero, play the haptic and the end sound if they are on, and post a local notification if the app is in the background.

## Decisions

- **Decided (2026-11-03):** v3 Focus replaces the v2 rules. Focus keeps going after the timer or the block ends. Only "Mark done" on the End Focus sheet marks the block done. The v2 "Done" control and the "More" menu are gone. This replaces the 2026-10-30 decisions "at zero, Done becomes the main action" and the "More" menu items.
- **Decided (2026-10-30, kept):** +5 extends the session only. The block and later blocks do not move.
- **Decided (2026-10-30, kept):** the user can start Focus on any task that is not done, from its context menu.
- **Decided (2026-11-03):** Dynamic Island: minimal shows the progress ring. Compact shows the icon and the time. Expanded shows the title, the ring, the time, and Pause, +5, and End. End opens the End Focus sheet in the app. This replaces "Done" in the 2026-10-30 decision.

## Related

[Block completion](block-completion-and-routines.md), [Running-late nudge](running-late-nudge.md), [Settings](settings-and-appearance.md).
