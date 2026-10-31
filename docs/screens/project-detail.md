# Project detail

Status: Implemented
Code: `Luna/Features/Projects/ProjectDetailScreen.swift`, `ListItemRow.swift`, `ListEmptyView.swift`
Artboards: none
Features: [Projects and areas](../features/projects-and-areas.md)

## Purpose

Show one project: its progress, its notes, and its items.

## Layout (top to bottom)

1. Large navigation title: the project name. Back button. A "+" toolbar button ("Add task").
2. A card: a 60 pt progress ring in the project color with the percent inside, the date line ("Due Nov 14"), and "5 open · 7 done".
3. A grouped card with a multi-line notes field (placeholder "Notes").
4. **Scheduled**, **Anytime**, and **Done** groups of list item rows. A group with no items does not show.

## Components

- **Assumption:** a list item row is a 36 pt icon tile, the title (17 pt semibold), a meta line, and a check circle. Inbox and Someday items have no check circle. A done item has a struck-through tertiary title.
- **Assumption:** the meta line is "Done 28 Oct" for a done item, "Thu, 29 Oct · 9:30 AM" for a block, "Sat, 31 Oct" for a dated task, "Inbox, 30 min" for an Inbox item, and the duration for a Someday item. Project detail hides the project name.

## Navigation

- **Decided (2026-10-30):** a project row on Projects pushes this screen. The tab bar hides.
- **Decided (2026-10-31):** the Inbox context menu item "Open <Project>" pushes it on the Inbox tab.

## Interactions

- **Decided (2026-10-31):** "+" opens an alert "New task" with a title field, Add, and Cancel. Add creates an Anytime task with no day in the project. An empty title adds nothing.
- **Assumption:** the check circle toggles the item. It moves between the open groups and Done with an animation.
- **Assumption:** each edit of the notes field saves at once.

## States

- **Assumption:** a project with no items shows the card "No tasks yet. Tap + to add one."
- **Assumption:** a project that does not exist shows "No project".

## Accessibility and iOS notes

- The progress card is one element: "Progress", value "58 percent done, Due 14 Nov, 5 open, 7 done".
- The check circle label is "Complete <title>". It has the selected trait when done.

## Open questions

None.
