# Plan hub suggestions

Status: Planned
Screens: [Plan hub](../screens/plan-my-day.md), [Today](../screens/today.md), [Block detail](../screens/block-detail.md), [Settings group](../screens/settings-group.md)

The file name keeps "plan-my-day" so that links stay stable.

## Purpose

Draft a plan for the rest of today or for tomorrow. Show the draft on the timeline with reasons. The user approves, edits, skips, or keeps the original. AI output is always a draft.

## Observed (v3)

Plan hub inputs:
- Target: "Rest of today" or "Tomorrow".
- Unfinished work ("From earlier"): Done, Partly (with 10, 15, or 20 min left), Not started, Skip.
- Energy (optional): Focused, Steady, Foggy. Shown when "Ask when I plan" is on. Never inferred.
- An optional Quick review.

Draft contents (for a day):
- **New** suggestions from Inbox items, each with a start, a duration, and a reason ("Right before office hours. Same course, so one fewer switch.").
- **Move** suggestions for existing flexible blocks ("Move 9:00 → 9:15", "Adds a 15-min buffer after dinner.").
- **Conflict** suggestions that overlap another block ("Overlaps Unwind by 15 min"). Actions: "Shorten to 1 h", "Move to Friday", Skip.
- **Doesn't fit** items with the reason, for example "The shop closes at 6 PM and your afternoon is full. It stays in Inbox."
- Unfinished work: Partly adds a block for what is left ("What was left this morning. Fits before office hours."). Not started adds a "Doesn't fit" line when no gap is left, with a suggestion for tomorrow.
- Energy changes the draft: Foggy shortens a demanding block; Focused keeps the longest stretch for it.
- Regenerate makes a new variant ("Thinking…" while it runs).

Rules:
- Nothing changes until approval. Events, Fixed blocks, and Open time stay where they are. Manually placed blocks are never moved without approval.
- A conflicting suggestion cannot be bulk-approved. "Approve N" applies moves and new suggestions that are not skipped and have no conflict. A conflict must be resolved first (shorten, move, or skip).
- Approve removes the approved items from the Inbox. Toast "3 changes applied" or "Nothing changed".
- "Keep original" removes all suggestions and moves blocks back. Toast "Kept your original plan".
- The approval bar shows "N changes ready" and "1 needs a decision · 3 h 20 min free after" (free time from now, or 7:00 AM, to 11:30 PM, after the draft).
- Tomorrow: "A draft is also prepared at 9:00 PM tonight, ready when you wake up" (setting "Prepare tomorrow's draft").
- AI unavailable or AI planning off: no draft button. "Plan by hand" opens the Inbox drawer.
- The considered line names what Plan keeps and looks at: events, Fixed blocks, Open time, Inbox tasks, due dates, 15-min buffers, fewer switches between unrelated work.

## Assumptions

- The draft is a value type separate from the store. Approve applies it in one store intent. Unit tests cover approve, skip, keep original, and conflicts.
- A suggestion is a block with a `suggestion` state (new, move with the original start, conflict) and a reason. It never counts as done or unconfirmed.

## Decisions

- **Decided (2026-11-03):** AI is on-device only (Apple Foundation Models). Checkpoint 1c.4 writes the ADR before code. When the model is not available, the deterministic rule below makes a draft, or the hub offers "Plan by hand" only.
- **Decided (2026-11-03):** the v3 Plan hub and inline drafts replace the v2 suggestion sheet ("Plan my day", up to 3 proposals with checkboxes).
- **Decided (2026-10-30, kept as the fallback):** the deterministic rule proposes up to 3 Inbox items, oldest first. Each item goes into the first free gap that fits it.
- **Decided (2026-11-03):** the Plan button always shows. With "Planning suggestions" off, the hub shows no draft button and "Plan by hand" is the primary action. This replaces the 2026-10-30 rule "When Suggestions is off, Today hides the Plan button" (implemented in 1b.5 in `TodayScreen`; checkpoint 1c.4 changes it).
- **Decided (2026-10-30):** the button keeps the name "Plan".

## Related

[Inbox scheduling](inbox-scheduling.md), [Block types](block-types.md), [Running-late nudge](running-late-nudge.md), [Inbox review](inbox-review.md).
