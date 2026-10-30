# Documentation index

Start here. Each folder has one job.

| Folder | Holds | Index |
| --- | --- | --- |
| `architecture/` | How the code is organized now and where new code goes | [overview](architecture/overview.md), [repository map](architecture/repository-map.md) |
| `adr/` | Architecture decision records (ADRs): decisions that are made | [adr/README.md](adr/README.md) |
| `design/` | Visual language, tokens, components, SwiftUI mapping | [design-reference.md](design/design-reference.md), [artboards](design/artboards/README.md) |
| `screens/` | One spec per screen or sheet | [screens/README.md](screens/README.md) |
| `features/` | One spec per behavior or workflow | [features/README.md](features/README.md) |
| — | Phases, checkpoints, and the completion log. Start every task here. | [roadmap.md](roadmap.md) |
| — | All product and technical questions that are still open | [open-questions.md](open-questions.md) |

## Status labels

Each screen and feature spec starts with one status line:

- `Status: Planned`: the spec describes intended behavior. No code implements it.
- `Status: Implemented`: code implements the spec. The spec names the main source files.
- `Status: Partial`: code implements part of the spec. The spec lists what is missing.
- `Status: Deprecated`: the behavior was removed or replaced. Keep the file and link to the replacement.

## Statement labels

Specs mark each requirement with one of these labels:

- **Observed**: the Plan My Day v2 mockup shows this.
- **Assumption**: a reasonable implementation choice that the mockup does not show. Change it freely, and update the spec.
- **Decided**: a product decision that the user made. It carries the date, for example "Decided (2026-10-30)".
- **Unresolved**: a product decision that is open. It links to [open-questions.md](open-questions.md). Do not decide it in code without the user.

## Terms

These terms have one meaning in all docs and in code names.

| Term | Meaning |
| --- | --- |
| Block | An item on the timeline with a start time and a duration. Its kind is `task`, `routine`, or `event`. |
| Task block | A block that you can mark done. It has one color and one icon. |
| Routine | A task block with a checklist of steps. It is done when all steps are done. |
| Event | A read-only block that comes from the system calendar. It has no checkbox. |
| Band | One of the three day parts: Morning, Afternoon, Night. The timeline groups blocks by band. |
| Pill | The vertical capsule that draws a block on the timeline. Its height shows the duration. |
| Free gap | A row between two blocks that shows unplanned time. |
| Anytime | Tasks for the selected day that have no time. |
| Inbox | Tasks that have no day and no time yet. |
| Step | One checklist item inside a block. |
| Block color | One of five muted colors: Rose, Slate, Sage, Sand, Plum. |
| Focus session | A countdown timer that runs inside the active block. |
| Habit | A repeated daily goal with a count, a goal, and a streak. |
| Area | A group of projects, for example Work or Personal. |
| Smart list | A fixed list on the Projects tab: Upcoming, Anytime, Someday, Logbook. |
| Band schedule | The start minute of each band. Settings edits it. Default 6:00 AM, 12:00 PM, 6:00 PM. In code: `BandSchedule`. |
| Store | The one `@Observable` object that holds all app data and its intents. In code: `PlannerStore`. |
| Sample data | The mockup week (Thursday, October 29, 2026, 10:20 AM). DEBUG builds only: previews and the `-LunaSampleData` launch argument. |
| App shell | The root view: the five tabs, the floating tab bar with the "+" button, and the root sheets and cover. In code: `RootView`, `LunaTabBar`. |
| Route | A screen that a tab pushes onto its navigation stack (Calendar, project detail). In code: `AppRoute`. |
| Router | The `@Observable` navigation state: selected tab, one route path per tab, and the open sheet or cover. In code: `AppRouter`. |
| Shared component | A reusable view that two or more screens use, built from design tokens. In code: `Luna/Shared/Components/`. `ComponentsGallery` shows all of them in DEBUG builds (previews and the `-LunaComponentsGallery` launch argument). |
| Design token | A named design value in code (color role, text style, spacing, radius, shadow, motion). See `Luna/Shared/Design/`. |

## Naming

The app name is **Luna**. The design project and its files use the older name "Plan My Day". Where mockup copy uses "Plan My Day" as the app name, use "Luna". The "Plan my day" suggestion sheet and the "Plan" button keep their names (decided 2026-10-30).
