# ADR-0001: Native SwiftUI foundation

- Status: Accepted
- Date: 2026-10-30

## Context

Luna is a new, long-lived iPhone app. The design reference is a Claude Design HTML prototype ("Plan My Day v2"). Coding agents with no chat history will do most of the work. The foundation must be easy to read, build with Apple tools only, and avoid decisions that the product does not need yet.

## Decision

1. **UI and language.** Swift and SwiftUI. Swift 6 language mode with complete strict concurrency. `SWIFT_DEFAULT_ACTOR_ISOLATION = MainActor` and approachable concurrency are on.
2. **Platform.** iPhone only (`TARGETED_DEVICE_FAMILY = 1`). Minimum iOS 26.0.
3. **Orientation.** Portrait only. This is provisional. Change it with a new ADR if the product needs landscape.
4. **Identity.** App name Luna. Bundle ID `com.lunagistudios.luna`. Test bundle ID `com.lunagistudios.lunaTests`. Version 0.1.0, build 1.
5. **Project file.** A hand-written `Luna.xcodeproj` with file-system synchronized groups (object version 77). No project generator. `GENERATE_INFOPLIST_FILE = YES`, so there is no Info.plist file.
6. **Tests.** One unit test target that uses Swift Testing. No UI test target yet.
7. **Dependencies.** None. Apple frameworks only.
8. **Structure.** Feature-first folders under `Luna/Features/`, shared code under `Luna/Shared/`. See the [overview](../architecture/overview.md).
9. **Agent guidance.** `AGENTS.md` is the single source of truth. `CLAUDE.md` imports it.
10. **Not decided.** Persistence, sync, calendar access, Live Activity, notifications, and the Plan suggestion engine. Each needs its own ADR.

## Rationale

- iOS 26 gives native Liquid Glass (`glassEffect`, glass tab bars and sheets). The design uses floating glass bars and glass sheets on every screen. A lower target needs a second visual path.
- iPhone only matches the design. Every artboard is a 440 × 956 pt iPhone frame.
- Synchronized groups let an agent add a file without a `pbxproj` edit. Merge conflicts in the project file become rare. No extra tool is needed.
- Swift Testing is the current Apple test framework. It suits pure logic tests, which are the first tests the app needs.
- Swift 6 strict concurrency finds data races at compile time. It is cheaper to start strict than to migrate later.

## Consequences

- Devices that cannot run iOS 26 cannot install the app.
- An iOS 26 or later simulator runtime is required to run the app and the tests. On 2026-10-30 the development Mac had only iOS 18.6. The build and test compilation work without a runtime.
- A future widget extension (Live Activity) is a second target. Add it with an ADR.
- The project file was written by hand. If Xcode rewrites it on first open, commit the result.

## Alternatives considered

| Alternative | Why not chosen |
| --- | --- |
| iOS 18 minimum | Runs on the installed simulator, but glass needs materials and availability checks. |
| XcodeGen or Tuist | Extra tool and config. Synchronized groups solve the same merge problem. |
| Swift Package for app code | Adds a module boundary before there is a need. |
| XCTest | Still supported, but Swift Testing is the current default for new code. |
| iPhone and iPad | No iPad design exists. |
| Third-party architecture (TCA) or DI framework | Not needed at this size. `@Observable` and environment values are enough. |
