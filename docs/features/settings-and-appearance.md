# Settings and appearance

Status: Partial (Show calendar events, Live Activity, Haptics, and End-of-block sound are stored only)
Screens: [Settings](../screens/settings.md)

## Purpose

Hold user preferences that change app behavior and the theme.

## Observed

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

[Timeline](timeline-and-day-bands.md), [Calendar](calendar-views-and-events.md), [Focus](focus-and-live-activity.md), [Plan my day](plan-my-day-suggestions.md).
