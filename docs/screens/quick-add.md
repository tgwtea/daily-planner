# Quick add

Status: Implemented
Code: `Luna/Features/QuickAdd/QuickAddSheet.swift`, `QuickAddChipRow.swift`, `QuickAddChip.swift`
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
- **Assumption:** a chip opens its tool: Day opens Date. Time, band, Inbox, and Anytime open Time. Duration opens Duration. The checklist chip opens Checklist. The repeat chip cycles the rule.
- **Assumption:** with a pre-fill or a picker value, the chips show a day other than today or tomorrow as a short date ("Fri, Nov 6"). A no-time item with a day shows "Anytime" in place of "Inbox".
- **Assumption:** one tool panel is open at a time, below the tool row. Duration choices: 15, 30, 45 min, 1 h, 1 h 30 min, 2 h.
- **Assumption:** a step typed in the Checklist field and not yet submitted is saved with the block.

## Accessibility and iOS notes

- `.sheet` with `presentationDetents([.height(…)])` from the measured content height, and `@FocusState` to show the keyboard at once. The system draws the glass sheet background.
- Each chip is a button with a label ("Color, Rose"). Tools have labels; Icon and Repeat also have values.
- Natural-language parsing is English only in the mockup.

## Artboard comparison (2026-10-31)

Checked in the iPhone 17 simulator, dark and light, against the 2g markup with the sample text. Pill, field, chips, tool row, and Add button match. Intended differences:
- The iOS 26 system sheet floats with side margins and a small gap above the keyboard. The mockup sheet is full width and touches its fake keyboard.
- The chips keep a 44 pt hit area, so the chip rows are further apart than the mockup's 6 pt gap.
- The time chip uses the device time format ("9:00 AM" in en_US).

## Open questions

None.

- **Decided (2026-10-30):** the Date and Time tools open a compact `DatePicker`. Duration opens a chip row. Repeat opens a `Menu`. Checklist opens an inline step field. The text and the chips stay in sync.
- The parsing and pre-fill decisions are in [Quick add parsing](../features/quick-add-parsing.md#decisions).
