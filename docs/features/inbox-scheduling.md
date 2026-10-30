# Inbox scheduling

Status: Planned
Screens: [Inbox](../screens/inbox.md), [Inbox drawer](../screens/inbox-drawer.md), [Today](../screens/today.md)

## Purpose

Move a task from the Inbox to a time on today's timeline.

## Observed

Inbox item: id, title, duration, icon, color, tag. Sample items:

| Title | Duration | Tag |
| --- | --- | --- |
| Call the dentist | 15 min | Health |
| Draft Q4 self-review | 60 min | Work |
| Book flights to Lisbon | 30 min | Lisbon trip |
| Order a new chalk bag | 10 min | Personal |
| Renew passport | 20 min | Lisbon trip |

Three ways to schedule:

1. **Place in a band** (Inbox tab, swipe actions). Find the first free slot in that band of today.
2. **Tap in the drawer.** Find the first free slot of today, in band order Morning, Afternoon, Night.
3. **Drag to a gap** (drawer, static demo). Drop at the start of a free gap that is long enough.

Slot search (`findSlot`):
- Start at the latest of: the band start, 7:00 AM, and (for today) now rounded up to the next 15 minutes.
- Step by 15 minutes.
- A slot fits when `start + duration ≤ band end` and it does not overlap any block on that day.
- Return the first fit, or nothing.

After scheduling: the task becomes a task block on today with the same title, duration, icon, and color. It leaves the Inbox.

The Inbox pill on Today shows the Inbox count. It hides when the Inbox is empty.

## Assumptions

- The slot search is a pure function with unit tests. Inputs: blocks, day, band, duration, now.
- Events count as busy time in the slot search. The mockup code treats all blocks as busy.
- Drag snaps to 15 minutes.

## Unresolved

- No free slot: what feedback? See [open-questions.md](../open-questions.md#inbox).
- Can you schedule into another day than today?
- Drag details: snap, auto-scroll, drop on a block, drop into a gap shorter than the task.
- Does the tag map to a project?

## Edge cases

- Late in the day there may be no slot after now.
- A task longer than every band remainder never fits.

## Related

[Timeline](timeline-and-day-bands.md), [Plan my day](plan-my-day-suggestions.md), [Quick add](quick-add-parsing.md).
