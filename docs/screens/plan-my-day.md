# Plan my day

Status: Planned
Artboards: 2q
Features: [Plan my day suggestions](../features/plan-my-day-suggestions.md)

## Purpose

Suggest times for Inbox tasks in today's free time. The canvas calls it optional. Nothing is added until you confirm.

## Layout (top to bottom)

A glass sheet:

1. Grabber.
2. A small label "✦ Suggestion" (sparkles icon, 13 pt, secondary). Title "Plan my day" (24 pt bold). A line: "3 Inbox tasks fit into today's free time. Pick the ones you want." With no fit: "Your free time is already full today."
3. A list of proposals on `surface-hover`. Each row: a 24 pt check circle (on by default; inverted fill when on), a 36 pt colored circle with the icon, a title, and a meta line "10:30 – 10:45 AM · Morning".
4. A full-width primary button "Add 3 blocks" (the count follows the selection; "Add blocks" when none) and a ghost button "Not now".

## Navigation

- Opened by the "Plan" capsule on [Today](today.md). "Not now" or a scrim tap closes it.

## Interactions

- Tap a row to include or exclude it.
- "Add N blocks" adds the selected proposals to today and removes them from the Inbox. The sheet closes.

## Accessibility and iOS notes

- Each row is a toggle with a label: title, time, band, state.

## Open questions

None. See [Plan my day suggestions](../features/plan-my-day-suggestions.md#decisions).
