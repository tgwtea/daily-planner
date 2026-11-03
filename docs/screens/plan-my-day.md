# Plan hub

Status: Planned
Artboards: 3k, 3p (and 3l, 3m for the draft it creates)
Features: [Plan hub suggestions](../features/plan-my-day-suggestions.md), [Block completion and routines](../features/block-completion-and-routines.md), [Inbox review](../features/inbox-review.md)

## Purpose

One sheet to plan the rest of today or tomorrow: follow up on unfinished work, give an optional energy level, start an optional review, then ask for a draft. Nothing changes until you approve the draft.

## Layout (top to bottom)

A glass sheet:

1. Grabber. A small label "Plan" (sparkles). Title "Plan the rest of today" or "Prepare Friday" (the next day's name).
2. Segmented control: "Rest of today", "Tomorrow".
3. **AI unavailable card** (3p): wifi-off, "Suggestions need a connection", "Planning by hand works as usual. Drag from Inbox, or tap + on any band." **Decided (2026-11-03):** AI is on-device only, so this state means the on-device model is not available or AI planning is off. **Assumption:** the copy says "Suggestions aren't available right now" in place of "need a connection".
4. **From earlier** (today only, when an unconfirmed block exists, 3k): the block (icon, "Review lecture notes", "8:30 – 8:50 · not checked off") and four capsules: Done, Partly, Not started, Skip. After "Partly": "About how much is left?" with 10, 15, 20 min. A note: "The rest will be included in the draft." or "It'll be included in the draft."
5. **Energy right now · optional** (when the "Ask when I plan" setting is on): Focused (zap), Steady (minus), Foggy (cloud-fog). A second tap clears the choice.
6. **Review row** (when items need a decision): inbox icon, "4 items could use a decision", "About a minute. Skipping changes nothing.", a chevron, and an x to dismiss.
7. A line that says what Plan considered, for example "Keeps 2 events, Office hours and your protected time as they are. Looks at 4 Inbox tasks, due dates, 15-min buffers and fewer switches between unrelated work." For tomorrow it also says a draft is prepared at 9:00 PM.
8. A primary "Draft the rest of today" (or "Draft Friday") with sparkles, when AI is available. A "Plan by hand" button (primary when AI is not available, ghost otherwise) that opens the [Inbox drawer](inbox-drawer.md).

## Navigation

- Opened by "Plan" in the [Today](today.md) header. A scrim tap closes it.
- The review row opens [Quick review](quick-review.md).
- "Draft …" closes the sheet, shows the target day on Today, and scrolls to the first suggestion.

## Interactions

- Done marks the block done (toast "Marked done"). Skip keeps it in history (toast "Kept in history"). Partly and Not started feed the draft.
- See [Plan hub suggestions](../features/plan-my-day-suggestions.md) for the draft rules.

## Accessibility and iOS notes

- `.sheet` with medium and large detents. Each choice group is a set of toggle buttons with a selected trait.

## Open questions

None. The decisions are in [Plan hub suggestions](../features/plan-my-day-suggestions.md#decisions).
