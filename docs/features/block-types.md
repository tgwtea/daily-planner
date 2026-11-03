# Block types

Status: Planned
Screens: [Today](../screens/today.md), [Block detail](../screens/block-detail.md), [Calendar](../screens/calendar.md)

## Purpose

Tell Plan what it may change. A block is Flexible, Fixed, or Open time. Events are a fourth, read-only kind.

## Observed (v3)

| Type | Model (prototype) | Pill | Glyph | Check circle | Plan may |
| --- | --- | --- | --- | --- | --- |
| Flexible | `kind: task` (default) | Solid block color | none | Yes | Suggest a move, with approval |
| Fixed | `kind: task`, `mode: fixed` | Solid block color | lock | Yes | Nothing. The time is taken. |
| Open time | `kind: open` | Transparent, 2 pt dashed `border-strong`, `icon-secondary` icon | shield | No | Nothing. It never puts tasks here. |
| Event | `kind: event` | Graphite (`surface-tertiary`, past `surface-secondary`) | calendar | No | Nothing. Luna never edits it. |

- Open time meta line: "6:00 – 7:00 · Protected". It has no color and does not count in "X of Y done".
- Routines are Flexible unless marked Fixed.
- Block detail sets the type with a segmented control and a note per type.
- Settings › Scheduling sets the default type for new blocks (Flexible).
- Settings › Protected time lists recurring Open time ("Unwind · Weekdays · 6–7 PM", "Gaming with Leo · Thu · 10–11 PM", "Saturday with Mia · Sat · 2–6 PM").
- The Focus anchor names the next Fixed block or event: "Fixed · Office hours at 3:00 PM".

## Assumptions

- `Block.Kind` gains `open`. A new `Block.isFixed` flag holds Fixed (1d.1). A routine or task can be Fixed. Open time has no icon color and no steps.
- Changing a block to Open time clears its done state. Its steps are hidden, not deleted.
- A recurring Open time row in Settings creates Open time blocks by its repeat rule.

## Decisions

- **Decided (2026-11-03):** the glossary term is "Open time". "Protected" is UI copy only.

## Edge cases

- A suggestion that overlaps Open time is a conflict.
- A capture placed by the user into Open time is allowed ("You can still add blocks yourself.").

## Related

[Timeline](timeline-and-day-bands.md), [Plan hub suggestions](plan-my-day-suggestions.md), [Block editing](block-editing.md).
