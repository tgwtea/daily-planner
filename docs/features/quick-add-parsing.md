# Quick add parsing

Status: Planned
Screens: [Quick add](../screens/quick-add.md)

## Purpose

Turn one line of plain text into a block or an Inbox task.

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
- Without a time: add to the top of the Inbox with duration default 30 min and tag "Inbox".
- The color defaults to the last value. The color chip cycles Rose → Slate → Sage → Sand → Plum.

## Assumptions

- Implement the parser as a pure Swift type with unit tests for each example above.
- Use `Calendar` and the user's time zone for "today" and "tomorrow".
- "tonight" means today. The mockup does the same. It does not set a time.
- A time with no am/pm ("at 7") is not a time. The mockup ignores it.

## Unresolved

- Should no-time items go to Anytime when a day word is present ("pay bill tomorrow")? The mockup sends them to the Inbox and drops the day. See [open-questions.md](../open-questions.md#capture).
- Which "+" button pre-fills a band or Anytime?
- Weekday names, dates, 24-hour times, and other languages.
- What do the Date, Time, Duration, Repeat, and Checklist tools open?

## Edge cases

- "Run 5k 30m": "5k" stays in the title.
- Two durations ("1h 30m"): only the first match is used.

## Related

[Inbox scheduling](inbox-scheduling.md), [Block editing](block-editing.md).
