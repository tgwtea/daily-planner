# Open questions

Each item is a decision that the mockup does not make. Resolve each one with the user before you implement the related behavior. When it is resolved, record the answer in the feature spec (or in an ADR for a technical decision) and remove it here.

Many P1 items have a recommended default in the checkpoint that needs them. See [roadmap.md](roadmap.md#how-to-run-a-checkpoint) for when an agent may apply a default.

Priority: **P1** blocks the first related implementation. **P2** can wait for a later pass.

## Naming

- **P2.** The app name is Luna. The design files say "Plan My Day". Does the "Plan my day" sheet and the "Plan" button keep that name?

## Navigation

- **P1.** The design puts a separate primary "+" circle beside a five-tab glass bar. Native iOS 26 `TabView` has no exact slot for this. Choose: a custom glass button over the system tab bar, or a fully custom tab bar.
- **P2.** Edit block and Focus: full-screen cover, push, or sheet?

## Timeline

- **P1.** The code bands start at 0:00, 12:00, and 18:00. Settings says 6:00 AM, 12:00 PM, 6:00 PM. Which band holds a block before the Morning start?
- **P2.** Can blocks cross midnight? Can blocks overlap, and how do overlaps look?
- **P2.** Does the week strip page to other weeks?
- **P2.** Are the empty-day ghost times (8:00, 1:00, 7:00) fixed?

## Capture

- **P1.** Quick add without a time goes to the Inbox, even with a day word. Should "pay bill tomorrow" go to tomorrow's Anytime instead?
- **P1.** Which "+" button pre-fills what: band "+" → that band, Anytime "+" → Anytime, tab bar "+" → nothing?
- **P2.** Weekday names, dates, 24-hour times, and other languages in the parser.
- **P2.** What do the Date, Time, Duration, Repeat, and Checklist tools open?

## Inbox

- **P1.** Feedback when no free slot exists.
- **P2.** Drag details: snap step, auto-scroll, drops on a block, drops into a short gap.
- **P2.** Reorder, edit, and delete Inbox tasks.
- **P2.** Are tags the same as projects?

## Editing

- **P1.** Live edits (mockup) or a draft with Save and Close (iOS norm)?
- **P1.** How does a user edit the title or delete a block?
- **P2.** Routine versus task with a checklist: what makes the difference?
- **P2.** Repeat and Alert options.
- **P2.** Full icon set or search beyond 12 icons.

## Focus

- **P2.** Does +5 extend the block on the timeline and push later blocks?
- **P2.** At zero: mark done, prompt, or overrun?
- **P2.** Focus on a block that is not active.
- **P2.** Contents of the "More" menu.
- **P2.** Expanded and minimal Dynamic Island layouts.

## Habits

- **P1.** How to create, edit, archive, and reorder habits.
- **P2.** Schedules (some weekdays only).
- **P2.** Which habit the history card shows.
- **P2.** HealthKit input for Water or Walk.

## Projects

- **P1.** What each smart list (Upcoming, Anytime, Someday, Logbook) contains.
- **P1.** The project detail screen.
- **P2.** How to create areas and projects.

## Calendar

- **P1.** Calendar permission flow and the denied state.
- **P2.** Default calendars. Paging. Tap on a calendar block. All-day events.

## Plan my day

- **P1.** Deterministic rule or AI? The mockup only says "Suggestion". AI needs a product decision and an ADR.
- **P2.** How many tasks to propose and in what order.
- **P2.** The Plan button when Suggestions is off.

## Settings

- **P2.** Theme choices: Dark, Light, and System?
- **P2.** What "Show calendar events" off and "Scroll to now" off change.

## Data and platform

- **P1.** Persistence: SwiftData, Core Data, or files. Needs an ADR before the first saved data.
- **P2.** iCloud sync.
- **P2.** Notifications for block alerts.
- **P2.** iPad and landscape support.
- **P2.** Localization beyond English.
