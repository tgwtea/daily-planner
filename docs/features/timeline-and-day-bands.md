# Timeline and day bands

Status: Planned
Screens: [Today](../screens/today.md), [Settings](../screens/settings.md)

## Purpose

Show one day's blocks in time order, grouped into Morning, Afternoon, and Night, with free time between them.

## Observed

Data:
- A block has: id, day, kind (`task`, `routine`, `event`), title, start (minutes after midnight), duration (minutes). A task or routine also has an icon and a block color. A routine has steps. An event has a calendar name ("Work", "Personal").

Bands:
- The mockup code uses these ranges: Morning 0–720 (to 12:00 PM), Afternoon 720–1080 (to 6:00 PM), Night 1080–1440 (to midnight).
- A block belongs to the band that contains its start time.
- Each band header shows the block count, "X of Y done" (tasks and routines only), and a "+" button.
- A band with no blocks is shown closed with "Nothing planned". A collapsed band shows "N blocks · total duration".

Rows:
- A free gap row shows between two blocks in the same band when the gap is 20 minutes or more, and "Show free time" is on. The label is "1 h 15 min free". The gap starts at the latest end time so far.
- Pill height: `min(112, 52 + duration × 0.5)` pt. A routine pill is 164 pt.

Time states (relative to now):
- **Active**: a task or routine that is not done, on today, where `start ≤ now < start + duration`. The pill fills to the elapsed fraction. The meta line shows "N min left". The Focus button and timer show.
- **Past**: the block ends at or before now, or is on an earlier day. Past events are dimmed. Past tasks are not dimmed unless done.
- Duration format: "15 min", "1 h", "1 h 30 min". Time format: "9:30" (12-hour, no AM/PM on the timeline).

Day navigation:
- The week strip selects a day. Days with blocks show a dot.
- The day footer shows "X of Y blocks done" for tasks and routines.

## Assumptions

- Store times as `Date` values in the model. Compute minutes from midnight in the user's calendar and time zone for layout.
- Use the locale's 12- or 24-hour setting. The mockup uses 12-hour only.
- The now line updates once a minute.
- Blocks that overlap in time show as separate rows in start order. The mockup has no overlaps on the sample day.

## Decisions

- **Decided (2026-10-30):** Bands start at the Settings values (default 6:00 AM, 12:00 PM, 6:00 PM). A block that starts before the Morning start goes in Morning.
- **Decided (2026-10-30):** A block cannot cross midnight. It ends at 11:59 PM at the latest.
- **Decided (2026-10-30):** Blocks can overlap. Overlapping blocks show in start-time order. Each overlapping row shows a small overlap hint.
- **Decided (2026-10-30):** The empty-day ghost times are each band start plus 2 hours (8:00, 2:00, 8:00 with the defaults). This differs from the mockup (8:00, 1:00, 7:00).

## Edge cases

- A block that starts in one band and ends in the next stays in its start band.
- Daylight saving days have 23 or 25 hours.
- A very short block (5 min) still gets a 52 + 2.5 ≈ 55 pt pill.

## Related

[Block completion](block-completion-and-routines.md), [Calendar events](calendar-views-and-events.md), [Inbox scheduling](inbox-scheduling.md).
