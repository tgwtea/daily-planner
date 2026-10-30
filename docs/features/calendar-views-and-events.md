# Calendar views and events

Status: Planned
Screens: [Calendar](../screens/calendar.md), [Today](../screens/today.md), [Settings](../screens/settings.md)

## Purpose

Show system calendar events next to blocks. Show more than one day at once.

## Observed

Events:
- Events come from Apple Calendar (Settings: "Work, Personal, Family"). They are read-only: "Plan My Day never edits your calendar."
- On Today, events are graphite pills with a calendar icon and no checkbox. The meta line ends with the calendar name.
- "Show calendar events" is a Settings switch.

Views:
- Day (today), 3 days (from today), Week (Monday to Sunday), Month.
- Grid views cover 7 AM to 11 PM at 38 pt per hour. Blocks that start before 7 AM or at 11 PM or later are not drawn.
- Month: each day shows up to three dots, one per distinct task color. Events add no dot. Select a day to see up to 6 items in the agenda.

## Assumptions

- Use EventKit with full read access (`requestFullAccessToEvents`). iOS 17+ needs this to read events.
- Ask for access the first time the user turns on calendars, not at launch.
- Without access, Today shows no events. Settings shows the access state and a link to iOS Settings.
- Add the EventKit integration with an ADR.

## Unresolved

- Permission flow and the denied state. See [open-questions.md](../open-questions.md#calendar).
- Which calendars are on by default.
- Paging between weeks and months. Tapping a calendar block.
- All-day events. The mockup has none.

## Related

[Timeline](timeline-and-day-bands.md), [Settings](settings-and-appearance.md).
