# Block completion and routines

Status: Partial (no haptics yet: roadmap 2.4)
Code: `Luna/Shared/Model/Block.swift`, `Luna/Shared/Model/PlannerStore.swift`, `Luna/Features/Today/BlockRow.swift`
Screens: [Today](../screens/today.md), [Edit block](../screens/edit-block.md)

## Purpose

Mark blocks done. Track steps inside a routine or a task checklist.

## Observed

- A task block has a `done` flag. Tap its check circle to toggle it.
- An event has no check circle and cannot be done.
- A routine is done when every step is done. Tap the routine's main check circle: if all steps are done, all become not done; otherwise all become done.
- On Today, a routine shows its steps inline with 18 pt check circles, a progress bar, and "N/M".
- A task (not a routine) can also have steps. Example: "Write migration plan" has 3 steps. On Today, only routines show steps inline. The task steps show in [Edit block](../screens/edit-block.md).
- Done appearance: the pill uses the done tint, the title is struck through in tertiary, the check circle is filled with the block color and an ink check.
- Focus "Done" marks the focused block done.

## Assumptions

- A task with steps is not done automatically when all steps are done. Only routines use the all-steps rule.
- Completion is per day for a repeating block.
- Use `.sensoryFeedback(.success)` on completion when Haptics is on.
- `Block.kind` is stored now. When Repeat support arrives (checkpoint 1c.3), the editor sets `routine` from the Repeat rule. The per-day step reset waits for Repeat support.
- Icons are SF Symbol names stored as strings, because the "More" icon picker offers about 60 symbols.

## Decisions

- **Decided (2026-10-30):** A routine is a block with a Repeat rule other than Never. Its steps reset each day. A block with steps and no Repeat rule is a task with a checklist. The editor needs no separate switch.
- **Decided (2026-10-30):** Done blocks show in the Logbook smart list, newest first. They also stay on their day. See [Projects and areas](projects-and-areas.md#decisions).

## Edge cases

- A routine with zero steps. **Assumption:** treat it as a task.

## Related

[Timeline](timeline-and-day-bands.md), [Block editing](block-editing.md), [Focus](focus-and-live-activity.md).
