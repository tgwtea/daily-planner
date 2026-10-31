# Inbox

Status: Implemented
Code: `Luna/Features/Inbox/` (`InboxScreen`, `InboxRow`, `InboxEmptyView`)
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
- **Observed:** if the band has no free slot, nothing happens. **Decided (2026-10-30):** an inline message "No free time in <Band>" and a warning haptic. See [Inbox scheduling](../features/inbox-scheduling.md#decisions).
- In the mockup a tap on a row toggles the swipe. **Decided (2026-10-30):** a tap on a row edits its title. See [Open questions](#open-questions).
- **Assumption:** a leading swipe (to the right) shows the three place buttons, as decided. The footnote says "Swipe right" instead of the mockup's "Swipe left".
- **Assumption:** a trailing swipe shows Delete. Delete has no confirmation.
- **Assumption:** the title edit is an alert with a text field, Save, and Cancel. An empty title does not change the item.
- **Assumption:** a long press opens a context menu: the three place actions, Edit title, and Delete. Drag the row (long press, then move) to reorder. The grip is decoration.
- **Assumption:** the place buttons use the native iOS 26 round swipe buttons with the `swipeActionTint` color. The system draws the icon white, so light appearance uses a dark neutral, not white `surface-raised`.
- **Assumption:** the message "No free time in <Band>" shows above the footnote for 2.5 s. VoiceOver announces it.
- **Assumption:** the meta line shows the project name as the tag. An item with no project shows the duration only.
- **Decided (2026-10-31):** an item with a project has "Open <Project>" in its context menu and as a VoiceOver action. It pushes [Project detail](project-detail.md) on the Inbox tab. The tag text is not a button.

## States

| State | Behavior |
| --- | --- |
| Items | List as above. |
| Empty | Inside the list card: 44 pt inbox icon, "Inbox is clear", "Everything has a place in your day." |

## Accessibility and iOS notes

- Use `List` with `.swipeActions(edge: .leading)` for the place actions and `.swipeActions(edge: .trailing)` for Delete. Each action has a label ("Place in Morning").
- Swipe actions are not discoverable. The context menu has the same actions. VoiceOver lists the swipe actions as custom actions. The row is a button with the hint "Edit title".
- The row uses a tap gesture, not a `Button`. A `List` row with a button fires it when a swipe ends without opening the actions.

## Artboard comparison (2026-10-31)

Checked in the iPhone 17 simulator (iOS 27.0), dark and light, against the markup of artboard 2k (row 2 swiped open). Header, add button, gaps (20 pt), rows, full-width dividers, footnote, and empty state match. Intended differences:

| Item | Mockup | App | Why |
| --- | --- | --- | --- |
| Swipe direction | Swipe left | Swipe right for place, swipe left for Delete | Decided 2026-10-30 |
| Place buttons in light | White `surface-raised`, dark icon | Dark neutral, white icon | The system draws swipe icons white |
| "Draft Q4 self-review" tag | "Work" | "Q4 planning" | A tag is a project. "Work" is an area. |
| "Order a new chalk bag" tag | "Personal" | No tag | The sample item has no project. |
| Subtitle | 15 pt regular, 4 pt below the title | 15 pt medium, 2 pt below | Shared `LargeTitleHeader`. Check in 3.3. |
| Tile icon | 18 pt | 20 pt (half the tile) | Shared `IconTile`. Check in 3.3. |
| Grip | Lucide `grip-vertical` | SF `line.3.horizontal` | The iOS reorder symbol |
| Card corner | 20 pt | The `List` inset-grouped radius | Native `List` for swipe and reorder |
| Dividers | Full width | Full width at the leading edge, 16 pt short at the trailing edge | Native `List` separator |

## Open questions

- **Decided (2026-10-30):** drag the grip to reorder. Tap a row to edit its title. A trailing swipe deletes. A leading swipe places the item in a band.
- **Decided (2026-10-30):** a tag is a project. See [Inbox scheduling](../features/inbox-scheduling.md#decisions).
