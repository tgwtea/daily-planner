# Inbox drawer

Status: Planned
Artboards: 2d
Features: [Inbox scheduling](../features/inbox-scheduling.md)

## Purpose

Bring Inbox tasks onto today's timeline without leaving Today.

## Layout

A glass sheet, 440 pt high on a 956 pt screen (about the medium detent). The scrim is lighter than other sheets (black 18%), so the timeline stays visible.

1. Grabber (36 × 5 pt).
2. Header "Inbox 5" (20 pt semibold, count in tertiary) and a "Done" text button.
3. Hint: "Drag onto the timeline, or tap to use the next free slot."
4. A scrolling list. Each row: a 40 pt colored circle with an icon, a title (16 pt semibold), the duration, and a grip icon.

## Navigation

- Opened by the Inbox pill or "Open Inbox" on [Today](today.md). Done or a scrim tap closes it.

## Interactions

- **Observed:** tap a row. The task goes to the first free slot of today (Morning, then Afternoon, then Night) and leaves the Inbox.
- **Observed (static demo only):** dragging. A free gap on the timeline turns into a drop target: a dashed 52 × 60 pt pill outline, a bold time label, and a tilted floating ghost "Call the dentist / Drop at 9:45 · 15 min". The dragged row fades to 35% in the drawer.
- **Decided (2026-10-30):** drag snaps to 15 min and drops only into a free gap that fits. See [Inbox scheduling](../features/inbox-scheduling.md#decisions).

## Accessibility and iOS notes

- Use `.draggable` on rows and `.dropDestination` on gaps. The timeline must stay scrollable under the sheet.
- Tap-to-place is the accessible path. Drag is not required to schedule.

## Open questions

See [open-questions.md](../open-questions.md#inbox) (other days).
