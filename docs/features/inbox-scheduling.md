# Inbox scheduling

Status: Partial (place in a band done; drawer tap and drag in 1c.2; v3 item fields in 1d.1)
Code: `Luna/Shared/Model/SlotSearch.swift`, `Luna/Shared/Model/InboxItem.swift`, `Luna/Shared/Model/PlannerStore.swift` (`placeInBand`, `schedule`, `renameInboxItem`, `deleteInboxItem`, `moveInboxItems`), `Luna/Features/Inbox/`
Screens: [Inbox](../screens/inbox.md), [Inbox drawer](../screens/inbox-drawer.md), [Today](../screens/today.md)

## Purpose

Move a task from the Inbox to a time on today's timeline.

## Observed

Inbox item: id, title, duration, icon, color, tag. v3 adds an optional due text ("Due Fri"), a reminder ("Fri 6:00 PM", bell icon), and a moved count (`deferred`, meta "Moved 3×"). A capture item is a separate kind: see [Capture and organization](capture-and-organization.md). Sample items (v2, kept in the app):

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

After scheduling: the task becomes a task block on today with the same title, duration (30 min when it has none), icon, and color. It leaves the Inbox. v3 shows a toast "Scheduled 2:30 PM" or "No free slot left today".

The drawer lists the Inbox items to plan, not the capture items. Slot search is unchanged in v3.

v2: the Inbox pill on Today shows the Inbox count. **Decided (2026-11-03):** v3 removes the pill. The Today header drawer button shows the count of items to plan as a badge. The Inbox tab shows the count of all Inbox items as a badge.

## Assumptions

- The slot search is a pure function with unit tests: `SlotSearch.firstFreeSlot`. Inputs: blocks, day, band, duration, now, band schedule.
- "Now rounded up" uses whole minutes. 10:20 becomes 10:30. 10:30 stays 10:30. The now rule applies only when the day is the day of now.
- The 7:00 AM floor applies to every band, also when Settings moves the Morning start earlier.
- Night ends at 11:59 PM in the slot search. A slot that ends after 11:59 PM does not fit. This matches the [day limit](timeline-and-day-bands.md#decisions).
- A block that touches the slot (ends at its start, or starts at its end) does not overlap.
- Place in a band uses today, the day of the app clock. It does not use the day that Today shows.
- Events count as busy time in the slot search. The mockup code treats all blocks as busy.
- Drag snaps to 15 minutes.
- The tag is stored as `projectID`. The scheduled block keeps the same `projectID`.
- The sample tags "Work" and "Personal" are area names, not projects. The sample data links "Draft Q4 self-review" to Q4 planning. "Order a new chalk bag" has no project.
- The store cuts a scheduled duration to end at 11:59 PM. It refuses a start at 11:59 PM or later and keeps the item in the Inbox.

## Decisions

- **Decided (2026-10-30):** If the band has no free slot, an inline message says "No free time in <Band>" and a warning haptic plays. The item stays in the Inbox.
- **Decided (2026-10-30):** Drag snaps to 15 min. The timeline auto-scrolls near its edges. A drop is accepted only in a free gap that fits the task. A drop on a block or into a shorter gap is refused.
- **Decided (2026-10-30):** An Inbox tag is a project. A tag links the item to that project.

## Unresolved

- Can you schedule into another day than today? See [open-questions.md](../open-questions.md#inbox).

## Edge cases

- Late in the day there may be no slot after now.
- A task longer than every band remainder never fits.

## Related

[Timeline](timeline-and-day-bands.md), [Plan hub](plan-my-day-suggestions.md), [Capture parsing](quick-add-parsing.md), [Inbox review](inbox-review.md).
