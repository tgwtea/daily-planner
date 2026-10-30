# Projects

Status: Planned
Artboards: 2l
Features: [Projects and areas](../features/projects-and-areas.md)

## Purpose

Show work outside today: smart lists and projects grouped by area.

## Layout (top to bottom)

1. Title "Projects" (34 pt bold).
2. Grouped list of smart lists. Each row: a 32 pt icon box, a name, a count, a chevron.
   - Upcoming (calendar-range) 12
   - Anytime (layers) 8
   - Someday (archive) 14
   - Logbook (book-check), no count
3. One section per area. Header: area icon + name (15 pt semibold, secondary), for example "Work" (briefcase) and "Personal" (house).
4. Under each area, a grouped list of projects. Each row: a 24 pt progress ring in the project color, a name (17 pt semibold), a meta line ("Due Nov 14", "Dec 18 – 27", "No date", "Ongoing"), and a trailing count of open tasks.

## Sample data (Observed)

| Area | Project | Color | Progress | Meta | Open |
| --- | --- | --- | --- | --- | --- |
| Work | Sync engine | Slate | 60% | Due Nov 14 | 5 |
| Work | Q4 planning | Sand | 25% | Due Nov 6 | 3 |
| Work | Hiring loop | Sage | 80% | No date | 2 |
| Personal | Lisbon trip | Plum | 30% | Dec 18 – 27 | 4 |
| Personal | Home | Sage | 50% | No date | 6 |
| Personal | Health | Rose | 70% | Ongoing | 2 |

## Navigation and interactions

- **Observed:** rows look tappable (chevrons, buttons). The mockup gives them no action.
- **Unresolved:** the destination of every row. See [open-questions.md](../open-questions.md#projects).

## States

- **Assumption:** with no projects, show the smart lists and an empty state that says how to add a project. The mockup has no empty state.

## Accessibility and iOS notes

- Use `List` with `.insetGrouped` style restyled to Noir, or a custom grouped container.
- The progress ring needs a text value for VoiceOver ("60 percent").

## Open questions

See [open-questions.md](../open-questions.md#projects).
