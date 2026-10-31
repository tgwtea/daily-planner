# Feature specs

One file per behavior or workflow that the Plan My Day v2 mockup supports. Each spec separates **Observed**, **Assumption**, and **Unresolved** statements. See [docs/README.md](../README.md#statement-labels).

The mockup encodes most rules in the `<script data-dc-script>` block of `Plan My Day v2 App.dc.html`. The specs quote those rules. The sample day is Thursday, October 29, 2026 at 10:20 AM.

| Feature | Screens | Status |
| --- | --- | --- |
| [Timeline and day bands](timeline-and-day-bands.md) | Today, Settings | Implemented |
| [Block completion and routines](block-completion-and-routines.md) | Today, Edit block | Partial |
| [Anytime tasks](anytime-tasks.md) | Today | Partial |
| [Inbox scheduling](inbox-scheduling.md) | Inbox, Inbox drawer, Today | Partial |
| [Quick add parsing](quick-add-parsing.md) | Quick add | Implemented |
| [Block editing](block-editing.md) | Edit block | Planned |
| [Focus and Live Activity](focus-and-live-activity.md) | Today, Focus, Live Activity | Planned |
| [Habits](habits.md) | Today, Habits | Partial |
| [Projects and areas](projects-and-areas.md) | Projects, Project detail, Smart list | Implemented |
| [Calendar views and events](calendar-views-and-events.md) | Calendar, Today, Settings | Planned |
| [Plan my day suggestions](plan-my-day-suggestions.md) | Plan my day, Settings | Planned |
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
