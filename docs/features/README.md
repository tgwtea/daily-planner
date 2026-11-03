# Feature specs

One file per behavior or workflow that the Plan My Day v3 mockup supports. Each spec separates **Observed**, **Assumption**, and **Unresolved** statements. See [docs/README.md](../README.md#statement-labels).

The mockup encodes most rules in the `<script data-dc-script>` block of `Plan My Day v3 App.dc.html`. The key rules are also in `Plan My Day v3 Handoff.dc.html`. The specs quote both. The sample day is Thursday, October 29, 2026 at 10:20 AM. The app keeps the v2 sample data (decided 2026-11-03).

| Feature | Screens | Status |
| --- | --- | --- |
| [Timeline and day bands](timeline-and-day-bands.md) | Today, Settings | Partial |
| [Block types](block-types.md) | Today, Block detail, Calendar | Planned |
| [Block completion and routines](block-completion-and-routines.md) | Today, Block detail, Plan hub, Quick review | Partial |
| [Anytime tasks](anytime-tasks.md) | Today | Partial |
| [Inbox scheduling](inbox-scheduling.md) | Inbox, Inbox drawer, Today | Partial |
| [Capture parsing](quick-add-parsing.md) | Capture | Partial |
| [Capture and organization](capture-and-organization.md) | Capture, Inbox | Planned |
| [Inbox review](inbox-review.md) | Quick review, Inbox, Plan hub | Planned |
| [Block editing](block-editing.md) | Block detail | Planned |
| [Focus and Live Activity](focus-and-live-activity.md) | Today, Focus, Live Activity | Planned |
| [Running-late nudge](running-late-nudge.md) | Today, Before and after | Planned |
| [Habits](habits.md) | Today, Habits | Partial |
| [Projects and areas](projects-and-areas.md) | Projects, Project detail, Smart list | Partial |
| [Calendar views and events](calendar-views-and-events.md) | Calendar, Today, Block detail, Settings | Planned |
| [Plan hub suggestions](plan-my-day-suggestions.md) | Plan hub, Today, Settings | Planned |
| [Notifications](notifications.md) | Settings, Inbox, Capture | Planned |
| [Onboarding](onboarding.md) | Onboarding, Today | Planned |
| [Settings and appearance](settings-and-appearance.md) | Settings, all | Partial |

## Spec template

```markdown
# <Feature name>

Status: Planned
Screens: <links>

## Purpose
## Observed
## Assumptions
## Decisions
## Unresolved
## Edge cases
## Related
```
