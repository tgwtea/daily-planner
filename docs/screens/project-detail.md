# Project detail

Status: Partial (built in 1b.6 before v3; the v3 gaps are listed below)
Code: `Luna/Features/Projects/ProjectDetailScreen.swift`, `ListItemRow.swift`, `ListEmptyView.swift`
Artboards: 3ac (simple), 3ad (rich), 3ae (fallback)
Features: [Projects and areas](../features/projects-and-areas.md)

## Purpose

Show one project. A simple project stays a task list. A rich project opens on a next step and a grounded "where you left off".

## v3 layout (Observed)

1. Glass back button ("Projects") and a glass "More" button. Header: the area (small), the project name (large), and a meta line ("6 tasks · TestFlight by Dec 1").
2. **Pick-up card** (rich project, when "Project summaries" is on): "Next step" and the step, "Focus now" (primary, play) and "Schedule" (secondary, calendar-plus). Then "Where you left off" with a summary, for example "Last worked on Tuesday for 1 h 20 min. The week strip layout is done. Dragging rows onto the timeline is in progress, 1 of 3 steps. You left a note about .draggable and .dropDestination." A source line with sparkles: "From your blocks, checklist and notes". A "Show details" disclosure lists activity ("Today · Focus started at 10:00", "Tue · Focused 1 h 20 min · Week strip layout done").
3. **Fallback card** (3ae, too little data): "Not much to go on yet", "You added this project on Oct 30 and haven't worked on it yet, so there's nothing to summarize. A next step makes coming back easier.", and "Add a next step".
4. **Sections** (rich project): Tasks, Goals, Notes, Links, Scheduled. Each is a collapsed disclosure row with an icon and a count. Tasks opens by default.
5. **Connected services** group: "Connect a service · None". Footer: "Optional, later. A connected service like GitHub can add recent work to "Where you left off."" **Decided (2026-11-03):** post-v1. Hide it in v1.
6. **Simple project** (3ac): a task list with check circles, "Add task", and a button "Add notes, goals or links" that makes it rich.

### v3 interactions

- "Focus now" opens [Focus](focus.md) on the next step's block. "Schedule" goes to Today and asks the user to drag from the Inbox drawer.
- The summary is a draft from the on-device model, grounded in blocks, checklists, and notes. It never invents work. With too little data, the fallback card shows.

## v3 gaps

- Pick-up card, fallback card, sections, simple-to-rich upgrade, header meta (1d.8). The v2 progress card and Scheduled / Anytime / Done groups (below) map into the Tasks and Scheduled sections. **Assumption:** keep the progress ring in the header.

## Layout (1b.6, before v3)

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
