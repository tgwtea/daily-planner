# Screen specs

One file per screen or sheet in the Plan My Day v2 mockup. Shared visual values are in the [design reference](../design/design-reference.md). Behavior rules are in the [feature specs](../features/README.md).

## Navigation map

```
Tab bar (glass) ─┬─ Today ──┬─ Calendar (push)
                 │          ├─ Edit block (tap a task pill)
                 │          ├─ Focus (Focus button on the active block)
                 │          ├─ Inbox drawer (sheet, from the Inbox pill)
                 │          └─ Plan my day (sheet, from the Plan button)
                 ├─ Inbox
                 ├─ Projects
                 ├─ Habits
                 └─ Settings
"+" button (next to the tab bar) ── Quick add (sheet, from every tab)
Focus ── Live Activity (system lock screen and Dynamic Island)
```

**Decided (2026-10-30):** the system `TabView` tab bar plus a custom glass "+" circle at the bottom trailing edge. Edit block is a large sheet. Focus is a full-screen cover. A project row pushes a project detail screen.

The tab bar and the "+" button show on the five main tabs. They hide on Calendar, Edit block, Focus, and while Quick add is open.

## Index

| Screen | Kind | Status |
| --- | --- | --- |
| [Today](today.md) | Tab | Planned |
| [Inbox](inbox.md) | Tab | Planned |
| [Projects](projects.md) | Tab | Planned |
| [Habits](habits.md) | Tab | Planned |
| [Settings](settings.md) | Tab | Planned |
| [Calendar](calendar.md) | Pushed screen | Planned |
| [Edit block](edit-block.md) | Full screen | Planned |
| [Focus](focus.md) | Full screen | Planned |
| [Quick add](quick-add.md) | Sheet | Planned |
| [Inbox drawer](inbox-drawer.md) | Sheet | Planned |
| [Plan my day](plan-my-day.md) | Sheet | Planned |
| [Live Activity](live-activity.md) | System surface | Planned |

## Spec template

```markdown
# <Screen name>

Status: Planned
Artboards: <IDs>
Features: <links>

## Purpose
## Layout (top to bottom)
## Components
## Navigation
## Interactions
## States
## Visual details
## Accessibility and iOS notes
## Open questions
```
