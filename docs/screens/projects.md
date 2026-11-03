# Projects

Status: Partial (built on v2 in 1b.4 and 1b.6; the v3 gaps are listed below)
Code: `Luna/Features/Projects/ProjectsScreen.swift`, `AreaSection.swift`, `ProjectRow.swift`, `ProjectsEmptyView.swift`, `NewProjectSheet.swift`, `NewAreaSheet.swift`
Artboards: 3ab
Features: [Projects and areas](../features/projects-and-areas.md)

## Purpose

Show work outside today: smart lists and projects grouped by area.

## Layout (top to bottom)

1. Title "Projects" (34 pt bold) and a 44 pt glass Settings gear.
2. **v3:** a search field "Search tasks, projects and notes" (search icon).
3. Grouped list of smart lists. Each row: a 32 pt icon box, a name, a count, a chevron.
   - Upcoming (calendar-range) 12
   - Anytime (layers) 8
   - Someday (archive) 14
   - Logbook (book-check), no count
4. One section per area. Header: area icon + name (15 pt semibold, secondary). v3 sample: "School" (graduation-cap) and "Personal" (house).
5. Under each area, a grouped list of projects. Each row: a 24 pt progress ring in the project color, a name (17 pt semibold), a meta line (v2: "Due Nov 14", "No date"; v3 also "Next: Drag rows onto the timeline", "Problem set 6 due Mon", "Added Oct 30"), and a trailing count of open tasks.

## Sample data (Observed in v2; the app keeps it, decided 2026-11-03)

| Area | Project | Color | Progress | Meta | Open |
| --- | --- | --- | --- | --- | --- |
| Work | Sync engine | Slate | 60% | Due Nov 14 | 5 |
| Work | Q4 planning | Sand | 25% | Due Nov 6 | 3 |
| Work | Hiring loop | Sage | 80% | No date | 2 |
| Personal | Lisbon trip | Plum | 30% | Dec 18 – 27 | 4 |
| Personal | Home | Sage | 50% | No date | 6 |
| Personal | Health | Rose | 70% | Ongoing | 2 |

## Intended differences

- **Assumption:** a 44 pt glass "+" button next to the title opens the New Project and New Area menu. The mockup has no button.
- **Decided (2026-10-31):** progress, open counts, and smart list counts come from items, not fixed values. The mockup values for Sync engine (60%, 5 open), Lisbon trip (30%, 4 open), and Health (70%, 2 open) have no whole-number item counts. The app shows 58%, 33%, and 71%.

## Navigation and interactions

- **Observed:** rows look tappable (chevrons, buttons). The mockup gives them no action.
- **Decided (2026-10-30):** a project row pushes a project detail screen: a progress ring header, notes, then items grouped as Scheduled, Anytime, and Done, and an add button. A smart list row pushes its list. A toolbar "+" menu has New Project and New Area. See [Projects and areas](../features/projects-and-areas.md#decisions).
- **Implemented (1b.6):** rows use `NavigationLink(value:)` with `AppRoute.project` and `AppRoute.smartList`. See [Project detail](project-detail.md) and [Smart list](smart-list.md).
- **Assumption:** New Project is a medium sheet with a name field, the five block colors, and an area picker ("None" first). New Area is a medium sheet with a name field and eight SF Symbol icons. Save is off while the name is empty. A new project or area goes at the end.

## States

- **Assumption:** with no projects, show the smart lists and an empty state with a "New Project" button. The mockup has no empty state.
- **Assumption:** an area with no projects shows no section. Projects with no area go in a last section with no header.

## Accessibility and iOS notes

- Use `List` with `.insetGrouped` style restyled to Noir, or a custom grouped container.
- The progress ring needs a text value for VoiceOver ("60 percent").

## Artboard comparison (2026-10-31, v2)

Checked in the iPhone 17 simulator (iOS 27.0), dark and light, after 1b.6. The screen matches 2l, except the "+" button next to the title (intended: the decided toolbar menu).

## v3 gaps

- Gear and search field (1d.8). **Assumption:** search filters tasks, projects, and notes by title. The mockup has no results state.
- Meta line shows the next step for a rich project (1d.8).

## Open questions

None.
