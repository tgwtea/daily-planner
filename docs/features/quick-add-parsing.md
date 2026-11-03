# Capture parsing

Status: Partial (implemented as Quick add in 1c.1; v3 gap: the no-time save rule, 1d.5)
Code: `Luna/Shared/Model/QuickAddParser.swift`, `QuickAddDraft.swift`, `RepeatRule.swift`, `BlockIcons.swift`, `PlannerStore.swift` (`addQuickAdd`), `Luna/Features/QuickAdd/QuickAddChip.swift`
Screens: [Capture](../screens/capture.md)

The file name keeps "quick-add" so that links stay stable. The term is Capture (decided 2026-11-03).

## Purpose

Turn one line of plain text into a block, or save it to the Inbox as a capture item. The v3 `parse()` function is the same as v2.

## Observed

The mockup `parse()` function reads three tokens and removes each one from the title:

| Token | Pattern (case-insensitive) | Result |
| --- | --- | --- |
| Duration | `\b(\d+)\s?(m\|min\|mins\|h\|hr\|hrs)\b` | minutes; `h` forms × 60 |
| Time | `\b(\d{1,2})(?::(\d{2}))?\s?(am\|pm)\b` | minutes after midnight; `12am` = 0, `12pm` = 720 |
| Day | `\b(today\|tonight\|tomorrow\|tmrw)\b` | today, or tomorrow for `tomorrow`/`tmrw` |

The rest, with spaces collapsed, is the title.

Examples:
- "Call the dentist tomorrow 9am 15m" → title "Call the dentist", tomorrow, 9:00 AM, 15 min.
- "gym tmrw 7am 45m" → "gym", tomorrow, 7:00 AM, 45 min.

Save rules:
- Empty title: close and save nothing.
- With a time: create a task block on the parsed day (default today), duration default 30 min, with the chosen icon and color. Show Today on that day.
- Without a time (v2): add to the top of the Inbox with duration default 30 min and tag "Inbox".
- Without a time (v3): add a capture item to the top of the Inbox with the raw text, no duration, and the organization state "organizing" (or "offline" when AI is off or not available). Toast "Saved to Inbox". See [Capture and organization](capture-and-organization.md).
- With a time (v3): toast "Added to Today · 7:00 AM" (or the day name).
- The color defaults to the last value. The color chip cycles Rose → Slate → Sage → Sand → Plum.

## Assumptions

- The parser is a pure Swift type (`QuickAddParser`). `QuickAddDraft` holds the sheet state and the save rules. Unit tests cover every example and edge case: `LunaTests/QuickAdd/`.
- `Calendar` and its time zone set "today" and "tomorrow". `calendar.locale` sets the order of a numeric date.
- "tonight" means today. The mockup does the same. It does not set a time.
- A time with no am/pm ("at 7") is not a time. The mockup ignores it.
- An am/pm hour must be 1 to 12. "13pm" is not a time.
- A 24-hour time needs a colon: `H:MM` or `HH:MM`, 0:00 to 23:59. "9:30" is 9:30 AM. An am/pm time wins over a 24-hour time.
- When the text has more than one day token, the first one in the text counts.
- A month-name date reads "nov 3", "Nov 3rd", "november 3", and "3 nov". A date that is already past this year goes to next year. A date that does not exist ("feb 30") stays in the title.
- A zero duration ("0m") is no duration. The token still leaves the title.
- The text is the one source of the day, time, and duration. A picker writes a token into the text ("tomorrow", "nov 6", "9:30am", "45m", "2h"). It replaces the token that is there, or adds the token at the end.
- A token in the text wins over a pre-fill. A day token with a band pre-fill keeps the pre-fill time.
- A band "+" on a full band pre-fills the band start.
- A block that starts at 11:59 PM has no time left. It becomes an Anytime task on that day. **Assumption (2026-11-03):** v3 keeps this rule.
- A no-time item does not open Today. Only a new block opens Today on its day.
- The Inbox tag "Inbox" means no project (`projectID == nil`).
- The last color and icon carry over in `@AppStorage` (`quickAddColor`, `quickAddIcon`). The first default is Rose and `phone`, as in the mockup.
- The 12 icons are the mockup `ICONS` list mapped to SF Symbols (`BlockIcons`).
- Repeat applies to a block only, like Checklist. The Repeat tool is disabled without a time.

## Decisions

- **Decided (2026-11-03):** Text with no time becomes a capture item in the Inbox, with or without a day word. The day word becomes a suggested "When" field. This replaces the 2026-10-30 rule ("a day word and no time becomes an Anytime task"). An Anytime pre-fill still saves an Anytime task.
- **Decided (2026-10-30):** Pre-fill by "+" button:
  - A band "+" pre-fills the next free time in that band.
  - The Anytime "+" pre-fills Anytime.
  - The header "+" and the tab bar "+" pre-fill nothing.
- **Decided (2026-10-30):** The parser also reads weekday names ("mon", "friday": the next such day), dates in the device locale order ("nov 3", "3/11"), and 24-hour times ("14:30"). English only.
- **Decided (2026-10-30):** The Date, Time, Duration, Repeat, and Checklist tools open inline native pickers. v3 shows Dictate, Date, Time, Duration, Reminder, and Icon. See [Capture](../screens/capture.md#v3-gaps-code-built-in-1c1-as-quick-add).
- **Decided (2026-10-31):** A weekday name is always 1 to 7 days ahead. On a Monday, "mon" is next Monday.
- **Decided (2026-10-31):** Quick add sets a repeat rule on the block (`Block.repeatRule`). A rule other than Never makes the block a routine. The repeated display and the per-day reset wait for 1c.3.
- **Decided (2026-10-31):** The Checklist tool works only when the item becomes a block. Inbox items and Anytime tasks have no steps.

## Edge cases

- "Run 5k 30m": "5k" stays in the title.
- Two durations ("1h 30m"): only the first match is used. "30m" stays in the title.
- A weekday inside a word ("Sunrise walk") is not a day.

## Related

[Inbox scheduling](inbox-scheduling.md), [Block editing](block-editing.md).
