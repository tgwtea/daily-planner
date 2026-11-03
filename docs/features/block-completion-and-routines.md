# Block completion and routines

Status: Partial (no haptics yet: roadmap 2.4; v3 planned vs actual: 1d.1, 1d.4)
Code: `Luna/Shared/Model/Block.swift`, `Luna/Shared/Model/PlannerStore.swift`, `Luna/Features/Today/BlockRow.swift`
Screens: [Today](../screens/today.md), [Block detail](../screens/block-detail.md), [Plan hub](../screens/plan-my-day.md), [Quick review](../screens/quick-review.md), [End Focus sheet](../screens/end-focus-sheet.md)

## Purpose

Mark blocks done. Track steps inside a routine or a task checklist. Keep planned and actual apart: nothing is marked done because time passed or a session ended.

## Observed

- A task block has a `done` flag. Tap its check circle to toggle it.
- An event has no check circle and cannot be done.
- A routine is done when every step is done. Tap the routine's main check circle: if all steps are done, all become not done; otherwise all become done.
- On Today, a routine shows its steps inline with 18 pt check circles, a progress bar, and "N/M".
- A task (not a routine) can also have steps. Example: "Write migration plan" has 3 steps. On Today, only routines show steps inline. The task steps show in [Block detail](../screens/block-detail.md) and in the Focus checklist.
- Done appearance: the pill uses the done tint, the title is struck through in tertiary, the check circle is filled with the block color and an ink check.
- v2: Focus "Done" marks the focused block done. **Decided (2026-11-03):** v3 replaces it. Only "Mark done" on the End Focus sheet marks the block done.

Planned vs actual (v3, Observed):
- Open time and events have no check circle. Suggestions have none until approved.
- **Unconfirmed block:** a task or routine that is not done, not in Focus, has no outcome, and ends at or before now (or is on an earlier day). Its pill uses a 55% tint. Its check ring is dashed in `text-tertiary`. Its meta line says "Not checked off".
- **Outcome** (`outcome`): the answer for an unfinished block, from the Plan hub "From earlier" row or Quick review. Values: `partial` (meta "Partly done"; the Plan hub asks "About how much is left?" 10, 15, or 20 min), `notstarted`, `skipped`. An outcome removes the unconfirmed state. Toggling the check clears the outcome.
- **Focused time** (`focusedMin`): Focus records it when the session ends, whether or not the task is done. A done block with focused time shows "Focused 1 h 10 min" in its meta line in place of the planned duration.

## Assumptions

- A task with steps is not done automatically when all steps are done. Only routines use the all-steps rule.
- Completion is per day for a repeating block.
- Use `.sensoryFeedback(.success)` on completion when Haptics is on.
- `Block.kind` and `Block.repeatRule` are stored now. Quick add sets both (1c.1). Checkpoint 1c.3 lets the editor change the rule. The per-day step reset waits for 1c.3.
- Icons are SF Symbol names stored as strings, because the "More" icon picker offers about 60 symbols.

## Decisions

- **Decided (2026-10-30):** A routine is a block with a Repeat rule other than Never. Its steps reset each day. A block with steps and no Repeat rule is a task with a checklist. The editor needs no separate switch.
- **Decided (2026-10-30):** Done blocks show in the Logbook smart list, newest first. They also stay on their day. See [Projects and areas](projects-and-areas.md#decisions).

## Edge cases

- A routine with zero steps. **Assumption:** treat it as a task.

## Related

[Timeline](timeline-and-day-bands.md), [Block editing](block-editing.md), [Focus](focus-and-live-activity.md).
