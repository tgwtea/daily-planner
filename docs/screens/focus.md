# Focus

Status: Planned
Artboards: 2i
Features: [Focus and Live Activity](../features/focus-and-live-activity.md)

## Purpose

Show a full-screen countdown for the active block, so you can work on one thing.

## Layout (top to bottom)

1. Glass "Minimize" button (chevron-down), the label "Focus" (15 pt semibold, secondary), and a glass "More" button (ellipsis).
2. A capsule with a 28 pt color circle, the block icon, and the block title.
3. A 300 pt ring. Track `surface-secondary`, 10 pt stroke. Progress in the block color, round caps. In the center: the remaining time "39:48" (72 pt bold, tabular) and "of 1 h 30 min" (or "Paused").
4. A line "Ends at 11:00 · Up next: Design review".
5. Three controls at the bottom: "+5" (64 pt circle, label "Minutes"), Pause/Resume (84 pt primary circle), Done (64 pt circle with a check).

## Navigation

- Opened by the "Focus" button on the active block on [Today](today.md).
- Minimize returns to Today. Done marks the block done and returns to Today.
- Tab bar is hidden.
- **Decided (2026-10-30):** Focus opens as a full-screen cover. It also opens from the "Focus" context-menu action on any task that is not done.

## Interactions

- Pause toggles to Resume. The center label changes to "Paused".
- "+5" adds 5 minutes to the remaining time.
- The ring shows elapsed time as a fraction of the block duration. It moves once a second.
- **Observed:** "More" has no action.

## Accessibility and iOS notes

- The timer text needs a VoiceOver label in words ("39 minutes 48 seconds left"). Do not announce every second.
- Use `.sensoryFeedback` on pause and done when Haptics is on.
- Keep the screen awake while Focus is open. **Assumption.**

## Open questions

None. See [Focus and Live Activity](../features/focus-and-live-activity.md#decisions). That spec lists the "More" menu items.
