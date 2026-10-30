# Settings and appearance

Status: Planned
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

## Assumptions

- Store these with `@AppStorage` until a persistence ADR. Keep keys in one place.
- Theme maps to `preferredColorScheme`. Dark is the default.
- Band starts are editable times in 15-minute steps.

## Decisions

- **Decided (2026-10-30):** Theme choices: Dark, Light, System. Dark is the default.
- **Decided (2026-10-30):** "Show calendar events" off hides events on Today and on Calendar. It does not remove calendar access.
- **Decided (2026-10-30):** "Scroll to now" off opens Today at the top of Morning.

## Unresolved

- Band start rules: can bands overlap or leave gaps? See [open-questions.md](../open-questions.md#settings).

## Related

[Timeline](timeline-and-day-bands.md), [Calendar](calendar-views-and-events.md), [Focus](focus-and-live-activity.md), [Plan my day](plan-my-day-suggestions.md).
