# Today

Status: Partial (built on v2 in 1b.1; the v3 gaps are listed below)
Code: `Luna/Features/Today/` (`TodayScreen`, `DayPlan`, `BlockRow`, `BandSectionView`, `WeekStripView`, `HabitStripView`, `AnytimeSection`, `EmptyDayView`, `InboxPill`, `TimeText`), `Luna/Shared/Model/Week.swift`
Artboards: 3a, 3e, 3f, 3g, 3h, 3i, 3l, 3m, 3n, 3ai, 3an (and 3j, 3k, 3ag as hosts for sheets and dialogs)
Features: [Timeline and day bands](../features/timeline-and-day-bands.md), [Block types](../features/block-types.md), [Block completion and routines](../features/block-completion-and-routines.md), [Anytime tasks](../features/anytime-tasks.md), [Habits](../features/habits.md), [Inbox scheduling](../features/inbox-scheduling.md), [Plan hub suggestions](../features/plan-my-day-suggestions.md), [Running-late nudge](../features/running-late-nudge.md), [Calendar views and events](../features/calendar-views-and-events.md)

## Purpose

Show one day as a timeline. You see what is now and next, tick off blocks, find free time, and review AI drafts. This is the default tab.

## Layout (top to bottom)

1. **Header.** Date line (15 pt medium, secondary), for example "Thursday, October 29". Below it, the title button: "Today" (or the weekday name) in 34 pt bold with a 20 pt chevron-down. It pushes [Calendar](calendar.md). Trailing: a "Plan" capsule (36 pt, sparkles icon, 14 pt semibold), and a 44 pt glass Inbox drawer button (`panel-bottom-open`) with a count badge of the Inbox items to plan. **Decided (2026-11-03):** a 44 pt glass Settings gear follows them. The v3 canvas omits it on Today; the handoff puts it on every root.
2. **Week strip.** Seven columns, Monday to Sunday: weekday letter (12 pt, tertiary), day number in a 38 pt circle (17 pt semibold), and a 4 pt dot if the day has blocks. Today's dot is `text-primary`, other dots `text-tertiary`.
3. **Calendar-off banner** (only when calendar access is off, 3ai): `calendar-off` icon, "Calendar is off. Events aren't shown.", and a "Turn on" capsule that pushes the Calendar settings group. Radius 16 on `surface-primary`.
4. **Now · Next bar** (sticky glass, radius 18, 14 pt below the strip, sticks 56 pt from the top): an 8 × 28 pt bar in the now block color, "Now · 40 min left" (12 pt) over the title (15 pt semibold). Trailing: "Next · 12:00" over the next title (14 pt, max 140 pt). With no current block: "Now" / "Free until 12:00". With no next block: "Next" / "Nothing else today". While Focus runs: "Now · focusing 39:48". A tap scrolls to now. It shows on the current day, when the day has blocks and the "Now and next bar" setting is on.
5. **Habit strip.** 50 pt rings (3 pt stroke) with an icon and a label (count "5/8" or the name). Hidden when the "Habits on Today" setting is off, and on first run.
6. **Draft header** (only while a draft exists for the shown day, 3l): sparkles, "Draft · rest of today" (or the weekday), a "Regenerate" capsule ("Thinking…" while it runs), and the line "Suggestions have dashed outlines. Nothing changes until you approve. Events, fixed blocks and protected time stay where they are." Then one row per item that does not fit: `circle-slash`, "Doesn't fit · Buy guitar strings" and the reason.
7. **Anytime.** A capsule chip "Anytime N" with a clock icon and a chevron. Trailing summary "2 left" or "All done". **Collapsed by default.** Anytime shows on the current day only.
8. **Band sections.** Morning, Afternoon, Night. A capsule chip "Name N ⌄", "X of Y done", and a round "+" ("Add to Morning"). A closed or empty band shows "4 blocks · 3 h 15 min" or "Nothing planned".
9. **Timeline rows** inside an open band, in time order. See [Block types](../features/block-types.md) for the pill styles.
   - **Block row:** time label, pill, glyphs, meta line, title, and a check circle (not on events, Open time, or suggestions). Meta examples: "9:30 – 11:00 · 1 h 30 min", "· 40 min left" (active), "· Not checked off" (unconfirmed), "· Partly done", "· Focused 1 h 10 min" (done after Focus), "· University" (event), "· Protected" (Open time), "· Changed in Calendar" (sync conflict, `status-warning`).
   - **Glyphs** before the meta text: lock (Fixed), shield (Open time), calendar (event), sparkles (suggestion), triangle-alert (sync conflict), refresh (synced).
   - **Routine row:** as a block row plus step rows. Routine pill 150 pt.
   - **Active block:** a primary "Focus" capsule with a play icon. While Focus runs on it: a "Focusing · 39:48" capsule, and "· 35 min over" after the block end.
   - **Suggestion row:** dashed pill, meta "Suggested · 2:30 – 2:45" or "Move 9:00 → 9:15", the reason (for example "Right before office hours. Same course, so one fewer switch."), and action capsules. New: Skip, Edit. Move: "Keep at 9:00", Edit. Conflict: a `triangle-alert` line "Overlaps Unwind by 15 min" and "Shorten to 1 h" (primary), "Move to Friday", Skip. A skipped suggestion fades to 40% and shows Undo.
   - **Free gap row:** time label, dashed rail, "45 min free". Shown at 20 min or more, when "Show free time" is on.
