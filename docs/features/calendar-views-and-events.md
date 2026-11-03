# Calendar views and events

Status: Planned
Screens: [Calendar](../screens/calendar.md), [Today](../screens/today.md), [Block detail](../screens/block-detail.md), [Sync conflict](../screens/sync-conflict.md), [Settings group](../screens/settings-group.md), [Onboarding](../screens/onboarding.md)

## Purpose

Show system calendar events next to blocks. Show more than one day at once. Sync selected blocks both ways with one dedicated calendar.

## Observed

Events:
- Events come from Apple Calendar. They are fixed time: "Events are fixed. Plan My Day doesn't edit them." Plan never moves them.
- v3 Calendar settings list each calendar with a check (University, Personal, Work, Holidays). Work is off in the mockup.
- On Today, events are graphite pills with a calendar icon and no checkbox. The meta line ends with the calendar name.
- v2: "Show calendar events" is a Settings switch. v3 replaces it with the per-calendar checks.
- Access denied (3ai): Today shows the banner "Calendar is off. Events aren't shown." with "Turn on". The Calendar settings group shows a card with "Open iOS Settings". Events hide.

Views:
- Day (today), 3 days (from today), Week (Monday to Sunday), Month.
- Grid views cover 7 AM to 11 PM at 38 pt per hour. Blocks that start before 7 AM or at 11 PM or later are not drawn.
- Month: each day shows up to three dots, one per distinct task color. Events add no dot. Select a day to see up to 6 items in the agenda.

## Two-way sync

Observed in v3 (3af, 3ag, 3ah):
- Sync is per block. Only blocks the user marks ("Show in Apple Calendar") appear in Apple Calendar, in their own dedicated calendar. New blocks are local only by default.
- A synced block shows a refresh glyph on Today.
- Edits in the app update the calendar copy. An edit in Calendar asks before it changes the block ("Edited in Calendar: Ask me"). The ask is the [Sync conflict](../screens/sync-conflict.md) dialog.
- Deleting a synced block removes only its copy in the dedicated calendar.
- If a calendar becomes unavailable or access is revoked, synced blocks stay as local-only ("Calendar unavailable: Keep local").
- Settings shows "Write to", "New blocks", and "Last synced 10:18 AM".

- **Decided (2026-11-03):** two-way per-block sync is in v1 (roadmap 2.2). The dedicated calendar is named "Luna" (see [Naming](../README.md#naming)). It needs EventKit full access.

## Assumptions

- Use EventKit with full read access (`requestFullAccessToEvents`). iOS 17+ needs this to read events.
- Ask for access the first time the user turns on calendars, not at launch.
- Without access, Today shows no events. Settings shows the access state and a link to iOS Settings.
- Add the EventKit integration with an ADR.

## Decisions

- **Decided (2026-11-03):** onboarding step 3 asks for calendar access ("Allow access" or "Not now"). This replaces the 2026-10-30 opt-in rule below for new users.
- **Decided (2026-10-30):** The app asks for calendar access only on opt-in: when the user turns on Apple Calendar in Settings, or on the first open of Calendar. If access is denied, an inline card explains it and has an "Open Settings" button.
- **Decided (2026-10-30):** All calendars are on by default.
- **Decided (2026-10-30):** A horizontal swipe pages by the view length (1 day, 3 days, 1 week, 1 month).
- **Decided (2026-10-30):** A tap on a task block opens [Block detail](../screens/block-detail.md). A tap on an event opens a read-only detail.
- **Decided (2026-10-30):** All-day events show in a strip above the time grid.

## Related

[Timeline](timeline-and-day-bands.md), [Settings](settings-and-appearance.md).
