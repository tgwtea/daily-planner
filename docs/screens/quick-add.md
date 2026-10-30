# Quick add

Status: Planned
Artboards: 2g
Features: [Quick add parsing](../features/quick-add-parsing.md)

## Purpose

Capture a block or an Inbox task in one line of plain language.

## Layout (top to bottom)

A glass sheet above the keyboard:

1. A 36 × 48 pt pill in the chosen color with the chosen icon. A text field (19 pt medium), placeholder "Gym tomorrow 7am 45m".
2. **Parsed chips** (30 pt capsules on `surface-hover`), built live from the text:
   - Day: "Today" or "Tomorrow" (calendar icon), if the text has a day word.
   - Time and band: "9:00 AM" (clock) and "Morning" (band icon), if the text has a time. Without a time: "Inbox" (inbox icon).
   - Duration: "15 min" (timer), if the text has a duration.
   - Color: a 10 pt dot and the color name. Tap it to cycle to the next color.
3. **Tool row:** Date, Time, Duration, Icon, Repeat, Checklist (40 pt round buttons). A primary 40 pt "Add" button with an up arrow on the trailing side.
4. The keyboard. The mockup draws a fake keyboard. Use the system keyboard.

Sample text in 2g: "Call the dentist tomorrow 9am 15m" with Rose and phone.

## Navigation

- Opened by any "+" button: the tab bar "+", band "+", Anytime "+", empty-day "Add block", Inbox "Add to Inbox".
- The tab bar hides while the sheet is open.
- Tap the scrim to close.

## Interactions

- Return or "Add" saves. See [Quick add parsing](../features/quick-add-parsing.md) for where the item goes.
- **Observed:** the Icon tool cycles through the 12 picker icons. Date, Time, Duration, Repeat, and Checklist have no action.
- An empty title closes the sheet and saves nothing.

## Accessibility and iOS notes

- Use `.sheet` with a height that fits the content (`presentationDetents` with a custom height) and `@FocusState` to show the keyboard at once.
- Each chip is a button with a label ("Color, Rose").
- Natural-language parsing is English only in the mockup.

## Open questions

None.

- **Decided (2026-10-30):** the Date and Time tools open a compact `DatePicker`. Duration opens a chip row. Repeat opens a `Menu`. Checklist opens an inline step field. The text and the chips stay in sync.
- The parsing and pre-fill decisions are in [Quick add parsing](../features/quick-add-parsing.md#decisions).
