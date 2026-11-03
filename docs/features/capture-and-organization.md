# Capture and organization

Status: Planned
Screens: [Capture](../screens/capture.md), [Inbox](../screens/inbox.md), [Quick review](../screens/quick-review.md)

## Purpose

Save first, organize after. A capture never waits for AI, and it never loses the text as written.

## Observed (v3)

- Capture writes the item locally before any AI call. It works offline.
- A capture item keeps the raw text. Its organization state:

| State | Status line | Icon |
| --- | --- | --- |
| `organizing` | Saved · organizing… | loader |
| `ready` | Saved · N suggestions | sparkles |
| `offline` | Saved · suggestions when you're online | wifi-off |
| `failed` | Saved as written · couldn't organize | circle-alert |

- Suggestion fields: Title (the raw text without "remember to", "remind me to", "need to", first letter capitalized), When (Today, Tomorrow, "Before Saturday", "Someday"), Reminder ("Fri · 6:00 PM"), List or Project, Estimate ("15 min", "1 h").
- Each field is opt-in. It starts checked. The user unchecks a field to leave it out. A Reminder field notes "Set when you apply" or "Won't be set".
- Apply turns the capture into a normal Inbox item with the checked fields. Toast "Organized", or "Organized · reminder set for Fri 6:00 PM" when a reminder was set.
- "Keep as written" turns it into a normal Inbox item with the raw text as the title and no other fields. Toast "Kept as written".
- With "Organize captures" off or AI not available, the state is `offline` and stays so.

## Assumptions

- The organization runs on the on-device model (decided 2026-11-03). "offline" means the model is not available. **Assumption:** the status copy says "Saved · suggestions when available".
- A deterministic fallback fills Title and When from the parser. It does not guess a List or an Estimate.
- The reminder is described as set only after the local notification is scheduled. See [Notifications](notifications.md).

## Decisions

- **Decided (2026-11-03):** text with no time becomes a capture item. See [Capture parsing](quick-add-parsing.md#decisions).
- **Decided (2026-11-03):** the "Organize captures" switch is in v1 scope.

## Edge cases

- The app quits while organizing: on the next launch the item is still saved as written, in state `organizing` or `failed`.
- An empty suggestion set: the state is `failed`.

## Related

[Inbox scheduling](inbox-scheduling.md), [Inbox review](inbox-review.md).
