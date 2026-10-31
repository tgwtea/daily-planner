# Projects and areas

Status: Implemented
Code: `Luna/Shared/Model/Area.swift`, `Project.swift` (timing text, notes), `ProjectProgress.swift`, `ProjectItems.swift`, `SmartList.swift`, `ListItem.swift`, `PlannerStore.swift` (add project, area, task; completion time)
Screens: [Projects](../screens/projects.md), [Project detail](../screens/project-detail.md), [Smart list](../screens/smart-list.md)

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
- A project stores its date line as `Timing`: no date, ongoing, a due date, or a date span. The date line uses the device locale: "Due Nov 14" and "Dec 18 – 27" in en_US, "Due 14 Nov" and "18 – 27 Dec" in en_GB.
- Project items are task and routine blocks, Anytime tasks, Inbox items, and Someday items with the project's ID. Events do not count. Inbox and Someday items are always open.
- Smart list counts include open items only. Upcoming does not count events (they come from the calendar in 2.2).
- A project has free-text notes. Project detail edits them in place.
- A new project has no date (`Timing.noDate`). The New Project sheet does not set a date.
- A task that the project detail "+" adds has the icon `list.bullet` and the project color.
- Upcoming and the Scheduled group show open items only. Scheduled also holds open blocks of today and of past days.
- Someday items are a separate store array (`somedayItems`), not a flag on Inbox items. The Inbox tab and its offset-based reorder stay unchanged.

## Decisions

- **Decided (2026-10-31):** progress, open counts, and smart list counts come from items. See [Projects](../screens/projects.md#intended-differences).
- **Decided (2026-10-30):** Smart lists:
  - Upcoming: blocks and Anytime tasks with a date after today, by date.
  - Anytime: Anytime tasks with no date.
  - Someday: Inbox items marked Someday.
  - Logbook: done items, newest first.
- **Decided (2026-10-30):** A project row pushes a project detail screen. See [Projects](../screens/projects.md#navigation-and-interactions).
- **Decided (2026-10-30):** A toolbar "+" menu on Projects has New Project and New Area. Each opens a small sheet (name, color, and area for a project).
- **Decided (2026-10-30):** An Inbox tag is a project.
- **Decided (2026-10-31):** Logbook sorts by the completion time. `Block` and `AnytimeTask` have `completedAt`. The toggle intents set it when the item becomes done and clear it when the item becomes open. A routine gets it when its last step becomes done. Items with no completion time go last.
- **Decided (2026-10-31):** the project detail "+" opens a text-field alert. It adds an Anytime task with no day to the project. Quick add (1c.1) can replace it.
- **Decided (2026-10-31):** project detail groups: **Scheduled** (open blocks and open dated Anytime tasks, earliest first), **Anytime** (open Anytime tasks with no day, then Inbox items, then Someday items), **Done** (done blocks and done Anytime tasks, newest first).
- **Decided (2026-10-31):** an Inbox tag links to its project through the row context menu item "Open <Project>". See [Inbox](../screens/inbox.md#interactions).

## Related

[Anytime tasks](anytime-tasks.md), [Inbox scheduling](inbox-scheduling.md).
