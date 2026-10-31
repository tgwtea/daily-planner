# Archived habits

Status: Implemented
Code: `Luna/Features/Habits/ArchivedHabitsScreen.swift`
Artboards: none
Features: [Habits](../features/habits.md)

## Purpose

Show the archived habits. Restore a habit, or delete it for good.

## Layout (top to bottom)

1. Large navigation title "Archived". Back button.
2. One grouped list: icon tile, name, and schedule (for example "Every day").
3. Footer: "Swipe right to restore a habit. Swipe left to delete it and its history."

## Navigation

- **Decided (2026-10-31):** the "Archived" row at the bottom of the Habits tab pushes this screen. The tab bar hides.

## Interactions

- **Decided (2026-10-31):** swipe right to restore. The habit goes to the end of the habit list with its history.
- **Decided (2026-10-31):** swipe left to delete. A confirmation "Delete <name>?" says that this deletes the history and cannot be undone.

## States

- Empty: "Habits you archive show here."

## Accessibility and iOS notes

- Each row has the accessibility actions "Restore" and "Delete".

## Open questions

None.
