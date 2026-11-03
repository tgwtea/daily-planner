# Documentation index

Start here. Each folder has one job.

| Folder | Holds | Index |
| --- | --- | --- |
| `architecture/` | How the code is organized now and where new code goes | [overview](architecture/overview.md), [repository map](architecture/repository-map.md) |
| `adr/` | Architecture decision records (ADRs): decisions that are made | [adr/README.md](adr/README.md) |
| `design/` | Visual language, tokens, components, SwiftUI mapping | [design-reference.md](design/design-reference.md) |
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

- **Observed**: the Plan My Day v3 mockup shows this. An older line that says "Observed (v2)" describes the v2 mockup and is history.
- **Assumption**: a reasonable implementation choice that the mockup does not show. Change it freely, and update the spec.
- **Decided**: a product decision that the user made. It carries the date, for example "Decided (2026-10-30)".
- **Unresolved**: a product decision that is open. It links to [open-questions.md](open-questions.md). Do not decide it in code without the user.

## Terms

These terms have one meaning in all docs and in code names.

| Term | Meaning |
| --- | --- |
| Block | An item on the timeline with a start time and a duration. Its kind is `task`, `routine`, `event`, or `open`. |
| Block type | How Plan treats a block: Flexible, Fixed, or Open time. See [Block types](features/block-types.md). |
| Flexible block | The default block type. Plan can suggest a move. It never moves the block without approval. |
| Fixed block | A block whose time is taken. It shows a lock glyph. Plan does not suggest a move. |
| Open time | A protected block with a dashed outline, a shield glyph, and no checkbox. Plan never puts tasks in it. UI copy also says "Protected". In code: `Block.Kind.open` (from 1d.1). |
| Unconfirmed block | A past task block that the user did not check off. It keeps a dashed checkbox and the meta text "Not checked off". Time passing never marks a block done. |
| Outcome | The user's answer for an unfinished block: Done, Partly, Not started, or Skip. |
| Focused time | The minutes of Focus recorded on a block, apart from its planned duration. |
| Synced block | A block that the user marked to sync. It has a copy in the dedicated "Plan My Day" calendar in Apple Calendar. It shows a refresh glyph. |
| Task block | A block that you can mark done. It has one color and one icon. |
| Routine | A task block with a checklist of steps. It is done when all steps are done. |
| Event | A read-only block that comes from the system calendar. It has no checkbox. Luna never edits it. |
| Band | One of the three day parts: Morning, Afternoon, Night. The timeline groups blocks by band. |
| Pill | The vertical capsule that draws a block on the timeline. Its height shows the duration. |
| Free gap | A row between two blocks that shows unplanned time. |
| Anytime | Tasks for the selected day that have no time. |
| Inbox | Tasks that have no day and no time yet. |
| Slot search | The rule that finds the first free start for a task in a band. In code: `SlotSearch`. See [Inbox scheduling](features/inbox-scheduling.md). |
| Step | One checklist item inside a block. |
| Repeat rule | How a block repeats: Never, Daily, Weekdays, Weekly. A rule other than Never makes the block a routine. In code: `RepeatRule`, `Block.repeatRule`. |
| Capture | The sheet that saves one line of text at once. Text with a time becomes a block. Any other text becomes a capture in the Inbox. It replaces the term "Quick add" (decided 2026-11-03). In code until checkpoint 1d.5: `QuickAddParser`, `QuickAddDraft`, `QuickAddSheet`. |
| Capture item | An Inbox item that keeps the raw text as written. It has an organization state: organizing, ready, offline, or failed. |
| Suggestion field | One AI-proposed field on a capture item (Title, When, Reminder, List, Estimate). Each field is opt-in. The user applies the checked fields. |
| Pre-fill | The day or time that a "+" button gives Capture before the user types. A token in the text wins. In code: `QuickAddPrefill`. |
| Block color | One of five muted colors: Rose, Slate, Sage, Sand, Plum. |
| Focus session | A session that the user starts on a block. The timer is optional. The session keeps going after the block or the timer ends, until the user ends it. Ending asks whether the task is done. |
| Check-in | An optional prompt during Focus. It is off by default. Nothing is recorded. |
| Plan hub | The Plan sheet: unfinished work, optional energy, an optional review, then a draft. |
| Draft | A set of suggestions for one day that the user approves, edits, skips, or rejects. A draft never changes the day until approval. |
| Suggestion | One draft item on the timeline: new, move, or conflict. It has a dashed outline and a reason line. |
| Energy | An optional input on the Plan hub: Focused, Steady, or Foggy. Luna never infers it. |
| Running-late nudge | The bottom accessory prompt when the active block overruns. At most once per block. |
| Bottom accessory | The one slot above the tab bar. Priority: Focus mini-player, then draft approval, then running-late nudge. |
| Now · Next bar | The sticky glass bar on Today that shows the current and the next block. A tap scrolls to now. |
| Quick review | The sheet that walks the user through Inbox items that need a decision, one card at a time. Skipping changes nothing. |
| Pick-up summary | The card on a rich project that shows the next step and where the user left off, with its source line. |
| Rich project | A project with sections (Tasks, Goals, Notes, Links, Scheduled). A simple project is a plain task list. |
| Habit | A repeated daily goal with a count, a goal, and a streak. |
| Habit streak | The count of done days in a row, up to today, or up to yesterday when today is not done. In code: `HabitStats`. |
| Weekday schedule | The days of the week that a habit is due. In code: `Habit.weekdays`, `Weekday`. |
| Off day | A day that is not in the weekday schedule of a habit. It does not break the streak. For all habits together, a day on which no habit is scheduled. |
| Archived habit | A habit that the user archived. It keeps its history and does not show on Habits or Today. In code: `PlannerStore.archivedHabits`. |
| Heatmap | The 12-week grid on the Habits history card. One cell is one day. Its shade shows the share done. |
| Area | A group of projects, for example Work or Personal. |
| Smart list | A fixed list on the Projects tab: Upcoming, Anytime, Someday, Logbook. In code: `SmartList`. |
| Someday item | An Inbox item that the user set aside for later. It does not show in the Inbox. In code: `PlannerStore.somedayItems`. |
| Project progress | The done and open item counts of one project. In code: `ProjectProgress`. |
| List item | One row in a smart list or on project detail: a block, an Anytime task, an Inbox item, or a Someday item. In code: `ListItem`. |
| Logbook | The smart list of done blocks and done Anytime tasks, newest completion first. |
| Completion time | The time an item became done. Logbook sorts by it. In code: `completedAt`. |
| Band schedule | The start minute of each band. Settings edits it. Default 6:00 AM, 12:00 PM, 6:00 PM. Each band is at least 1 hour long. In code: `BandSchedule`, stored by `BandScheduleStorage`. |
| Store | The one `@Observable` object that holds all app data and its intents. In code: `PlannerStore`. |
| Sample data | The mockup week (Thursday, October 29, 2026, 10:20 AM). DEBUG builds only: previews and the `-LunaSampleData` launch argument. |
| App shell | The root view: the four tabs, the floating tab bar with the Capture button, the bottom accessory slot, and the root sheets and cover. In code: `RootView`, `LunaTabBar`. |
| Route | A screen that a tab pushes onto its navigation stack (Calendar, Block detail, project detail, smart list, Settings and its groups, archived habits). In code: `AppRoute`. |
| Day plan | The Today rows of one day: a section per band with block and free gap rows. In code: `DayPlan`. |
| Active block | The task or routine that runs now and is not done. It shows the now line and the time left. |
| Now line | The 2 pt line with the current time that crosses the active pill. In code: `NowLine`. |
| Router | The `@Observable` navigation state: selected tab, one route path per tab, and the open sheet or cover. In code: `AppRouter`. |
| Shared component | A reusable view that two or more screens use, built from design tokens. In code: `Luna/Shared/Components/`. `ComponentsGallery` shows all of them in DEBUG builds (previews and the `-LunaComponentsGallery` launch argument). |
| Design token | A named design value in code (color role, text style, spacing, radius, shadow, motion). See `Luna/Shared/Design/`. |

## Naming

The app name is **Luna**. The design project and its files use the older name "Plan My Day". Where mockup copy uses "Plan My Day" as the app name, use "Luna". The "Plan" button and the Plan hub keep their names (decided 2026-10-30). The dedicated Apple Calendar calendar for synced blocks is named "Luna" in the app. **Assumption (2026-11-03):** the mockup calls it "Plan My Day"; the app name rule applies.
