# Settings

Status: Partial (the Calendars row has no destination until 2.2)
Code: `Luna/Features/Settings/SettingsScreen.swift`, `BandStartPicker.swift`, `ThemePicker.swift`, `BandStartText.swift`
Artboards: 2n
Features: [Settings and appearance](../features/settings-and-appearance.md)

## Purpose

Change how the timeline, calendar, focus, and suggestions behave.

**Decided (2026-10-31):** Settings is not a tab. The gear in the Today header pushes it. It uses the system navigation bar with a large "Settings" title and a back button. The tab bar hides on it. See [navigation map](README.md#navigation-map).

## Layout (top to bottom)

Navigation bar with a large title "Settings", then grouped lists with headers and footers:

| Group | Rows | Footer |
| --- | --- | --- |
| Day bands | Morning 6:00 AM ›, Afternoon 12:00 PM ›, Night 6:00 PM › (each with its band icon) | "Blocks move into the band their start time falls in." |
| Timeline | Show calendar events (on), Show free time (on), Scroll to now on open (on) | — |
| Calendars | Apple Calendar, subtitle "Work, Personal, Family", value "On" › | "Events are read-only. Plan My Day never edits your calendar." Use "Luna" in place of "Plan My Day". |
| Focus | Live Activity (on), Haptics (on), End-of-block sound (off) | — |
| Plan my day | Suggestions (on) | "When on, Plan suggests times for Inbox tasks. Nothing is scheduled until you add it." |
| Appearance | Theme › value "Dark" | — |

The values in brackets are the mockup defaults.

## Interactions

- **Observed:** the switches toggle. "Show free time" off hides the free gap rows on Today.
- **Observed:** rows with a chevron have no destination in the mockup.
- **Decided (2026-10-31):** each band row pushes a list of start times in 15-minute steps, with a checkmark. A tap saves and goes back.
- **Assumption:** Theme pushes a choice list (Dark, Light, System) that works the same way.
- **Assumption:** the Calendars row shows the mockup values and has no destination until checkpoint 2.2 adds the calendar picker.

## Accessibility and iOS notes

- Use `Form` or `List` with `Toggle` and `NavigationLink`. Restyle to Noir.
- Store settings with `@AppStorage` until a persistence ADR says otherwise. **Assumption.**
- **Assumption:** switches use `LunaSwitchStyle`, a `ToggleStyle` on the native `Toggle`. The system switch keeps a white thumb, so it cannot show the dark "on" state (white track, black thumb).

## Intended differences

- Switch rows are about 56 pt tall. The 44 pt hit target of the switch sets the height.
- The icon box uses `surfaceTertiary` from `GroupedRow` (1a.5), not the Noir `surface-icon-container`.

## Open questions

- The theme and switch decisions are in [Settings and appearance](../features/settings-and-appearance.md#decisions). The Suggestions decision is in [Plan my day suggestions](../features/plan-my-day-suggestions.md#decisions).
- See [open-questions.md](../open-questions.md#settings).
