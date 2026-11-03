# Onboarding

Status: Planned
Artboards: 3am (and 3an for the first Today)
Features: [Onboarding](../features/onboarding.md)

## Purpose

Explain the app in three short steps on first launch, set the day bands, and ask for calendar access.

## Layout

A full-screen page with three progress dots, a step body, and a full-width primary button ("Continue", then "Allow access" on step 3).

1. **Welcome:** "Your whole day, in one place." and "Plan My Day keeps your schedule, tasks and routines on one timeline, so you can see what's now, what's next, and where everything else went." Three points: "See now and next" (Your day as a timeline, with free time shown), "Capture without sorting" (Save a thought in seconds. Organize later, or never.), "Plans you approve" (Suggestions stay drafts until you say yes).
2. **Day bands:** "When does your day run?", "Your timeline is split into three bands. You can change these any time.", and a grouped list Morning 6:00 AM, Afternoon 12:00 PM, Night 6:00 PM (each pushes a time choice).
3. **Calendar:** calendar icon, "Show your calendar?", "Events appear on your timeline as fixed time. Plan My Day won't change them. You can choose calendars, or sync your own blocks later." A ghost "Not now" under the primary button.

Use "Luna" in place of "Plan My Day".

## Navigation

- **Assumption:** a full-screen cover on the first launch only. It ends on [Today](today.md) in the first-run state (3an).

## Interactions

- "Allow access" asks for EventKit access, then opens Today. "Not now" opens Today with calendar access off (the banner shows).

## Open questions

None.
