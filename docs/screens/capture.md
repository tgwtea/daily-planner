# Capture

Status: Partial (built on v2 as Quick add in 1c.1; the v3 gaps are listed below)
Code: `Luna/Features/QuickAdd/QuickAddSheet.swift`, `QuickAddChipRow.swift`, `QuickAddChip.swift` (rename in 1d.5)
Artboards: 3q
Features: [Capture parsing](../features/quick-add-parsing.md), [Capture and organization](../features/capture-and-organization.md)

**Decided (2026-11-03):** this sheet is "Capture". It replaces the term "Quick add". The old spec is [quick-add.md](quick-add.md) (deprecated).

## Purpose

Save a thought at once, as written. Text with a time becomes a block. Everything else goes to the Inbox and gets organized later, or never.

## Layout (top to bottom)

A glass sheet above the keyboard:

1. A 36 × 48 pt pill in the chosen color with the chosen icon. A text field (19 pt medium), placeholder "Capture anything".
2. **Detected** label and chips (dashed outline, built live from the text): day ("Today", "Tomorrow"), time ("7:00 AM") and band ("Morning"), duration ("45 min"), and the color (dot and name; a tap cycles it). The color chip shows only when another chip shows.
3. A hint line: "Saves to Inbox as written. Add a time to put it on Today." Offline: "Offline. It still saves right away, as written."
4. **Tool row:** Dictate (mic), Date, Time, Duration, Reminder (bell), Icon (shapes). A primary round send button with an up arrow.
5. The system keyboard. The mockup draws a fake keyboard.

Sample text in 3q: "gym tmrw 7am 45m".

## Navigation

- Opened by the Capture circle next to the tab bar, the Inbox capture field, band "+", Anytime "+", "Add block", and "Capture" on first run.
- The tab bar hides while the sheet is open. A scrim tap closes it.

## Interactions

- Return or send saves. An empty text closes the sheet and saves nothing.
- With a time: a block on that day (today if none) at that time, 30 min if no duration. Toast "Added to Today · 7:00 AM". Today shows that day.
- **Decided (2026-11-03):** with no time: a capture item at the top of the Inbox with the raw text. Toast "Saved to Inbox". A day word becomes a suggested "When" field. This replaces the 2026-10-30 rule that sent a no-time item with a day word to Anytime.
- The capture is written locally before any AI call. With AI off or unavailable, it keeps the "offline" status. See [Capture and organization](../features/capture-and-organization.md).
- **Observed:** the Icon tool cycles through the 12 picker icons. Dictate, Date, Time, Duration, and Reminder have no action in the mockup.
- **Assumption (1c.1, kept):** the tools open inline native pickers. Dictate uses the Speech framework (roadmap 2.5).
- **Assumption:** a chip opens its tool: Day opens Date. Time, band, Inbox, and Anytime open Time. Duration opens Duration. The checklist chip opens Checklist. The repeat chip cycles the rule.
- **Assumption:** with a pre-fill or a picker value, the chips show a day other than today or tomorrow as a short date ("Fri, Nov 6"). A no-time item with a day shows "Anytime" in place of "Inbox".
- **Assumption:** one tool panel is open at a time, below the tool row. Duration choices: 15, 30, 45 min, 1 h, 1 h 30 min, 2 h.
- **Assumption:** a step typed in the Checklist field and not yet submitted is saved with the block.

## Accessibility and iOS notes

- `.sheet` with a measured height detent and `@FocusState` to show the keyboard at once.
- Each chip is a button with a label ("Color, Rose"). Each tool has a label.
- Parsing is English only.

## v3 gaps (code built in 1c.1 as Quick add)

- Title, placeholder, hint line, "Detected" label and dashed chips (1d.5).
- Save rule: no time goes to the Inbox as a capture item (1d.5). Pre-fill from the Anytime "+" still targets Anytime.
- Tool row: Dictate and Reminder replace Repeat and Checklist (1d.5, Dictate in 2.5).
- Rename the `QuickAdd*` types to `Capture*` (1d.5).

## Artboard comparison (2026-10-31, v2 Quick add)

Checked in the iPhone 17 simulator, dark and light, against the 2g markup with the sample text. Pill, field, chips, tool row, and Add button match. Intended differences:
- The iOS 26 system sheet floats with side margins and a small gap above the keyboard. The mockup sheet is full width and touches its fake keyboard.
- The chips keep a 44 pt hit area, so the chip rows are further apart than the mockup's 6 pt gap.
- The time chip uses the device time format ("9:00 AM" in en_US).

## Decisions

- **Decided (2026-10-30):** the Date and Time tools open a compact `DatePicker`. Duration opens a chip row. Repeat opens a `Menu`. Checklist opens an inline step field. The text and the chips stay in sync.
- The parsing and pre-fill decisions are in [Capture parsing](../features/quick-add-parsing.md#decisions).
