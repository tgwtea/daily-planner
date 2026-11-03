# Onboarding

Status: Planned
Screens: [Onboarding](../screens/onboarding.md), [Today](../screens/today.md)

## Purpose

Get a new user to a usable Today in three steps, with no account and no forced choices.

## Observed (v3, 3am and 3an)

- Three steps: welcome with three points, the day bands, and calendar access.
- "Allow access" asks for calendar access and opens Today. "Not now" opens Today with calendar access off.
- First run on Today (3an): no habits strip, no Inbox items. The empty state says "Start with one block" with "Add block" and "Capture".

## Assumptions

- Onboarding shows once. A stored flag marks it done.
- Band changes in step 2 write to the band schedule (`BandScheduleStorage`).
- The DEBUG sample data skips onboarding.

## Decisions

- **Decided (2026-11-03):** onboarding is in v1 scope. Calendar access is asked in step 3.

## Related

[Calendar views and events](calendar-views-and-events.md), [Settings](settings-and-appearance.md).
