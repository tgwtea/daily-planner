# End Focus sheet

Status: Planned
Artboards: 3z
Features: [Focus and Live Activity](../features/focus-and-live-activity.md), [Block completion and routines](../features/block-completion-and-routines.md)

## Purpose

End a session without assuming the task is done.

## Layout

A glass sheet: "Build SwiftUI timeline · 1 h 10 min focused", the title "Is the task done?", the body "Ending a session records your time. It doesn't check off the task unless you say so.", and three buttons: "Mark done" (primary), "Not yet, keep it open" (secondary), "Back to focus" (ghost).

## Interactions

- "Mark done": the block is done, its focused time is recorded, Focus closes. Toast "Done · time recorded".
- "Not yet, keep it open": the focused time is recorded, the block stays open, Focus closes. Toast "Kept open. It'll come up when you plan."
- "Back to focus" closes the sheet.

## Open questions

None.
