# Roadmap

This file is the plan to build and ship Luna. Agents execute it one checkpoint at a time. It is also the completion log.

## How to run a checkpoint

A prompt such as "Phase 1b checkpoint 3: Habits" means checkpoint `1b.3` below. Do these steps in order:

1. Find the checkpoint by its ID. Read its **Read** list in full. Read [AGENTS.md](../AGENTS.md) if you did not read it in this session.
2. Check **Depends on**. Each dependency must have the status `Done` in the [completion log](#completion-log). If one is not done, stop. Tell the user which checkpoint must come first.
3. Check **Decisions**. Each decision links to [open-questions.md](open-questions.md).
   - If the question has an answer in the feature spec, use that answer.
   - If not, ask the user. Give the **Default** as your recommendation.
   - If the user cannot answer, or the prompt says "use defaults", use the Default. Record it as an **Assumption** in the feature spec. Remove the question from `open-questions.md`, or mark it "Default applied in 1b.3".
4. Set the checkpoint row to `In progress` in the completion log. Fill in your agent name.
5. Build only what **Build** lists. Do not start the next checkpoint.
6. Meet every item in **Done when**. Run the [standard checks](#standard-checks).
7. Update the docs: set each touched spec to `Status: Implemented` or `Partial`, name the main source files in the spec, and add new terms to [docs/README.md](README.md#terms).
8. Commit on a branch, or on `main` if the user says so. Use the message `<ID>: <title>`, for example `1b.3: Habits`.
9. Set the row to `Done`. Fill in the date and the short commit hash. Commit the log change.
10. Report to the user: what is done, what is not verified, and the next checkpoint ID.

If a checkpoint is too big for one session, finish a coherent part, commit it, and set the row to `Partial` with a note. The next agent continues from the note.

Checkpoints marked **Human gate** need an action that only the user can take (an account, a payment, a signature, a store submission). The agent prepares everything, then asks the user to do the gated step. The agent does not do it.

## Standard checks

Every checkpoint ends with these checks, unless it says otherwise:

- `xcodebuild … build` succeeds with no new warnings.
- `xcodebuild … test` passes on an iOS 26+ simulator. From 1a.1 on, a skipped test run is a failure, not a note.
- New logic without UI has Swift Testing unit tests.
- Each new view has a `#Preview` in dark and light appearance.
- UI matches the screen spec and the [design reference](design/design-reference.md). Take a simulator screenshot in dark and light appearance. Compare it with the artboard.
- VoiceOver labels exist for every new control.
- The doc link check passes. All relative links in `*.md` files resolve.
- No mockup HTML, CSS, or JavaScript is copied into the app.

## Phases

| Phase | Goal | Exit result |
| --- | --- | --- |
| 0 | Foundation | Project builds. Docs exist. |
| 1a | App foundations | Tokens, model, in-memory store, tab shell, shared components |
| 1b | Main tabs | Today, Inbox, Habits, Projects, Settings work on in-memory data |
| 1c | Flows and sheets | Quick add, drawer, edit, plan, calendar, focus work |
| 2 | Platform | Data persists. Calendar events, Live Activity, notifications work. |
| 3 | Quality | Accessibility, UI tests, performance, polish |
| 4 | Ship | TestFlight build, then App Store release |

The in-memory store in 1a lets 1b and 1c ship real behavior before the persistence decision in 2.1. Keep the store behind one `@Observable` type so that 2.1 replaces only its storage.

---

## Phase 0: Foundation

### 0.1 Repository and Xcode project
Done. See [ADR-0001](adr/0001-native-swiftui-foundation.md).

### 0.2 Durable documentation
Done. This file, the specs, the design reference, and the open questions.

---

## Phase 1a: App foundations

### 1a.1 Test environment
- **Depends on:** 0.1
- **Read:** [README.md](../README.md), [AGENTS.md](../AGENTS.md#validation)
- **Build:** Make sure an iOS 26+ simulator runtime exists (`xcrun simctl list runtimes`). If none exists, ask the user to approve `xcodebuild -downloadPlatform iOS`. This is a large download. Create a simulator. Write the exact test command for this machine in `README.md`.
- **Done when:** `xcodebuild test` runs the smoke test and it passes.

### 1a.2 Design tokens
- **Depends on:** 1a.1
- **Read:** [design-reference.md](design/design-reference.md) (Color, Block colors, Typography, Spacing, Shape, Materials, Motion)
- **Build:** `Luna/Shared/Design/`. Semantic colors as asset catalog color sets with dark and light values, or as `Color` extensions. Block colors as an enum `BlockColor` (rose, slate, sage, sand, plum) with display names and the ink color. Spacing, radius, and motion constants. Font helpers that scale with Dynamic Type. Add a token preview screen in `#Preview` only, not in the app.
- **Done when:** previews show every token in both themes. A unit test checks that `BlockColor.allCases` has five cases in the documented order.

### 1a.3 Domain model and in-memory store
- **Depends on:** 1a.2
- **Read:** all files in [features/](features/README.md) (the Observed data sections), [architecture/overview.md](architecture/overview.md)
- **Build:** `Luna/Shared/Model/`. Value types: `Block` (kind task, routine, event; start `Date`; duration; icon; color; steps; done), `Step`, `Band`, `AnytimeTask`, `InboxItem`, `Habit` (value, goal, history), `Area`, `Project`. One `@Observable` store type that holds them, with intents (toggle done, toggle step, log habit, schedule an Inbox item, and so on). Sample data that matches the mockup (Thursday, October 29, 2026, 10:20 AM), shown only in previews and a debug launch argument. Pure functions: band of a time, pill height, free gaps, duration format.
- **Decisions:** band ranges ([Timeline](open-questions.md#timeline)). **Default:** bands start at the Settings values (6 AM, 12 PM, 6 PM). A block before 6 AM goes in Morning.
- **Done when:** unit tests cover band assignment, pill height, gap detection (20 min rule), and duration format.

### 1a.4 App shell and navigation
- **Depends on:** 1a.3
- **Read:** [screens/README.md](screens/README.md), [design-reference.md](design/design-reference.md#native-swiftui-notes)
- **Build:** Root `TabView` with Today, Inbox, Projects, Habits, Settings (each an empty titled placeholder view). The floating "+" button next to the tab bar opens an empty Quick add sheet. A navigation route type for Calendar, Edit block, and Focus. Theme from `@AppStorage`. Replace `ContentView`.
- **Decisions:** the "+" button placement ([Navigation](open-questions.md#navigation)). **Default:** the system iOS 26 tab bar plus a custom glass circle button at the bottom trailing edge.
- **Done when:** all five tabs switch. The "+" button opens and closes the sheet. The tab bar hides on pushed screens.

### 1a.5 Shared components
- **Depends on:** 1a.4
- **Read:** [design-reference.md](design/design-reference.md#reusable-patterns)
- **Build:** `Luna/Shared/Components/`: block pill, check circle, capsule chip button, round add button, colored icon tile, progress ring, grouped list container and row, large title header. Each with previews and accessibility labels.
- **Done when:** previews match the pattern table. The press scale and Reduce Motion behavior work.

---

## Phase 1b: Main tabs

### 1b.1 Today
- **Depends on:** 1a.5
- **Read:** [screens/today.md](screens/today.md), [features/timeline-and-day-bands.md](features/timeline-and-day-bands.md), [features/block-completion-and-routines.md](features/block-completion-and-routines.md), [features/anytime-tasks.md](features/anytime-tasks.md)
- **Build:** header, week strip, Anytime section, three bands with collapse, block rows, routine rows, free gap rows, active block with now line and remaining time, day footer, empty-day state, Inbox pill (count only, no drawer yet). Scroll to now on open. The habit strip is a placeholder until 1b.3. The Plan and Calendar buttons do nothing yet.
- **Decisions:** header "+" target ([Capture](open-questions.md#capture)). **Default:** the header "+" opens Quick add empty. A band "+" pre-fills a time in that band.
- **Done when:** artboards 2b, 2c, 2e, and 2f match. Toggle done, toggle steps, collapse, and day selection work. Unit tests cover the active-block and progress math.

### 1b.2 Inbox
- **Depends on:** 1b.1
- **Read:** [screens/inbox.md](screens/inbox.md), [features/inbox-scheduling.md](features/inbox-scheduling.md)
- **Build:** the Inbox tab list, swipe actions to place in a band, the empty state, the slot search function.
- **Decisions:** no-slot feedback ([Inbox](open-questions.md#inbox)). **Default:** a short inline message "No free time in Morning" and a warning haptic.
- **Done when:** artboard 2k matches. Unit tests cover the slot search: band start, 7 AM floor, now rounded up to 15 min, overlap, no fit.

### 1b.3 Habits
- **Depends on:** 1b.1
- **Read:** [screens/habits.md](screens/habits.md), [features/habits.md](features/habits.md), [screens/today.md](screens/today.md) (habit strip)
- **Build:** the Habits tab (history card with heatmap and stats, habit cards with week row and streak), and the habit strip on Today. Logging from both places.
- **Decisions:** create and edit habits ([Habits](open-questions.md#habits)). **Default:** out of scope for 1b.3. Use the sample habits. Add a later checkpoint for habit management.
- **Done when:** artboard 2m and the Today habit strip match. Unit tests cover log and reset, streak, and month percent.

### 1b.4 Projects
- **Depends on:** 1a.5
- **Read:** [screens/projects.md](screens/projects.md), [features/projects-and-areas.md](features/projects-and-areas.md)
- **Build:** smart list rows, areas, project rows with progress rings. Display only.
- **Decisions:** smart list and project destinations ([Projects](open-questions.md#projects)). **Default:** rows show but do not navigate. Leave the spec `Partial`.
- **Done when:** artboard 2l matches.

### 1b.5 Settings
- **Depends on:** 1a.4
- **Read:** [screens/settings.md](screens/settings.md), [features/settings-and-appearance.md](features/settings-and-appearance.md)
- **Build:** all groups and switches with `@AppStorage`. Band start pickers. Theme choice. Wire "Show free time" to Today. Calendars row shows a placeholder until 2.2.
- **Decisions:** theme options ([Settings](open-questions.md#settings)). **Default:** Dark, Light, System. Dark is the default.
- **Done when:** artboard 2n matches. The theme and free-time switches change the app at once.

---

## Phase 1c: Flows and sheets

### 1c.1 Quick add
- **Depends on:** 1b.2
- **Read:** [screens/quick-add.md](screens/quick-add.md), [features/quick-add-parsing.md](features/quick-add-parsing.md)
- **Build:** the parser type, the sheet with live chips, color cycle, icon cycle, save rules.
- **Decisions:** no-time items with a day word ([Capture](open-questions.md#capture)). **Default:** follow the mockup. Send them to the Inbox.
- **Done when:** artboard 2g matches. Unit tests cover every example and edge case in the feature spec.

### 1c.2 Inbox drawer
- **Depends on:** 1c.1
- **Read:** [screens/inbox-drawer.md](screens/inbox-drawer.md), [features/inbox-scheduling.md](features/inbox-scheduling.md)
- **Build:** the drawer sheet from the Inbox pill and "Open Inbox". Tap to place. Drag to a free gap with a drop target.
- **Decisions:** drag details ([Inbox](open-questions.md#inbox)). **Default:** snap to 15 min, drop only into a gap that fits, no drop on a block.
- **Done when:** artboard 2d matches. Tap and drag both schedule.

### 1c.3 Edit block
- **Depends on:** 1b.1
- **Read:** [screens/edit-block.md](screens/edit-block.md), [features/block-editing.md](features/block-editing.md)
- **Build:** the editor with hero, duration chips, detail rows (Date and Starts with pickers), color, icon, checklist with add step, title edit, delete.
- **Decisions:** live edit or draft, title and delete ([Editing](open-questions.md#editing)). **Default:** draft with Save and Close. Tap the title to edit it. A "Delete block" row at the bottom with a confirmation.
- **Done when:** artboard 2h matches. Save commits and Close discards (or live edit if the user chose it).

### 1c.4 Plan my day
- **Depends on:** 1c.2
- **Read:** [screens/plan-my-day.md](screens/plan-my-day.md), [features/plan-my-day-suggestions.md](features/plan-my-day-suggestions.md)
- **Build:** the suggestion sheet from the Plan button, with selection and accept.
- **Decisions:** rule or AI ([Plan my day](open-questions.md#plan-my-day)). **Default:** the deterministic rule in the feature spec. No AI.
- **Done when:** artboard 2q matches. Unit tests cover the proposal rule.

### 1c.5 Calendar
- **Depends on:** 1b.1
- **Read:** [screens/calendar.md](screens/calendar.md), [features/calendar-views-and-events.md](features/calendar-views-and-events.md)
- **Build:** the pushed Calendar screen with Day, 3 days, Week, and Month views, now line, month agenda. Data from the store only (events come in 2.2).
- **Decisions:** paging and block taps ([Calendar](open-questions.md#calendar)). **Default:** swipe pages by the view length. Tap a task block to open Edit block.
- **Done when:** artboards 2o and 2p match.

### 1c.6 Focus
- **Depends on:** 1b.1
- **Read:** [screens/focus.md](screens/focus.md), [features/focus-and-live-activity.md](features/focus-and-live-activity.md)
- **Build:** the Focus screen with ring, timer, +5, pause, done. A session model based on an end date. The Focus button and timer on Today use it.
- **Decisions:** +5 and zero behavior ([Focus](open-questions.md#focus)). **Default:** +5 extends only the session. At zero, play feedback and show "Done" as the main action. Do not auto-complete.
- **Done when:** artboard 2i matches. Unit tests cover pause, resume, +5, and progress.

---

## Phase 2: Platform

### 2.1 Persistence
- **Depends on:** 1c.6
- **Read:** [architecture/overview.md](architecture/overview.md), [adr/README.md](adr/README.md)
- **Build:** write ADR-0002 for the storage choice. Move the store to it. Add migration-safe model versioning. Remove the sample data from release builds.
- **Decisions:** storage and sync ([Data and platform](open-questions.md#data-and-platform)). **Default:** SwiftData, local only. iCloud sync later.
- **Done when:** all data survives an app relaunch. Unit tests use an in-memory container.

### 2.2 Calendar events
- **Depends on:** 2.1
- **Read:** [features/calendar-views-and-events.md](features/calendar-views-and-events.md), [screens/settings.md](screens/settings.md)
- **Build:** ADR-0003 for EventKit. Read-only events on Today and Calendar. Permission request, denied state, calendar picker in Settings. Usage description string.
- **Decisions:** permission flow ([Calendar](open-questions.md#calendar)). **Default:** ask when the user turns on Apple Calendar in Settings or on first open of Calendar.
- **Done when:** events from the simulator calendar show. A denied permission shows a clear state with a link to Settings.

### 2.3 Live Activity
- **Depends on:** 1c.6
- **Read:** [screens/live-activity.md](screens/live-activity.md), [features/focus-and-live-activity.md](features/focus-and-live-activity.md)
- **Build:** ADR-0004 for the widget extension. Widget extension target, ActivityKit attributes, lock screen and Dynamic Island views, App Intents for pause, +5, done. The Settings switch controls it.
- **Done when:** artboard 2j matches on a simulator lock screen. The buttons control the session.

### 2.4 Alerts, haptics, sound
- **Depends on:** 2.1
- **Read:** [screens/settings.md](screens/settings.md), [features/block-editing.md](features/block-editing.md)
- **Build:** local notifications for block alerts, haptics on key actions, the end-of-block sound. Repeat rules if the user decided them.
- **Decisions:** Repeat and Alert options ([Editing](open-questions.md#editing)). **Default:** Alert choices None, At start, 5, 10, 15 min before. Repeat choices Never, Daily, Weekdays, Weekly.
- **Done when:** an alert fires in the simulator. The Haptics and Sound switches work.

---

## Phase 3: Quality

### 3.1 Accessibility audit
- **Depends on:** 2.4
- **Build:** VoiceOver pass on every screen. Dynamic Type up to AX5. Increase Contrast, Reduce Motion, Reduce Transparency. Fix all issues.
- **Done when:** Xcode Accessibility Inspector shows no issues on any screen. Each screen spec has an "Accessibility verified" note with the date.

### 3.2 UI tests
- **Depends on:** 3.1
- **Build:** a `LunaUITests` target. Record it in a new ADR, because ADR-0001 says there is no UI test target. Tests for: quick add to timeline, Inbox place, complete a block, log a habit, Focus done.
- **Done when:** UI tests pass in the standard test command.

### 3.3 Visual polish and fidelity
- **Depends on:** 3.1
- **Build:** compare every artboard with the app in both themes. Fix spacing, type, and color drift. Check the Today scroll performance in Instruments with three times the sample day's blocks. There must be no hitches.
- **Done when:** a fidelity table in each screen spec lists every artboard as matched or as an intended difference.

### 3.4 Localization readiness
- **Depends on:** 3.1
- **Build:** all strings in a String Catalog. Locale-aware time and duration formats. English only is fine.
- **Done when:** a pseudo-language run shows no hard-coded strings.

---

## Phase 4: Ship

### 4.1 App identity
- **Depends on:** 3.3
- **Build:** app icon (ask the user for the artwork or approval of a generated draft), display name, launch screen color, version 1.0.0.
- **Done when:** the icon shows on the simulator home screen.

### 4.2 Privacy and compliance
- **Depends on:** 4.1
- **Build:** privacy manifest (`PrivacyInfo.xcprivacy`), all usage description strings, the data-collection answers for App Store Connect in `docs/release/privacy.md`, export compliance answer.
- **Done when:** an archive builds and `xcodebuild -exportArchive` validation passes locally, or the only failure is signing.

### 4.3 Signing and TestFlight — Human gate
- **Depends on:** 4.2
- **Build (agent):** release scheme settings, `docs/release/checklist.md` with each step, App Store Connect metadata drafts (name, subtitle, description, keywords, screenshots from the simulator).
- **Human:** set the Apple Developer team, create the app record, upload the build, invite testers.
- **Done when:** the user confirms a TestFlight build is installable.

### 4.4 App Store release — Human gate
- **Depends on:** 4.3
- **Build (agent):** fix every TestFlight issue the user reports. Final screenshots and metadata.
- **Human:** submit for review and release.
- **Done when:** the user confirms the app is live.

---

## Completion log

Agents update this table. Use your agent name and model, for example "Claude Code (Opus 5.5)" or "Codex (GPT-5)". Status values: `Not started`, `In progress`, `Partial`, `Done`, `Blocked`.

| ID | Title | Status | Completed by | Date | Commit | Notes |
| --- | --- | --- | --- | --- | --- | --- |
| 0.1 | Repository and Xcode project | Done | Claude Code (Opus 5.5) | 2026-10-30 | a1f6e98 | Build and test compile pass. Tests not run: no iOS 26 runtime. |
| 0.2 | Durable documentation | Done | Claude Code (Opus 5.5) | 2026-10-30 | a1f6e98 | |
| 1a.1 | Test environment | Not started | | | | |
| 1a.2 | Design tokens | Not started | | | | |
| 1a.3 | Domain model and in-memory store | Not started | | | | |
| 1a.4 | App shell and navigation | Not started | | | | |
| 1a.5 | Shared components | Not started | | | | |
| 1b.1 | Today | Not started | | | | |
| 1b.2 | Inbox | Not started | | | | |
| 1b.3 | Habits | Not started | | | | |
| 1b.4 | Projects | Not started | | | | |
| 1b.5 | Settings | Not started | | | | |
| 1c.1 | Quick add | Not started | | | | |
| 1c.2 | Inbox drawer | Not started | | | | |
| 1c.3 | Edit block | Not started | | | | |
| 1c.4 | Plan my day | Not started | | | | |
| 1c.5 | Calendar | Not started | | | | |
| 1c.6 | Focus | Not started | | | | |
| 2.1 | Persistence | Not started | | | | |
| 2.2 | Calendar events | Not started | | | | |
| 2.3 | Live Activity | Not started | | | | |
| 2.4 | Alerts, haptics, sound | Not started | | | | |
| 3.1 | Accessibility audit | Not started | | | | |
| 3.2 | UI tests | Not started | | | | |
| 3.3 | Visual polish and fidelity | Not started | | | | |
| 3.4 | Localization readiness | Not started | | | | |
| 4.1 | App identity | Not started | | | | |
| 4.2 | Privacy and compliance | Not started | | | | |
| 4.3 | Signing and TestFlight | Not started | | | | Human gate |
| 4.4 | App Store release | Not started | | | | Human gate |

## Changing the roadmap

- Add a checkpoint when a resolved question creates new work (for example habit management). Give it the next free number in its phase. Do not renumber existing checkpoints.
- Mark a removed checkpoint `Deprecated` in the log. Do not delete the row.
