# Today

Status: Partial (no Plan sheet, Inbox drawer, or Quick add pre-fill yet)
Code: `Luna/Features/Today/` (`TodayScreen`, `DayPlan`, `BlockRow`, `BandSectionView`, `WeekStripView`, `HabitStripView`, `AnytimeSection`, `EmptyDayView`, `InboxPill`, `TimeText`), `Luna/Shared/Model/Week.swift`
Artboards: 2a, 2b, 2c, 2e, 2f (and 2d, 2q as hosts for sheets)
Features: [Timeline and day bands](../features/timeline-and-day-bands.md), [Block completion and routines](../features/block-completion-and-routines.md), [Anytime tasks](../features/anytime-tasks.md), [Habits](../features/habits.md), [Inbox scheduling](../features/inbox-scheduling.md), [Focus](../features/focus-and-live-activity.md)

## Purpose

Show one day as a timeline. You see what is next, tick off blocks, and find free time. This is the default tab.

## Layout (top to bottom)

1. **Header.** Date line (15 pt medium, secondary), for example "Thursday, October 29". Below it, the title: "Today" for the current day, or the weekday name for another day (34 pt bold). Trailing: a "Plan" capsule (sparkles icon, 36 pt high), a glass "Calendar" icon button (44 pt), and a glass "Settings" gear icon button (44 pt) that pushes Settings. **Decided (2026-10-31):** the gear is not in the artboards. It replaces the Settings tab. See [navigation map](README.md#navigation-map).
2. **Week strip.** Seven columns, Monday to Sunday. Each column has a weekday letter (12 pt, tertiary), a day number in a 38 pt circle (17 pt semibold), and a 4 pt dot if the day has blocks. The selected day has a filled circle. Past days use tertiary text. Future days use secondary text.
3. **Habit strip.** A row of habit rings that scrolls sideways. Each ring is 60 pt with a 3 pt progress stroke in the habit color and an icon. The label under it is the count ("5/8") for a multi-count habit, or the name. A done habit fills the circle with its color. The strip shows only the habits scheduled on the shown day (decided 2026-10-31). With none, the strip hides.
4. **Anytime section.** A capsule chip "Anytime N" with a clock icon and a chevron. A round "+" button on the trailing side. Below it, a grouped list of Anytime rows. See [Anytime tasks](../features/anytime-tasks.md).
5. **Band sections.** Morning (sunrise icon), Afternoon (sun), Night (moon). Each header is a capsule chip "Name N ⌄" with a trailing "X of Y done" text and a round "+" button. When a band is collapsed or empty, a summary line shows: "4 blocks · 3 h 15 min" or "Nothing planned".
6. **Timeline rows** inside an open band, in time order:
   - **Block row.** Time label (12 pt, tertiary). A pill (52 pt wide, height from duration). A dashed vertical rail under the pill to the next row. A meta line ("9:30 – 11:00 · 1 h 30 min", or "· 40 min left" when active, or "· Work" for an event). A title (17 pt semibold). A check circle on the trailing side (not on events).
   - **Routine row.** As a block row, plus its steps as small check rows and a 48 × 4 pt progress bar with "1/3".
   - **Free gap row.** Time label, a dashed rail, and "45 min free".
   - **Active block extras.** A "Focus" primary capsule (play icon) and a capsule with the remaining time ("39:48").
7. **Now line.** A 2 pt line in `text-primary` with a "10:20" capsule label. It crosses the active pill at the current progress.
8. **Day footer.** "5 of 11 blocks done" (13 pt, tertiary).
9. **Inbox pill** (glass, floating above the tab bar): "Inbox 5 ⌃". It shows only when the Inbox has items.
10. **Tab bar and "+" button.**

## Components

Pill, check circle, band chip, round add button, habit ring, week day cell, now line, free gap row, Inbox pill. See [Reusable patterns](../design/design-reference.md#reusable-patterns).

## Navigation

- Tap a task or routine pill: open [Edit block](edit-block.md). An event pill does nothing.
- Tap "Focus" on the active block: open [Focus](focus.md).
- Tap the Calendar button: push [Calendar](calendar.md).
- Tap "Plan": open [Plan my day](plan-my-day.md).
- Tap the Inbox pill or "Open Inbox": open the [Inbox drawer](inbox-drawer.md).
- Tap any "+" (header, band, Anytime, empty state): open [Quick add](quick-add.md).

## Interactions

- Tap a week day: show that day. The title changes to the weekday name.
- Tap a band chip: collapse or expand the band. The chevron rotates −90° when collapsed.
- Tap the Anytime chip: collapse or expand Anytime.
- Tap a check circle: toggle done. For a routine, this sets all steps to done, or all to not done.
- Tap a routine step: toggle that step.
- Tap a habit ring: add one to the count. At the goal, the next tap resets to zero.
- On open, the timeline scrolls to the now line ("Scroll to now on open" setting).

## States

| State | Observed behavior |
| --- | --- |
| Populated | As above (2b, 2c). |
| Active block | The pill fills from the top with full color to the progress point, then the done tint. The now line crosses it (2c). |
| Done block | Pill uses the done tint. Title is struck through and tertiary. |
| Past event | Pill uses `surface-secondary`. Icon and title use tertiary. |
| Empty day | (2e, Sunday.) Three dashed ghost pills for Morning (8:00), Afternoon (1:00), Night (7:00), each "Free". Then a card: "Sunday is wide open" / "Add a block, or bring something in from Inbox." with "Add block" (primary) and "Open Inbox" (secondary). The habit strip still shows. |
| Light theme | (2f.) Same layout with light tokens. |
| Loading, error | Not in the mockup. **Assumption:** local data loads at once, so no loading state. Calendar access errors belong to [Calendar events](../features/calendar-views-and-events.md). |

## Visual details

- Pill height: `min(112, 52 + duration × 0.5)` pt. Routine pill: 164 pt. See [Timeline](../features/timeline-and-day-bands.md).
- Event pills are graphite (`surface-tertiary`) with a calendar icon. The meta line starts with a 12 pt calendar icon.
- Bottom content padding is 170 pt so the last row clears the tab bar and the Inbox pill.

## Accessibility and iOS notes

- Each block row reads as one element: title, time range, state. The check is a separate button "Complete".
- The pill color is decoration. State must also show in text (strike-through, "done", "40 min left").
- Use `ScrollViewReader` or `scrollPosition` to scroll to now.
- A long Dynamic Type size can make a title taller than its pill. The text column must grow. The pill keeps its height.

## Implementation (1b.1)

- **Decided (2026-10-31):** a tap on a habit ring logs the day that Today shows. On a future day the rings do not log. See [Habits](../features/habits.md#decisions).
- **Decided (2026-10-31):** the Inbox pill and "Open Inbox" select the Inbox tab. Checkpoint 1c.2 changes both to open the drawer.
- **Decided (2026-10-31):** the Calendar button pushes the Calendar placeholder route. Checkpoint 1c.5 fills the screen.
- **Assumption:** the "Plan" chip has no action until 1c.4.
- **Assumption:** every "+" opens Quick add empty. The band and Anytime pre-fill arrives with the Quick add fields in 1c.1.
- **Assumption:** a compact "Today" chip shows in the header on any other day. It returns to the current day.
- **Assumption:** the Anytime section shows on every day with blocks. Its list hides when it is empty.
- **Assumption:** the timer capsule shows the time left in the active block. The Focus session (1c.6) replaces it.
- **Assumption:** "Scroll to now on open" and "Show free time" read `@AppStorage` keys with the default on. Settings (1b.5) edits them.

### Artboard comparison (2026-10-31)

Checked in the iPhone 17 simulator (iOS 27.0), dark and light, against the markup of artboards 2b, 2c, 2e, and 2f. Layout, colors, rows, the now line, and the empty day match. Intended differences:

| Item | Mockup | App | Why |
| --- | --- | --- | --- |
| Date line | "Thursday, October 29" | Locale order, for example "Thursday, 29 October" | Locale-aware dates (roadmap 3.4) |
| Plan button | 36 pt, 14 pt text, `text-secondary` | `ChipButton` (34 pt, 15 pt, `text-primary`) | One shared chip. Check in 3.3. |
| Pill icon | 22 pt | 20 pt | The design reference says 20 pt. Check in 3.3. |
| Day footer | "5 of 11" | "2 of 9" on the sample day | The artboard is static. See [Timeline](../features/timeline-and-day-bands.md#assumptions). |
| Long titles | One line | The title scales down to 70% beside the header buttons | Fits "Wednesday" next to "Today" and "Plan" |

## Open questions

- **Decided (2026-10-30):** a horizontal swipe on the week strip pages one week. A "Today" action returns to the current day.
- **Decided (2026-10-30):** the empty-day ghost times are each band start plus 2 hours. See [Timeline and day bands](../features/timeline-and-day-bands.md#decisions).
- The band and "+" pre-fill decisions are in [Timeline and day bands](../features/timeline-and-day-bands.md#decisions) and [Quick add parsing](../features/quick-add-parsing.md#decisions).
