# Quick review

Status: Planned
Artboards: 3t
Features: [Inbox review](../features/inbox-review.md)

## Purpose

Help the user decide on Inbox items and unfinished blocks, one card at a time, in about a minute.

## Layout (top to bottom)

A glass sheet:

1. Header: "Quick review", progress "1 of 4", and a trailing "Skip review" (or "Done" at the end).
2. **Review card:** a colored icon tile, the item title, reason chips (for example "Moved 3 times", "No date"; "Due Friday", "Not scheduled"; "Captured", "Not organized"; "Ended 8:50 AM", "Not checked off").
3. A two-column grid of actions:
   - Inbox item: Schedule (primary), Keep for later, Someday, Remind me, Archive, Skip.
   - Unfinished block: Done (primary), Partly, Not started, Skip for now.
4. Footer: "Skipping keeps everything exactly where it is."
5. End state: circle-check, "All caught up", "Nothing else needs a decision right now."

## Navigation

- Opened by "Start" on the Inbox review card and by the review row in the [Plan hub](plan-my-day.md).

## Interactions

- See [Inbox review](../features/inbox-review.md) for each action and its toast.
- "Skip review" closes the sheet. If items are left, the toast says "Skipped. Everything is still in Inbox."

## Accessibility and iOS notes

- The card is one element with the reasons in its label. Actions are buttons with labels.

## Open questions

None.
