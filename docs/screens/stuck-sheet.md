# I'm stuck sheet

Status: Planned
Artboards: 3x
Features: [Focus and Live Activity](../features/focus-and-live-activity.md#im-stuck)

## Purpose

Reorient the user when Focus stalls: where they are, what is done, and one small step.

## Layout (top to bottom)

A glass sheet:

1. Title "Here's where you are".
2. "Working on": the block title, and "Plan My Day app · 20 min in" (project and focused minutes).
3. "So far": done steps ("Week strip layout — done") and the block or project note.
4. "One small step": one sentence, for example "Open TimelineView.swift and make one row draggable." A "Make it smaller" button gives a smaller step.
5. A primary "Back to focus" and a secondary "Pause and step away".

## Interactions

- "Pause and step away" closes the sheet, pauses Focus, and shows the toast "Paused. Come back whenever you're ready."
- The small step comes from the on-device model. **Assumption:** without the model, the step is the first open checklist step, and "Make it smaller" hides.

## Open questions

None.
