# Projects and areas

Status: Partial (model only, no progress math, no UI)
Code: `Luna/Shared/Model/Area.swift`, `Luna/Shared/Model/Project.swift`
Screens: [Projects](../screens/projects.md)

## Purpose

Organize tasks that are not on today into projects, areas, and smart lists.

## Observed

- Smart lists: Upcoming, Anytime, Someday, Logbook, with counts (12, 8, 14, none).
- Areas group projects: Work and Personal.
- A project has a name, a color, a progress fraction, a meta line (due date, date range, "No date", "Ongoing"), and an open-task count.
- No row has an action in the mockup.

## Assumptions

- Progress = done tasks / all tasks in the project.
- Logbook lists done tasks and blocks.
- A project stores its date line as `Timing`: no date, ongoing, a due date, or a date span. Progress and the open count come from linked items in checkpoint 1b.4.

## Decisions

- **Decided (2026-10-30):** Smart lists:
  - Upcoming: blocks and Anytime tasks with a date after today, by date.
  - Anytime: Anytime tasks with no date.
  - Someday: Inbox items marked Someday.
  - Logbook: done items, newest first.
- **Decided (2026-10-30):** A project row pushes a project detail screen. See [Projects](../screens/projects.md#navigation-and-interactions).
- **Decided (2026-10-30):** A toolbar "+" menu on Projects has New Project and New Area. Each opens a small sheet (name, color, and area for a project).
- **Decided (2026-10-30):** An Inbox tag is a project.
- Roadmap checkpoint 1b.6 builds the detail screen, the smart lists, and creation.

## Related

[Anytime tasks](anytime-tasks.md), [Inbox scheduling](inbox-scheduling.md).
