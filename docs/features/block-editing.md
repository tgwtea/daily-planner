# Block editing

Status: Planned
Screens: [Edit block](../screens/edit-block.md)

## Purpose

Change a block's properties after you create it.

## Observed

- You can edit task and routine blocks. Events are read-only and do not open the editor.
- Duration choices: 15, 30, 45, 60, 90, 120 minutes.
- Color choices: the five block colors.
- Icon choices: 12 icons (laptop, file-text, git-pull-request, dumbbell, bike, utensils, book-open, phone, shopping-basket, moon, sunrise, plane).
- Steps: toggle each step. "Add step" shows but does nothing.
- Shown but not editable in the mockup: Date, Starts, Band (derived from start), Repeat ("Weekdays"), Alert ("5 min before").
- Changes apply at once. Save and Close both return.

## Assumptions

- Use a draft copy. Save commits it. Close discards it. This is the iOS norm for a screen with Save and Close. It differs from the mockup.
- Changing the start time moves the block to the matching band.
- A custom duration is possible from the Duration row. The chips are presets.

## Decisions

- **Decided (2026-10-30):** Edit block keeps a draft. Save commits the draft. Close discards it. If the draft has changes, Close asks for confirmation.
- **Decided (2026-10-30):** Tap the hero title to edit it inline. A red "Delete block" row at the bottom deletes the block after a confirmation. The Today row also has a context-menu Delete.
- **Decided (2026-10-30):** Repeat choices: Never, Daily, Weekdays, Weekly. Alert choices: None, At start, 5, 10, and 15 min before.
- **Decided (2026-10-30):** The icon picker shows the 12 design icons first. A "More" button opens a grid of about 60 curated SF Symbols with search.

## Unresolved

- Duplicate a block. See [open-questions.md](../open-questions.md#editing).

## Edge cases

- A new duration makes the block overlap the next block.

## Related

[Block completion](block-completion-and-routines.md), [Timeline](timeline-and-day-bands.md).
