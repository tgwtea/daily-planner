# Calendar

Status: Planned
Artboards: 2o (3 days), 2p (Month)
Features: [Calendar views and events](../features/calendar-views-and-events.md)

## Purpose

See blocks and events across more than one day.

## Layout (top to bottom)

1. Glass back button (chevron-left) and title "October 2026" (28 pt bold, year in tertiary semibold).
2. Segmented control: Day, 3 days, Week, Month. The default in the mockup is 3 days.
3. **Grid views (Day, 3 days, Week):**
   - Column headers: weekday (12 pt, tertiary) and day number in a 30 pt circle. Today's circle is filled.
   - An hour grid from 7 AM to 11 PM. 38 pt per hour. Hour labels 10 pt on the left (every hour; every second hour in Week). Hairline dividers.
   - Blocks as rounded rectangles (radius 8) at their time. Task blocks use their color with ink text. Events use `surface-raised`. Title 11 pt semibold and start time 10 pt. In Week view the blocks have no text.
   - Now line on the today column: 2 pt line and an 8 pt dot.
   - Day view shows today. 3 days starts at today. Week shows Monday to Sunday.
4. **Month view:**
   - Weekday header M–S. A 5-row grid of 62 pt cells. Each cell has a day number in a 32 pt circle and up to three 6 pt color dots (one per distinct block color that day). Days outside the month use tertiary text.
   - Tap a day to select it. The selected circle is filled.
   - Agenda below: the selected date as a header, then a list (up to 6 rows): a 10 pt color dot, the title, the start time. Events use a tertiary dot. With no items: "Nothing planned."

## Navigation

- Opened from the Calendar button on [Today](today.md). Back returns to Today.
- Tab bar is hidden.

## Interactions

- Switch views with the segmented control.
- **Observed:** blocks in grid views have no tap action.
- **Decided (2026-10-30):** swipe pages by the view length. A tap on a task block opens Edit block. A tap on an event opens a read-only detail. See [Calendar views and events](../features/calendar-views-and-events.md#decisions).

## Accessibility and iOS notes

- Grid blocks need labels: title, day, time.
- Use a `Picker` with `.segmented` style.
- Large Dynamic Type sizes do not fit in a 3-column grid. **Assumption:** keep the grid and truncate titles, and give full text in the accessibility label.

## Open questions

None. See [Calendar views and events](../features/calendar-views-and-events.md#decisions).
