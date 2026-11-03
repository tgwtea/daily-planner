# Settings

Status: Partial (built on v2 in 1b.5; v3 regroups it, see the v3 gaps)
Code: `Luna/Features/Settings/SettingsScreen.swift`, `BandStartPicker.swift`, `ThemePicker.swift`, `BandStartText.swift`
Artboards: 3d (and 3ah, 3al for groups)
Features: [Settings and appearance](../features/settings-and-appearance.md)

## Purpose

An index of 12 settings areas, in five groups. Each row pushes a [Settings group](settings-group.md) page. Details stay out of sight until the user opens a group (progressive disclosure).

**Decided (2026-11-03):** the Settings gear is on every root header (Today, Inbox, Projects, Habits). It pushes this screen. The tab bar hides.

## Layout (Observed in 3d)

Glass back button, the title "Settings", then grouped lists. Each row: icon, name, value, chevron.

| Group | Row | Icon | Value in the mockup |
| --- | --- | --- | --- |
| Planning | Day bands | sunrise | 6 · 12 · 6 |
| Planning | Scheduling | calendar-cog | Flexible |
| Planning | Protected time | shield | 3 |
| Planning | Energy | battery-medium | Off |
| Assistance | AI planning | sparkles | On |
| Assistance | Privacy & AI data | hand | On device first |
| Focus & alerts | Focus | timer | Timer |
| Focus & alerts | Notifications | bell | Quiet at 11 PM |
| Connections | Calendar | calendar | 2 calendars (Off when access is denied) |
| Connections | Inbox review | inbox | When I plan |
| App | Appearance | sun-moon | Dark |
| App | Data & backup | cloud | Synced |

A footer line: "Plan My Day 3.0". Use "Luna" and the app version.

**Assumption:** the Privacy & AI data value is "On device", because AI is on-device only (decided 2026-11-03).

## v3 gaps

- Replace the v2 single page with the index and the group pages (1d.10). Move the v2 rows into groups: Day bands, Timeline switches (Appearance › Today and Calendar), Focus switches (Focus), Suggestions (AI planning), Theme (Appearance).

## Interactions (built in 1b.5, v2)

- **Observed:** the switches toggle. "Show free time" off hides the free gap rows on Today.
- **Observed:** rows with a chevron have no destination in the mockup.
- **Decided (2026-10-31):** each band row pushes a list of start times in 15-minute steps, with a checkmark. A tap saves and goes back.
- **Assumption:** Theme pushes a choice list (Dark, Light, System) that works the same way.
- **Assumption:** the Calendars row shows the mockup values and has no destination until checkpoint 2.2 adds the calendar picker.

### Accessibility and iOS notes

- Use `Form` or `List` with `Toggle` and `NavigationLink`. Restyle to Noir.
- Store settings with `@AppStorage` until a persistence ADR says otherwise. **Assumption.**
- **Assumption:** switches use `LunaSwitchStyle`, a `ToggleStyle` on the native `Toggle`. The system switch keeps a white thumb, so it cannot show the dark "on" state (white track, black thumb).

## Intended differences (v2)

- Switch rows are about 56 pt tall. The 44 pt hit target of the switch sets the height.
- The icon box uses `surfaceTertiary` from `GroupedRow` (1a.5), not the Noir `surface-icon-container`.

## Open questions (v2)

- The theme and switch decisions are in [Settings and appearance](../features/settings-and-appearance.md#decisions). The Suggestions decision is in [Plan hub suggestions](../features/plan-my-day-suggestions.md#decisions).
- No settings question is open. See [open-questions.md](../open-questions.md).
