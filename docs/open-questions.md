# Open questions

Each item is a decision that the mockup does not make. Resolve each one with the user before you implement the related behavior. When it is resolved, record the answer as **Decided** in the feature spec (or in an ADR for a technical decision) and remove it here.

The user resolved the first set of questions on 2026-10-30, and the v3 scope questions on 2026-11-03. Each spec records those answers in its **Decisions** section. The items below are still open. Each one was checked against the v3 mockup on 2026-11-03.

Priority: **P1** blocks the first related implementation. **P2** can wait for a later pass.

## Capture

- **P2.** What happens to an Anytime task that is not done at the end of the day? Roll it to the next day, or keep it on its day? See [Anytime tasks](features/anytime-tasks.md).

## Inbox

- **P2.** Can a user schedule an Inbox item into a day other than today by hand? v3 answers it only for drafts: a Plan draft for tomorrow, and "Move to Friday" on a conflict. See [Inbox scheduling](features/inbox-scheduling.md).

## Editing

- **P2.** Can a user duplicate a block? See [Block editing](features/block-editing.md).

## Habits

- **P2.** A tap at the goal resets the count to zero. Is this intended, or does a separate undo exist? v3 keeps the same rule. See [Habits](features/habits.md).

## Planning (v3)

- **P2.** How does the user create and edit a recurring Open time pattern ("Add protected time")? v3 shows the list only. See [Block types](features/block-types.md). Needed by 1d.10.
- **P2.** What does "Learn from approved plans" learn, and where is it stored on device? v3 shows the switch and "Clear learned patterns" only. See [Settings and appearance](features/settings-and-appearance.md#v3-settings-groups). Needed by 1c.4.
- **P2.** How do the Energy "Usually" preferences (Most focused, Lower energy) change a draft? See [Plan hub suggestions](features/plan-my-day-suggestions.md). Needed by 1c.4.
- **P2.** "Remind me" in Quick review sets tomorrow 9:00 AM. Can the user pick the time? See [Inbox review](features/inbox-review.md). Needed by 1d.6.

## Data (v3)

- **P2.** What format does "Export data" write? See [Settings and appearance](features/settings-and-appearance.md#v3-settings-groups). Needed by 2.1.

