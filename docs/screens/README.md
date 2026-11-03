# Screen specs

One file per screen or sheet in the Plan My Day v3 mockup. Shared visual values are in the [design reference](../design/design-reference.md). Behavior rules are in the [feature specs](../features/README.md).

## Navigation map

From the v3 handoff, with the decisions of 2026-11-03:

```
Tab bar (custom glass, 4 tabs) + Capture circle
├─ Today ── header: "Today ▾" → Calendar (push)
│           · Plan → Plan hub (sheet) → Quick review (sheet)
│           · Inbox drawer button → Inbox drawer (sheet, medium detent)
│           · gear → Settings (push)
│   ├─ Block detail (push, from a pill) → Delete / Sync conflict (dialog)
│   ├─ Before and after (sheet, from the nudge)
│   └─ Focus (full-screen cover) → I'm stuck (sheet) · End Focus (sheet)
├─ Inbox ── Quick review (sheet) · capture suggestions (inline expand) · gear
├─ Projects ── Project detail (push) → sections (disclosure) · Smart list (push) · gear
├─ Habits ── Habit editor (sheet) · Archived habits (push) · gear
└─ Settings (push from any gear) → Settings group (push)
Capture circle → Capture (sheet, keyboard up), from every tab
Bottom accessory (one at a time): Focus mini-player › draft approval › running-late nudge
Onboarding (full-screen cover, first launch)
Focus ── Live Activity (system lock screen and Dynamic Island)
```

**Decided (2026-11-03):** v3 is the reference. The changes from v2:

- Tabs are roots. Project, Block detail, Settings, and Calendar push with a back button and hide the tab bar. Plan, Capture, Quick review, the Inbox drawer, Before and after, and the Focus sheets are sheets. Focus is full-screen.
- The custom floating tab bar stays (`LunaTabBar`, decided 2026-10-30). v3 behavior is added by hand: on a downward scroll the bar compacts to icons only (64 to 52 pt); on an upward scroll the labels return. The Inbox tab shows a count badge. The Capture circle (plus icon, label "Capture") matches the bar height.
- One bottom accessory slot above the tab bar. Priority: Focus mini-player (while Focus runs, on all roots), then the draft approval bar (Today), then the running-late nudge (Today). Nothing stacks. The accessory moves with the bar (106 pt or 94 pt above the bottom).
- The floating Inbox pill is gone. The Inbox drawer opens from a header button on Today.
- The Settings gear is on every root header, Today included. The v3 canvas omits it on Today; the handoff puts it on every root.
- Edit block is now Block detail, a pushed screen (replaces the 2026-10-30 large-sheet decision).
- A sticky Now · Next bar on Today answers "what am I doing" from anywhere on the timeline.

The tab bar and the Capture circle show on the four roots. They hide on pushed screens, on Focus, on onboarding, and while Capture is open.

**Implemented (1a.4, v2):** `Luna/Features/AppShell/` (`RootView`, `LunaTabBar`, `AppRouter`, `AppRoute`, `AppTab`). `AppRouter.isTabBarHidden` controls the bar. Checkpoint 1d.3 adds the compact behavior, the accessory slot, the gears, and the header drawer button.

**Assumption (1a.4):** the tab icon is 20 pt, the bar has a 5 pt inner padding (v3), the Capture circle sits 12 pt from the capsule, and the selected tab has a `glassItemHover` capsule. Tab labels are 11 pt semibold (v3).

## Index

| Screen | Kind | Status |
| --- | --- | --- |
| [Today](today.md) | Tab | Partial |
| [Inbox](inbox.md) | Tab | Partial |
| [Projects](projects.md) | Tab | Partial |
| [Project detail](project-detail.md) | Pushed screen | Partial |
| [Smart list](smart-list.md) | Pushed screen | Implemented |
| [Habits](habits.md) | Tab | Partial |
| [Habit editor](habit-editor.md) | Sheet | Implemented |
| [Archived habits](archived-habits.md) | Pushed screen | Implemented |
| [Settings](settings.md) | Pushed screen | Partial |
| [Settings group](settings-group.md) | Pushed screen | Planned |
| [Calendar](calendar.md) | Pushed screen | Planned |
| [Block detail](block-detail.md) | Pushed screen | Planned |
| [Focus](focus.md) | Full screen | Planned |
| [I'm stuck sheet](stuck-sheet.md) | Sheet | Planned |
| [End Focus sheet](end-focus-sheet.md) | Sheet | Planned |
| [Capture](capture.md) | Sheet | Partial |
| [Inbox drawer](inbox-drawer.md) | Sheet | Planned |
| [Plan hub](plan-my-day.md) | Sheet | Planned |
| [Before and after](before-after.md) | Sheet | Planned |
| [Quick review](quick-review.md) | Sheet | Planned |
| [Sync conflict](sync-conflict.md) | Dialog | Planned |
| [Onboarding](onboarding.md) | Full screen | Planned |
| [Live Activity](live-activity.md) | System surface | Planned |
| [Quick add](quick-add.md) | Sheet | Deprecated, see Capture |
| [Edit block](edit-block.md) | Sheet | Deprecated, see Block detail |

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