10. **Now line.** 2 pt line with a "10:20" capsule label across the active pill.
11. **Day footer.** "5 of 11 blocks done". On the current day a second line: "Everything else: 5 in Inbox · 4 could use a decision".
12. **Bottom accessory** (one at a time, above the tab bar): Focus mini-player, draft approval bar, or running-late nudge. See [navigation map](README.md#navigation-map).
13. **Tab bar and Capture button.**

## Navigation

- Tap the title: push [Calendar](calendar.md).
- Tap a task, routine, Open time, or suggestion pill: push [Block detail](block-detail.md). An event pill does nothing. A pill with a sync conflict opens the [Sync conflict](sync-conflict.md) dialog.
- Tap "Focus": open [Focus](focus.md).
- Tap "Plan": open the [Plan hub](plan-my-day.md).
- Tap the drawer button or "Open Inbox": open the [Inbox drawer](inbox-drawer.md).
- Tap the gear: push [Settings](settings.md).
- Tap any "+" or "Add block": open [Capture](capture.md).
- Nudge "Preview": open [Before and after](before-after.md).

## Interactions

- Tap a week day: show that day.
- Tap a band chip or the Anytime chip: collapse or expand it.
- Tap a check circle: toggle done. It clears an outcome. For a routine, all steps toggle.
- Tap a routine step: toggle that step.
- Tap a habit ring: add one. At the goal, the next tap resets to zero.
- Draft approval bar: "N changes ready", "1 needs a decision · 3 h 20 min free after", "Keep original", "Approve N". See [Plan hub suggestions](../features/plan-my-day-suggestions.md).
- On open, the timeline scrolls to now.

## States

| State | Observed behavior |
| --- | --- |
| Busy day | 3e, 3f. |
| Partly planned | 3g (Friday): a few blocks, large gaps. |
| Active block | The pill fills top-down to the progress point, then the done tint. |
| Done block | Done tint. Title struck through, tertiary. |
| Unconfirmed block | A past task not checked off: 55% tint, dashed tertiary check ring, "· Not checked off". |
| Past event | `surface-secondary` pill, tertiary icon and title. |
| Draft | 3l, 3m: draft header, suggestion rows, approval bar. |
| Running late | 3n: the nudge in the bottom accessory. |
| Calendar off | 3ai: banner. Events hide. |
| Empty day | 3h: three dashed ghost pills (8:00, 1:00, 7:00, "Free"), then "Sunday is wide open" / "Add a block, or bring something in from Inbox." with "Add block" and "Open Inbox". |
| First run | 3an: no habits strip. "Start with one block" / "Add something you're doing today, or capture what's on your mind. You can arrange it later." with "Add block" and "Capture". |
| Light theme | 3i. |

## Visual details

- Pill height: `clamp(52, 52 + 0.5 × minutes, 112)` pt. Routine pill 150 pt.
- Bottom content padding 200 pt.

## Accessibility and iOS notes

- Each block row reads as one element: "Build SwiftUI timeline, 10:00 to 11:30, flexible, 70 minutes left". A suggestion starts with "Suggested". The check is a separate button "Mark done" / "Mark not done".
- State shows in glyphs and text, not only in color.
- Use `ScrollViewReader` or `scrollPosition` to scroll to now, and from the Now · Next bar.
- A long Dynamic Type size can make a title taller than its pill. The text column grows. The pill height is a minimum.

## v3 gaps (code built in 1b.1 on v2)

- Inbox pill: remove. Add the header drawer button with a badge (1d.3).
- Title chevron that pushes Calendar; Calendar icon button removed (1d.4).
- Now · Next bar, calendar-off banner, Anytime collapsed by default, habit strip setting, 50 pt rings (1d.4).
- Block types, glyphs, unconfirmed state, outcome meta, focused time (1d.1, 1d.4).
- Draft rows, draft header, approval bar (1c.4). Nudge (1d.7). First-run state (1d.11).
- Day footer second line (1d.4). Timer capsule removed; time left in the meta line (1d.4).

## Implementation notes (1b.1, v2)

- **Decided (2026-10-31):** a tap on a habit ring logs the day that Today shows. On a future day the rings do not log. See [Habits](../features/habits.md#decisions).
- **Decided (2026-10-31):** the Inbox pill and "Open Inbox" select the Inbox tab. Checkpoint 1c.2 changes both to open the drawer. **Decided (2026-11-03):** v3 removes the Inbox pill. The header drawer button and "Open Inbox" open the drawer.
- **Decided (2026-10-31):** the Calendar button pushes the Calendar placeholder route. Checkpoint 1c.5 fills the screen.
- **Assumption:** the "Plan" chip has no action until 1c.4.
- A band "+" pre-fills its next free time. The Anytime "+" pre-fills Anytime on the shown day. See [Capture parsing](../features/quick-add-parsing.md#decisions).
- **Assumption:** the shown day lives in the router (`AppRouter.todayDay`), so that Quick add can open Today on the day of a new block.
- **Assumption:** a compact "Today" chip shows in the header on any other day. It returns to the current day.
- **Assumption:** the Anytime section shows on every day with blocks. Its list hides when it is empty.
- **Assumption:** the timer capsule shows the time left in the active block. v3 removes it: the meta line shows the time left. While Focus runs, a "Focusing · 39:48" capsule shows.
- **Assumption:** "Scroll to now on open" and "Show free time" read `@AppStorage` keys with the default on. Settings (1b.5) edits them.

### Artboard comparison (2026-10-31, v2)

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
- The band and "+" pre-fill decisions are in [Timeline and day bands](../features/timeline-and-day-bands.md#decisions) and [Capture parsing](../features/quick-add-parsing.md#decisions).
