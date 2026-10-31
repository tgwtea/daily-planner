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

## Decisions

- **Decided (2026-10-30):** Suggestions come from on-device AI (Apple Foundation Models). Checkpoint 1c.4 writes an ADR for it before code. When the model is not available, the deterministic rule below is the fallback.
- **Decided (2026-10-30):** The rule proposes up to 3 Inbox items, oldest first. Each item goes into the first free gap that fits it.
- **Decided (2026-10-30):** When Suggestions is off in Settings, Today hides the Plan button. Implemented in 1b.5 (`TodayScreen`).
- **Decided (2026-10-30):** The sheet and the button keep the names "Plan my day" and "Plan".

## Related

[Inbox scheduling](inbox-scheduling.md).
