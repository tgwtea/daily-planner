# Inbox

Status: Planned
Artboards: 2k
Features: [Inbox scheduling](../features/inbox-scheduling.md), [Quick add](../features/quick-add-parsing.md)

## Purpose

Hold tasks that have no time yet. You place each task into a band of today.

## Layout (top to bottom)

1. Title "Inbox" (34 pt bold). Subtitle "5 to schedule", or "All scheduled" when empty.
2. A 50 pt capsule button "+ Add to Inbox" (placeholder style, tertiary text).
3. A grouped list. Each row: a 40 pt colored icon tile (radius 14), a title (17 pt semibold, one line), a meta line "15 min · Health" (duration · tag), and a grip icon.
4. A footnote: "Swipe left to place a task in Morning, Afternoon or Night. On Today, drag it from the Inbox drawer to an exact time."

## Navigation

- "Add to Inbox" opens [Quick add](quick-add.md).
- Tab bar and "+" button show.

## Interactions

- **Observed:** swipe a row left by 168 pt. Three 46 pt round buttons show: sunrise, sun, moon ("Place in Morning", "Place in Afternoon", "Place in Night").
- **Observed:** tap a place button. The task moves to the first free slot in that band of today and leaves the Inbox.
- **Observed:** if the band has no free slot, nothing happens. **Unresolved:** what feedback to show. See [open-questions.md](../open-questions.md#inbox).
- In the mockup a tap on a row toggles the swipe. **Assumption:** use the native swipe gesture. A tap on a row opens nothing.

## States

| State | Behavior |
| --- | --- |
| Items | List as above. |
| Empty | Inside the list card: 44 pt inbox icon, "Inbox is clear", "Everything has a place in your day." |

## Accessibility and iOS notes

- Use `List` with `.swipeActions(edge: .trailing)`. Give each action a label ("Place in Morning").
- Swipe actions are not discoverable. Add the three actions to the row's context menu and accessibility actions.

## Open questions

- Can you reorder rows with the grip? The grip icon suggests it. The mockup has no reorder.
- Can you edit or delete an Inbox task? Not shown.
- Where do tags ("Health", "Lisbon trip") come from? They match project names. See [open-questions.md](../open-questions.md#inbox).
