# Habit editor

Status: Implemented
Code: `Luna/Features/Habits/HabitEditorSheet.swift`, `WeekdayPicker.swift`, `Luna/Shared/Model/HabitDraft.swift`
v3: No artboard. The v2 spec stays valid (decided 2026-11-03).
Artboards: none
Features: [Habits](../features/habits.md)

## Purpose

Add a habit, or change the name, detail, icon, color, goal, and days of a habit.

## Layout (top to bottom)

1. Inline title "New Habit" or "Edit Habit". Cancel and Save in the toolbar.
2. Name and Detail text fields. The detail placeholder is "Detail, for example 20 minutes".
3. Icon: a grid of 12 SF Symbols, 4 per row (`IconChoiceGrid`). The first five are the sample habit icons.
4. Color: the five block colors (`ColorChoiceRow`).
5. Goal: a stepper, "8 a day", 1 to 99.
6. Days: seven round toggles, M to S (`WeekdayPicker`). The footer names the schedule, for example "Mon, Wed, Fri. Other days do not break the streak."

## Navigation

- **Assumption:** a large sheet. The Habits header "+" and the empty state open it empty. Edit (swipe or menu) opens it with the habit.

## Interactions

- Save writes the draft. Cancel discards it. The history does not change.
- Save is off when the name is empty or no day is on.
- A new habit has the first icon, Slate, goal 1, and every day on. The name field gets focus.

## Accessibility and iOS notes

- Each day toggle has the full day name as its label and the selected trait.
- Each icon and color has a name label and the selected trait.

## Open questions

None.
