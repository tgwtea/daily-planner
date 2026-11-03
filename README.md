# Luna

Luna is a calm, native iOS time blocker. It puts your day on a timeline in Morning, Afternoon, and Night bands. It adds an Inbox, projects, habits, a calendar, and a focus timer.

**Status:** foundation only. The app shows one placeholder view. The specs in [`docs/`](docs/README.md) describe the planned app. The build plan and progress are in [docs/roadmap.md](docs/roadmap.md).

## Requirements

- Xcode 26 or later. The project was made with Xcode 27.0.
- iOS 26 SDK. The minimum deployment target is iOS 26.0.
- An iOS 26 or later simulator runtime to run the app and the tests. Install it in Xcode > Settings > Components.

There are no third-party dependencies.

## Build and test

Open `Luna.xcodeproj` in Xcode and run the `Luna` scheme. Or use the command line:

```bash
xcodebuild -project Luna.xcodeproj -scheme Luna -destination 'generic/platform=iOS Simulator' build
```

```bash
xcodebuild -project Luna.xcodeproj -scheme Luna -destination 'platform=iOS Simulator,name=iPhone 17,OS=27.0' test
```

This is the exact test command for the development Mac (Xcode 27.0, iOS 27.0 simulator runtime 24A434). On another Mac, replace `iPhone 17` and `27.0` with any installed simulator that runs iOS 26 or later.

To set up a new Mac:

```bash
xcodebuild -downloadPlatform iOS
```

```bash
xcrun simctl create "iPhone 17" "com.apple.CoreSimulator.SimDeviceType.iPhone-17" com.apple.CoreSimulator.SimRuntime.iOS-27-0
```

The runtime download is about 8 GB.

## Repository layout

| Path | Purpose |
| --- | --- |
| `Luna/` | App target sources and assets |
| `LunaTests/` | Unit tests (Swift Testing) |
| `Luna.xcodeproj/` | Xcode project and shared scheme |
| `docs/` | Architecture, ADRs, design reference, screen and feature specs |
| `AGENTS.md` | Rules for all coding agents (source of truth) |
| `CLAUDE.md` | Claude Code notes. It imports `AGENTS.md`. |

The full map is in [docs/architecture/repository-map.md](docs/architecture/repository-map.md).

## Design

The design reference is the Claude Design project "Plan My Day v3". See [docs/design/design-reference.md](docs/design/design-reference.md).
