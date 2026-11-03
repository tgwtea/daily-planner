# Settings group

Status: Planned
Artboards: 3ah (Calendar), 3al (AI planning, light)
Features: [Settings and appearance](../features/settings-and-appearance.md)

## Purpose

One page per settings area. Grouped lists with switches, values, and checks, with a footer that explains each rule in plain words.

## Layout

Glass back button ("Settings"), a small "Settings" label, the group title, then grouped lists with headers and footers. Row kinds: switch, value with chevron (optional icon), and check (calendar choice). The full list of groups, rows, and defaults is in [Settings and appearance](../features/settings-and-appearance.md#v3-settings-groups).

## States

- **Calendar, access denied:** a card with calendar-off, "Calendar access is off", "Events aren't shown and nothing syncs. Your blocks are safe here, and synced ones stay as local-only until access is back.", and "Open iOS Settings". The groups hide.

## Interactions

- A switch saves at once. A value row pushes a choice list. A check row toggles the calendar.

## Accessibility and iOS notes

- `List` with `Toggle` and `NavigationLink`, restyled to Noir. Switches use `LunaSwitchStyle`.

## Open questions

None.
