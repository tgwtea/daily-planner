# Edit block

Status: Planned
Artboards: 2h
Features: [Block editing](../features/block-editing.md), [Block completion and routines](../features/block-completion-and-routines.md)

## Purpose

Change one block's duration, time, color, icon, and checklist.

## Layout (top to bottom)

1. **Header.** Glass close button (x), title "Edit block" (17 pt semibold), and a small primary "Save" button.
2. **Hero.** A 64 pt wide pill in the block color. Its height is `min(120, 60 + duration × 0.5)` and animates on change. Next to it: a meta line "Today · 9:30 – 11:00 AM" and the title (26 pt bold).
3. **Duration.** Label "Duration". Capsule chips: 15 min, 30 min, 45 min, 1 h, 1 h 30 min, 2 h. The selected chip is inverted.
4. **Details list.** Rows with icon, name, value, chevron: Date (Today), Starts (9:30 AM), Band (Morning), Repeat (Weekdays), Alert (5 min before).
5. **Color.** Label "Color". Five 40 pt circles: Rose, Slate, Sage, Sand, Plum. The selected one has a 2 pt ring with 3 pt offset.
6. **Icon.** Label "Icon". A 6-column grid of 12 icons (radius 16): laptop, file-text, git-pull-request, dumbbell, bike, utensils, book-open, phone, shopping-basket, moon, sunrise, plane. The selected icon is inverted.
7. **Checklist.** Label "Checklist". A grouped list of steps with 22 pt check circles in the block color. A last row "+ Add step" in tertiary.

## Navigation

- Opened by a tap on a task or routine pill on [Today](today.md). Events do not open it.
- Close and Save both return to Today.

## Interactions

- **Observed:** duration, color, icon, and step taps change the block at once. The hero updates live.
- **Observed:** Save and Close both just return. The mockup has no draft or discard step.
- **Observed:** the Date, Starts, Band, Repeat, and Alert rows have no action. The Band value comes from the start time.
- **Observed:** the "Add step" row has no action.

## States

- A block with no steps shows only the "Add step" row.

## Accessibility and iOS notes

- **Assumption:** present it as a full-screen cover or a large sheet with a `NavigationStack`, so detail rows can push pickers.
- Color circles need names as labels ("Rose, selected").
- Use `DatePicker` for Date and Starts.

## Open questions

- Edit in place or keep a draft until Save? See [open-questions.md](../open-questions.md#editing).
- How do you edit the title, delete a block, or turn a task into a routine?
- What values do Repeat and Alert support?
- Only 12 icons are in the picker. Is there a full icon search?
