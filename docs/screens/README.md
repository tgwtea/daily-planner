# Screen specs

One file per screen or sheet in the Plan My Day v2 mockup. Shared visual values are in the [design reference](../design/design-reference.md). Behavior rules are in the [feature specs](../features/README.md).

## Navigation map

```
Tab bar (glass) ─┬─ Today ──┬─ Calendar (push)
                 │          ├─ Edit block (tap a task pill)
                 │          ├─ Focus (Focus button on the active block)
                 │          ├─ Inbox drawer (sheet, from the Inbox pill)
                 │          ├─ Plan my day (sheet, from the Plan button)
                 │          └─ Settings (push, from the gear) ─┬─ Band start (push)
                 │                                             └─ Theme (push)
                 ├─ Inbox
                 ├─ Projects ─┬─ Project detail (push)
                 │            └─ Smart list (push)
                 └─ Habits ───┬─ Habit editor (sheet)
                              └─ Archived habits (push)
"+" button (next to the tab bar) ── Quick add (sheet, from every tab)
Focus ── Live Activity (system lock screen and Dynamic Island)
```

**Decided (2026-10-30):** a `TabView` for the five tabs with the system tab bar hidden, plus a custom floating tab bar (`LunaTabBar`): a glass capsule with the five tabs and a separate primary "+" circle. This replaces the first decision (system tab bar plus a "+" circle). On iPhone, the system bar with five tabs fills the width, and a sixth tab goes into a "More" tab. Edit block is a large sheet. Focus is a full-screen cover. A project row pushes a project detail screen.

**Decided (2026-10-31):** the tab bar has four tabs (Today, Inbox, Projects, Habits). Settings is a push from a gear icon button in the Today header. Reason: on a 375 pt iPhone, five tabs plus the "+" circle leave about 50 pt per tab, and "Projects" and "Settings" truncate at larger text sizes. Four tabs give about 63 pt each. This is an intended difference from the artboards, which show five tabs.

The tab bar and the "+" button show on the four main tabs. They hide on Calendar, Settings, Edit block, Focus, and while Quick add is open.

**Implemented (1a.4):** `Luna/Features/AppShell/` (`RootView`, `LunaTabBar`, `AppRouter`, `AppRoute`, `AppTab`). `AppRouter.isTabBarHidden` controls the bar. Each tab and route is a placeholder until its checkpoint. Today is built (1b.1). Projects pushes project detail and the smart lists (1b.6). Habits pushes the archived habits (1b.7). The Inbox context menu pushes project detail on the Inbox tab.

**Assumption (1a.4):** the design reference gives only the bar height (64 pt). The tab icon is 20 pt, the bar has a 4 pt inner padding, the "+" circle sits 12 pt from the capsule, and the selected tab has a `glassItemHover` capsule. No artboard comparison ran in 1a.4. Check these values in 3.3.

## Index

| Screen | Kind | Status |
| --- | --- | --- |
| [Today](today.md) | Tab | Partial |
| [Inbox](inbox.md) | Tab | Implemented |
| [Projects](projects.md) | Tab | Implemented |
| [Project detail](project-detail.md) | Pushed screen | Implemented |
| [Smart list](smart-list.md) | Pushed screen | Implemented |
| [Habits](habits.md) | Tab | Implemented |
| [Habit editor](habit-editor.md) | Sheet | Implemented |
| [Archived habits](archived-habits.md) | Pushed screen | Implemented |
| [Settings](settings.md) | Tab | Partial |
| [Calendar](calendar.md) | Pushed screen | Planned |
| [Edit block](edit-block.md) | Full screen | Planned |
| [Focus](focus.md) | Full screen | Planned |
| [Quick add](quick-add.md) | Sheet | Implemented |
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
