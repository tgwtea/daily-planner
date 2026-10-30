# Open questions

Each item is a decision that the mockup does not make. Resolve each one with the user before you implement the related behavior. When it is resolved, record the answer as **Decided** in the feature spec (or in an ADR for a technical decision) and remove it here.

The user resolved the first set of questions on 2026-10-30. Each spec records those answers in its **Decisions** section. The items below came from the spec **Unresolved** sections and are still open.

Priority: **P1** blocks the first related implementation. **P2** can wait for a later pass.

## Capture

- **P2.** What happens to an Anytime task that is not done at the end of the day? Roll it to the next day, or keep it on its day? See [Anytime tasks](features/anytime-tasks.md).

## Inbox

- **P2.** Can a user schedule an Inbox item into a day other than today? See [Inbox scheduling](features/inbox-scheduling.md).

## Editing

- **P2.** Can a user duplicate a block? See [Block editing](features/block-editing.md).

## Habits

- **P2.** A tap at the goal resets the count to zero. Is this intended, or does a separate undo exist? See [Habits](features/habits.md).

## Settings

- **P2.** Can band starts overlap or leave gaps? Which order rules apply to the three pickers? See [Settings and appearance](features/settings-and-appearance.md).
