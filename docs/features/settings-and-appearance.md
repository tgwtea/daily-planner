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

## Unresolved

- Theme choices: Dark and Light only, or also System? See [open-questions.md](../open-questions.md#settings).
- Band start rules: can bands overlap or leave gaps?

## Related

[Timeline](timeline-and-day-bands.md), [Calendar](calendar-views-and-events.md), [Focus](focus-and-live-activity.md), [Plan my day](plan-my-day-suggestions.md).
