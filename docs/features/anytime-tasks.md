# Anytime tasks

Status: Partial (v3 gap: collapsed by default, 1d.4)
Code: `Luna/Shared/Model/AnytimeTask.swift`, `Luna/Shared/Model/PlannerStore.swift`, `Luna/Features/Today/AnytimeSection.swift`
Screens: [Today](../screens/today.md)

## Purpose

Hold tasks for a day that do not need a time.

## Observed

- The Anytime section is above the bands on Today.
- Each row: a 36 pt colored icon tile, a title, and a check circle. Examples: "Pay electricity bill", "Reply to Maya", "Water the plants" (done).
- Tap the check to toggle done. Done rows are struck through.
- The chip shows the count. Tap it to collapse or expand. v3: collapsed by default, with a trailing summary "2 left" or "All done".
- The mockup shows Anytime items on today only. Other days show no Anytime section.
- v2: a "+" button next to the chip opens Quick add. v3 shows no "+" on the Anytime chip. **Assumption (2026-11-03):** keep the "+" (decided 2026-10-30); it opens Capture pre-filled for Anytime.

## Assumptions

- An Anytime task belongs to one day. It has a title, an icon, a color, and a done flag. It has no start time.
- An Anytime task has an optional `projectID`, so a project can list it.
- The section shows on every day with blocks, also with zero tasks, so that its "+" is always there. The mockup shows it with a zero count on other days.

## Decisions

- **Decided (2026-11-03):** Capture text with no time goes to the Inbox as a capture item, also with a day word. This replaces the 2026-10-30 rule that made it an Anytime task. The Anytime "+" still opens Capture pre-filled for Anytime. See [Capture parsing](quick-add-parsing.md#decisions).
- **Decided (2026-10-30):** The "Anytime" smart list on Projects holds Anytime tasks with no date. See [Projects and areas](projects-and-areas.md#decisions).

## Unresolved

- What happens to an Anytime task that is not done at the end of the day? See [open-questions.md](../open-questions.md#capture).

## Related

[Inbox scheduling](inbox-scheduling.md), [Projects](projects-and-areas.md).
