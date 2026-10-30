# Anytime tasks

Status: Partial (model and intent only, no UI)
Code: `Luna/Shared/Model/AnytimeTask.swift`, `Luna/Shared/Model/PlannerStore.swift`
Screens: [Today](../screens/today.md)

## Purpose

Hold tasks for a day that do not need a time.

## Observed

- The Anytime section is above the bands on Today.
- Each row: a 36 pt colored icon tile, a title, and a check circle. Examples: "Pay electricity bill", "Reply to Maya", "Water the plants" (done).
- Tap the check to toggle done. Done rows are struck through.
- The chip shows the count. Tap it to collapse or expand.
- The mockup shows Anytime items on today only. Other days show no Anytime section.
- The "+" button next to the chip opens Quick add.

## Assumptions

- An Anytime task belongs to one day. It has a title, an icon, a color, and a done flag. It has no start time.
- An Anytime task has an optional `projectID`, so a project can list it.

## Decisions

- **Decided (2026-10-30):** Quick add text with a day word and no time ("pay bill tomorrow") becomes an Anytime task on that day. The Anytime "+" opens Quick add pre-filled for Anytime. See [Quick add parsing](quick-add-parsing.md#decisions).
- **Decided (2026-10-30):** The "Anytime" smart list on Projects holds Anytime tasks with no date. See [Projects and areas](projects-and-areas.md#decisions).

## Unresolved

- What happens to an Anytime task that is not done at the end of the day? See [open-questions.md](../open-questions.md#capture).

## Related

[Inbox scheduling](inbox-scheduling.md), [Projects](projects-and-areas.md).
