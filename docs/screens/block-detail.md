# Block detail

Status: Planned
Artboards: 3af (and 3ag for the sync conflict dialog)
Features: [Block editing](../features/block-editing.md), [Block types](../features/block-types.md), [Calendar views and events](../features/calendar-views-and-events.md#two-way-sync), [Block completion and routines](../features/block-completion-and-routines.md)

**Decided (2026-11-03):** the block editor is a pushed screen named "Block detail". It replaces the 2026-10-30 decision for a large sheet. The heading copy stays "Edit block" ("Edit suggestion" for a draft item). The old spec is [edit-block.md](edit-block.md) (deprecated).

## Purpose

Change one block: type, duration, time, sync, color, icon, and checklist.

## Layout (top to bottom)

1. **Header.** Glass close button, heading "Edit block" (17 pt semibold), and a small primary "Save".
2. **Hero.** A 64 pt wide pill, height `min(120, 60 + duration × 0.5)`, in the block color (Open time: dashed outline, transparent; suggestion: 20% tint and dashed outline). The meta line "Today · 10:00 – 11:30 AM" and the title (26 pt bold).
3. **Block type.** A segmented control: Flexible, Fixed, Open time. A note under it:
   - Flexible: "Flexible. Plan may suggest moving it, but never moves it without asking."
   - Fixed: "Fixed. Plan treats this time as taken and won't suggest moving it."
   - Open time: "Open time. Protected, with no checkbox. Plan won't put tasks here."
4. **Duration.** Chips 15 min, 30 min, 45 min, 1 h, 1 h 30 min, 2 h. The selected chip is inverted.
5. **Details list.** Date, Starts, Band (from the start time), Repeat, Reminder.
6. **Sync group.** A switch "Show in Apple Calendar" (refresh icon). Footer: "Synced to the Plan My Day calendar. Edits here update it; edits there ask before changing this block." or "Local only. Nothing is written to Apple Calendar." Use "Luna" for the calendar name (see [Naming](../README.md#naming)).
7. **Color.** Five 40 pt circles.
8. **Icon.** A grid of 12 icons: laptop, book-open, sigma, dumbbell, guitar, utensils, users, phone, shopping-bag, moon, sofa, gamepad-2.
9. **Checklist** (when the block has steps). Step rows and "+ Add step".
10. A "Delete block" row.

## Navigation

- Pushed from a task, routine, Open time, or suggestion pill on [Today](today.md) and from a task block in [Calendar](calendar.md). Events do not open it. The tab bar hides.
- Close and Save return to the screen that pushed it.

## Interactions

- Type, duration, color, icon, and step taps update the hero live.
- The sync switch shows a toast: "Will appear in your Plan My Day calendar" or "Local only now".
- "Delete block" opens a dialog: title "Delete "Gym"?". Body for a synced block: "This also removes its copy from your Plan My Day calendar. Other calendar events aren't touched." Otherwise: "It's only stored here. Calendar events aren't affected." Buttons: "Delete" (`status-error` text) and "Cancel". Toast "Block deleted".
- The 2026-10-30 decisions in [Block editing](../features/block-editing.md#decisions) still apply: a draft with Save and Close, tap the title to edit it, Repeat and Alert choices, and the icon "More" grid.

## States

- A block with no steps shows no checklist section in the mockup. **Assumption:** keep the "Add step" row, as decided for v2.

## Accessibility and iOS notes

- A `NavigationStack` push. Detail rows push or show inline pickers.
- The type control is a `Picker` with `.segmented` style.
- Color circles have names as labels ("Rose, selected").

## Open questions

None.
