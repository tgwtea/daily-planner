# Block completion and routines

Status: Planned
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

## Unresolved

- What makes a block a routine and not a task with a checklist? The editor has no switch. See [open-questions.md](../open-questions.md#editing).
- Do done blocks move to a Logbook? The Projects tab has a Logbook list.

## Edge cases

- A routine with zero steps. **Assumption:** treat it as a task.

## Related

[Timeline](timeline-and-day-bands.md), [Block editing](block-editing.md), [Focus](focus-and-live-activity.md).
