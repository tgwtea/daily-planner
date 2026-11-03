# Notifications

Status: Planned
Screens: [Settings group](../screens/settings-group.md), [Inbox](../screens/inbox.md), [Capture](../screens/capture.md)

## Purpose

Deliver reminders the user set, keep optional prompts quiet, and never claim a reminder is set before it is.

## Observed (v3)

Settings › Notifications:
- **Always delivered:** Task reminders (on), Calendar and fixed blocks (on). Footer: "Reminders you set are never silenced by Plan My Day. Delivery still depends on iOS and can occasionally be late."
- **Optional:** Daily plan summary (off), Inbox review reminder (off), Block start alerts (off). Footer: "Low-priority items come up inside the app instead."
- **Quiet hours:** on, From 11:00 PM, To 7:00 AM. The index row value is "Quiet at 11 PM".

Rules (handoff):
- Reminder copy says "set" only after scheduling the notification succeeds.
- Notification delivery and background refresh are best-effort. The UI says so.

## Assumptions

- Quiet hours silence optional notifications only. Reminders the user set are always delivered.
- Ask for notification permission the first time the user sets a reminder or turns on an optional notification (decided 2026-10-30 for alerts).
- If scheduling fails or permission is denied, the item keeps no reminder and a toast says "Couldn't set the reminder".

## Decisions

- **Decided (2026-10-30, kept):** block alerts are local notifications per block. Choices: None, At start, 5, 10, 15 min before.

## Related

[Capture and organization](capture-and-organization.md), [Inbox review](inbox-review.md), [Settings](settings-and-appearance.md).
