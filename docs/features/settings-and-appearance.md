# Settings and appearance

Status: Partial (built on v2 in 1b.5; v3 regroups Settings into 12 areas in 1d.10)
Screens: [Settings](../screens/settings.md), [Settings group](../screens/settings-group.md)

## Purpose

Hold user preferences that change app behavior and the theme.

## Observed (v2)

| Setting | Default | Effect seen in the mockup |
| --- | --- | --- |
| Morning / Afternoon / Night start | 6:00 AM / 12:00 PM / 6:00 PM | None (display only) |
| Show calendar events | On | Not wired |
| Show free time | On | Off hides free gap rows |
| Scroll to now on open | On | Not wired |
| Apple Calendar | On | Display only |
| Live Activity | On | Not wired |
| Haptics | On | Not wired |
| End-of-block sound | Off | Not wired |
| Plan suggestions | On | Not wired |
| Theme | Dark | The canvas shows a Light variant |

## v3 settings groups

Observed in v3 (`SIDX`, `SUB`, and the defaults in `TG0` in the prototype). Switch defaults in brackets. "Luna" replaces "Plan My Day" in all copy.

| Group (index header) | Page | Rows | Footer |
| --- | --- | --- | --- |
| Planning | Day bands | Morning 6:00 AM, Afternoon 12:00 PM, Night 6:00 PM; Preferred hours: Day starts 7:00 AM, Day ends 11:30 PM | "Blocks move into the band their start time falls in." / "Plan only suggests blocks inside these hours." |
| Planning | Scheduling | New blocks: Default type Flexible, Default length 30 min, Transition buffer 15 min. Changes: Suggest changes when running late (on), At most Once per block | "Blocks you placed are never moved without asking." |
| Planning | Protected time | One row per Open time pattern ("Unwind · Weekdays · 6–7 PM"), "Add protected time" | "Plan never puts tasks here. You can still add blocks yourself." |
| Planning | Energy | Use energy preferences (off), Ask when I plan (on); Usually: Most focused Morning, Lower energy After lunch | "Optional. Plan My Day never guesses how you feel. It only uses what you tell it." |
| Assistance | AI planning | Planning suggestions (on), Organize captures (on), Project summaries (on); Drafts: Prepare tomorrow's draft (on), Ready by 9:00 PM, Group related work (on), Keep long blocks for hard work (on); Learning: Learn from approved plans (off), Clear learned patterns | "Drafts never change your day until you approve them. Everything works without AI." / "Only plans you approved are used." |
| Assistance | Privacy & AI data | Process on device when possible (on), Share task titles (on), Share notes (off), Share event titles (off); Delete AI history | "Notes and calendar details stay on this iPhone unless you allow them." |
| Focus & alerts | Focus | Default timer Until block ends, Start with a timer (on), Show "I'm stuck" (on); Check-ins (off), Every 20 min; Live Activity (on), Haptics (on), End-of-timer sound (off) | See [Focus](focus-and-live-activity.md). |
| Focus & alerts | Notifications | See [Notifications](notifications.md). | |
| Connections | Calendar | Show on timeline: University, Personal, Work (off), Holidays; Two-way sync: Sync selected blocks (on), Write to, New blocks Local only; When things change: Edited in Calendar Ask me, Calendar unavailable Keep local, Last synced | See [Two-way sync](calendar-views-and-events.md#two-way-sync). |
| Connections | Inbox review | Suggest a review When I plan, Weekly reminder (off), Include unfinished blocks (on) | "Skipping a review never moves or deletes anything." |
| App | Appearance | Theme, Text size System; Today: Habits on Today (on), Now and next bar (on), Show streaks (on); Accessibility: Reduce motion, Increase contrast, Reduce transparency (each "System") | "Follows iOS settings by default." |
| App | Data & backup | iCloud sync "Synced 10:18 AM", Backups Daily, Export data; Waiting to sync 0 | "Captures save on this iPhone first, even offline." |

Decisions for v3 settings:
- **Decided (2026-11-03):** AI is on-device only. The Privacy & AI data page keeps "Delete AI history". The "Process on device" and "Share …" switches are hidden (intended difference).
- **Decided (2026-11-03):** iCloud sync and backup are in v1 (roadmap 2.1). This replaces "local only for v1" (2026-10-30).
- **Decided (2026-11-03):** the v2 "Show free time" and "Scroll to now on open" switches have no v3 row. **Assumption:** keep both, in Appearance › Today, because code uses them.
- **Decided (2026-11-03):** v2 "Show calendar events" becomes the per-calendar checks in Calendar.
- **Assumption:** "Text size" and the three accessibility rows show the iOS value and link to iOS Settings. They do not override iOS.

## Implementation

- Screen: `Luna/Features/Settings/`. See [Settings](../screens/settings.md).
- Keys: `Luna/Shared/Settings/SettingsKey.swift`. Theme: `AppTheme`, applied in `LunaApp` with `preferredColorScheme`.
- Band starts: `BandScheduleStorage` (`Luna/Shared/Settings/`) reads and writes the three starts. Today and Inbox read it, so a change moves blocks at once. `BandSchedule.allowedStarts(for:)` and `setStart(_:for:)` hold the order rule.
- Wired now: Theme, Show free time, Scroll to now, band starts, Suggestions (hides the Plan button on Today).
- Stored only: Show calendar events (2.2), Live Activity (2.3), Haptics and End-of-block sound (2.4).

## Assumptions

- Store these with `@AppStorage` until a persistence ADR. Keep keys in one place.
- Theme maps to `preferredColorScheme`. Dark is the default.

## Decisions

- **Decided (2026-10-30):** Theme choices: Dark, Light, System. Dark is the default.
- **Decided (2026-10-30):** "Show calendar events" off hides events on Today and on Calendar. It does not remove calendar access.
- **Decided (2026-10-30):** "Scroll to now" off opens Today at the top of Morning.
- **Decided (2026-10-31):** band starts keep the order Morning < Afternoon < Night. Each start is at least 1 hour after the one before it. Night starts at 11:00 PM at the latest. Steps are 15 minutes. Gaps cannot occur, because each band ends where the next one starts.

## Related

[Timeline](timeline-and-day-bands.md), [Calendar](calendar-views-and-events.md), [Focus](focus-and-live-activity.md), [Plan hub](plan-my-day-suggestions.md), [Notifications](notifications.md).
