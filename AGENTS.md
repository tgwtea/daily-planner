# AGENTS.md

This file is the single source of truth for every coding agent in this repository. `CLAUDE.md` imports this file and adds Claude Code notes only. If you change a shared rule, change it here.

## Project

Luna is a native iOS time-blocking day planner, built with SwiftUI. The visual and interaction reference is a Claude Design prototype named "Plan My Day v3". See [docs/design/design-reference.md](docs/design/design-reference.md).

**Decided (2026-11-03):** v3 is the design source of truth. It replaces v2. Where an older decision conflicts with v3, v3 wins, and the spec records the change. Code built before 2026-11-03 follows v2. Roadmap Phase 1d brings it to v3.

Current state: Phases 1a and 1b and checkpoint 1c.1 are done, on the v2 design. The in-memory `PlannerStore` holds all data. Check the [completion log](docs/roadmap.md#completion-log) for the exact state. A spec has the status `Planned` until code implements it.

## Roadmap and checkpoints

All work follows [docs/roadmap.md](docs/roadmap.md). A prompt such as "Phase 1b checkpoint 3: Habits" means roadmap checkpoint `1b.3`. Follow the "How to run a checkpoint" steps in that file exactly. Mark the checkpoint in its completion log with your agent name, the date, and the commit. If a prompt names no checkpoint, find the first checkpoint that is not `Done` and ask the user to confirm it.

## Read before you change code

1. Read [docs/README.md](docs/README.md). It indexes all documentation and defines the status labels and terms.
2. Read the screen spec in [docs/screens/](docs/screens/README.md) for each screen you touch.
3. Read the feature spec in [docs/features/](docs/features/README.md) for each behavior you touch.
4. Read the ADRs in [docs/adr/](docs/adr/README.md). Do not contradict an accepted ADR without a new ADR.
5. Check [docs/open-questions.md](docs/open-questions.md). Do not silently resolve an open question in code. Ask the user, or record your assumption in the spec.

## Architecture rules

- Use SwiftUI and Apple frameworks only. Add a third-party package only with a new ADR.
- Organize code by feature: `Luna/Features/<Feature>/`. Put code that two or more features use in `Luna/Shared/`. See [docs/architecture/repository-map.md](docs/architecture/repository-map.md).
- Keep views, app logic, and persistence apart. A view renders state and sends user intents. Put rules (for example, slot search or quick-add parsing) in plain Swift types that you can unit test without UI.
- Create a type, a protocol, or a folder only when code needs it now. Do not add empty files, speculative services, repositories, or view models.
- Prefer small files with one main type each.
- Use `@Observable` models and SwiftUI environment values for shared state. Do not add a dependency injection framework.
- The project uses Swift 6 with complete strict concurrency. `MainActor` is the default isolation. Mark background work with explicit isolation.

## SwiftUI rules

- Use native containers and controls first: `TabView`, `NavigationStack`, `.sheet` with detents, `List`, `Toggle`, `Picker`. Restyle them to match the design. Build a custom control only when no native control fits the design.
- Use SF Symbols for icons. The design uses Lucide icon names. Map each name to the nearest SF Symbol.
- Use Dynamic Type text styles or `Font.system(size:weight:)` with `relativeTo:`. Text must scale.
- Every control needs an accessibility label. Hit targets are 44 × 44 pt minimum.
- Support dark and light appearance. Dark is the design default.
- Respect Reduce Motion and Reduce Transparency.
- Add a `#Preview` to each new view.

## Xcode project

- The project uses file-system synchronized groups. Xcode adds each new file under `Luna/` or `LunaTests/` to its target automatically. Do not edit `project.pbxproj` to add files.
- Do not add a project generator (XcodeGen, Tuist) without an ADR.
- App bundle ID: `com.lunagistudios.luna`. Test bundle ID: `com.lunagistudios.lunaTests`.

## Validation

Run these before you report work as done:

```bash
xcodebuild -project Luna.xcodeproj -scheme Luna -destination 'generic/platform=iOS Simulator' build
```

```bash
xcodebuild -project Luna.xcodeproj -scheme Luna -destination 'platform=iOS Simulator,name=<iPhone with iOS 26+>' test
```

- The test command needs an iOS 26 or later simulator runtime. If none is installed, run `build-for-testing` and say that the tests did not run.
- Write unit tests with Swift Testing (`import Testing`). Every rule in a feature spec that has no UI (parsing, slot search, streaks) gets a unit test.
- For UI changes, compare the result with the design reference in light and dark appearance.
- A screen checkpoint ends with the artboard comparison. Take simulator screenshots in dark and light appearance. Compare each one with its artboard in the design project. Read the artboard from the design source directly. The repository holds no exported artboard PNGs. Fix each difference, or record it as an intended difference in the screen spec.

## Documentation rules

- The docs are the project memory. A future session has no chat history.
- A new screen gets a spec in `docs/screens/`. A new feature gets a spec in `docs/features/`. Add each new spec to its folder `README.md`.
- When code changes behavior, update the spec in the same change. Set its `Status:` line.
- A significant technical decision gets an ADR. See [docs/adr/README.md](docs/adr/README.md).
- In a spec, keep four kinds of statements apart: **Observed** (in the mockup), **Assumption** (an implementation choice), **Decided** (a product decision the user made, with its date), and **Unresolved** (a product decision that is still open).
- Do not copy HTML, CSS, or JavaScript from the mockup into the app. Do not embed the mockup in a web view.
- Keep each doc short and specific. Link to another doc. Do not repeat its content.
