# Smart list

Status: Implemented
Code: `Luna/Features/Projects/SmartListScreen.swift`, `ListItemRow.swift`, `ListEmptyView.swift`
v3: No artboard. The v2 spec stays valid (decided 2026-11-03).
Artboards: none
Features: [Projects and areas](../features/projects-and-areas.md)

## Purpose

Show the items of one smart list: Upcoming, Anytime, Someday, or Logbook.

## Layout (top to bottom)

1. Large navigation title: the list name. Back button.
2. Upcoming: one grouped section per day, with the header "Friday, 30 October". The rows show the time, not the day.
3. Anytime, Someday, Logbook: one grouped list of rows.

## Components

- The row is the list item row of [Project detail](project-detail.md#components). It shows the project name in the meta line.

## Navigation

- **Decided (2026-10-30):** a smart list row on Projects pushes this screen. The tab bar hides.

## Interactions

- **Assumption:** the check circle toggles a block or an Anytime task. A done item leaves Upcoming and Anytime and goes to the top of Logbook. A Logbook item that becomes open leaves Logbook.
- **Assumption:** Someday rows have no action in 1b.6.

## States

| List | Empty text |
| --- | --- |
| Upcoming | Nothing planned after today. |
| Anytime | No tasks without a day. |
| Someday | Nothing set aside for later. |
| Logbook | Done tasks show here. |

## Open questions

None.
