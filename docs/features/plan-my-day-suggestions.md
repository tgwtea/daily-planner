# Plan my day suggestions

Status: Planned
Screens: [Plan my day](../screens/plan-my-day.md), [Settings](../screens/settings.md)

## Purpose

Propose times for Inbox tasks in today's free time. The user confirms each one.

## Observed

- The mockup takes the first three Inbox tasks in Inbox order.
- For each one, it runs the drawer slot search (first free slot of today, Morning then Afternoon then Night). Each proposal counts as busy for the next one.
- A task with no slot is left out.
- All proposals start selected. The button counts the selected ones.
- Accept adds the selected ones as task blocks and removes them from the Inbox.
- The Settings switch "Suggestions" exists. Its footer: "When on, Plan suggests times for Inbox tasks. Nothing is scheduled until you add it."

## Assumptions

- The suggestion logic is deterministic and on-device. It reuses the slot search from [Inbox scheduling](inbox-scheduling.md).
- Proposal meta: "10:30 – 10:45 AM · Morning".

## Unresolved

- Is this a deterministic rule or an AI feature? The label says "Suggestion" only. Do not add AI without a product decision and an ADR. See [open-questions.md](../open-questions.md#plan-my-day).
- Why three tasks? Should it rank by duration, tag, or age?
- What does the Plan button do when Suggestions is off: hide, or disable?

## Related

[Inbox scheduling](inbox-scheduling.md).
