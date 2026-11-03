# Inbox review

Status: Planned
Screens: [Quick review](../screens/quick-review.md), [Inbox](../screens/inbox.md), [Plan hub](../screens/plan-my-day.md)

## Purpose

Help the user make small decisions about items that are stuck, about a minute at a time. Skipping changes nothing.

## Observed (v3)

Items that need a decision (prototype `REVIEW` list):
- An Inbox item moved 3 or more times ("Moved 3 times", "No date").
- An Inbox item that is due soon and not scheduled ("Due Friday", "Not scheduled").
- A capture item that is not organized ("Captured", "Not organized").
- An unfinished block that is not checked off ("Ended 8:50 AM", "Not checked off"), when "Include unfinished blocks" is on.

Actions for an Inbox item:

| Action | Effect | Toast |
| --- | --- | --- |
| Schedule | First free slot today (slot search, band order) | "Scheduled 2:30 PM" or "No free slot left today" |
| Keep for later | Next card. Nothing changes. | "Kept in Inbox" |
| Someday | Moves to Someday | "Moved to Someday" |
| Remind me | Sets a reminder (tomorrow 9:00 AM) | "Reminder set · Tomorrow 9:00 AM" |
| Archive | Removes it to the Logbook | "Archived · find it in Logbook" |
| Skip | Next card | none |

Actions for an unfinished block: Done ("Marked done"), Partly ("Kept the rest for planning"), Not started ("Kept for planning"), Skip for now (outcome `skipped`).

- The Inbox shows a review card when items need a decision. "Not now" hides it ("Okay. Nothing was moved.").
- The Plan hub shows a review row when items need a decision.
- Settings › Inbox review: Suggest a review "When I plan", Weekly reminder, Include unfinished blocks.

## Assumptions

- "Due soon" means due within 2 days. "Moved" counts each time the user moves an item back to the Inbox or skips it in a draft.
- "Remind me" waits for the notification to be scheduled before it says "set".

## Decisions

- **Decided (2026-11-03):** Quick review is in v1 scope.

## Related

[Inbox scheduling](inbox-scheduling.md), [Capture and organization](capture-and-organization.md), [Block completion](block-completion-and-routines.md).
