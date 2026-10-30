# Settings

Status: Planned
Artboards: 2n
Features: [Settings and appearance](../features/settings-and-appearance.md)

## Purpose

Change how the timeline, calendar, focus, and suggestions behave.

## Layout (top to bottom)

Title "Settings" (34 pt bold), then grouped lists with headers and footers:

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
- **Assumption:** band rows open a time picker. Calendars opens a calendar picker. Theme opens a choice list.

## Accessibility and iOS notes

- Use `Form` or `List` with `Toggle` and `NavigationLink`. Restyle to Noir.
- Store settings with `@AppStorage` until a persistence ADR says otherwise. **Assumption.**

## Open questions

- Theme choices: the mockup shows "Dark" and has a light artboard. Is "System" a choice? See [open-questions.md](../open-questions.md#settings).
- What do "Show calendar events" off and "Scroll to now" off change exactly?
- What does the Plan button do when Suggestions is off?
