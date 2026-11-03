# Running-late nudge

Status: Planned
Screens: [Today](../screens/today.md), [Before and after](../screens/before-after.md)

## Purpose

When the active work runs past its block, offer one gentle adjustment of the flexible blocks after it.

## Observed (v3, 3n and 3o)

- Trigger: the focused or active block is past its end (the sample is 35 min past). Setting "Suggest changes when running late" is on.
- The nudge shows in the bottom accessory (role status): hourglass, "Build SwiftUI timeline is 35 min past its block", "Move Lunch to 12:30 and Study to 1:30? Office hours stays at 3:00.", with "Not now" and "Preview".
- "Not now" hides it for that block. Toast "Okay. I won't ask again for this block."
- "Preview" opens Before and after. "Move 2 blocks" applies the moves.
- Only Flexible blocks move. Fixed blocks, events, and Open time stay. The preview says so per row.
- While Focus runs and the block overruns, the nudge takes the accessory slot in place of the Focus mini-player.

## Rules

- At most once per block (Settings › Scheduling: "At most: Once per block").
- Never moves anything without approval.

## Assumptions

- The nudge appears when the overrun reaches 15 min.
- The proposal shifts the next flexible blocks by the overrun rounded up to 15 min, keeps the transition buffer, and stops at the next Fixed block, event, or Open time. A deterministic rule; no AI needed.

## Related

[Plan hub suggestions](plan-my-day-suggestions.md), [Block types](block-types.md), [Focus](focus-and-live-activity.md).
