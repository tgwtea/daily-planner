# Repository map

Each row gives a path, whether it exists now, and its job.

| Path | Exists | Responsibility |
| --- | --- | --- |
| `AGENTS.md` | Yes | Shared rules for all coding agents. Source of truth. |
| `CLAUDE.md` | Yes | Claude Code notes. Imports `AGENTS.md`. |
| `README.md` | Yes | Human entry point: requirements, build, test. |
| `Luna.xcodeproj/` | Yes | Xcode project. Uses file-system synchronized groups. |
| `Luna.xcodeproj/xcshareddata/xcschemes/Luna.xcscheme` | Yes | Shared scheme that builds the app and runs `LunaTests`. |
| `Luna/App/` | Yes | `LunaApp.swift`: entry point. Creates the store and the router. Applies the theme. |
| `Luna/Resources/Assets.xcassets` | Yes | App icon slot (no image yet) and accent color. |
| `Luna/Features/<Feature>/` | Yes | Views and logic for one feature. One folder per feature spec. |
| `Luna/Features/AppShell/` | Yes | `RootView`, `LunaTabBar`, `AppRouter`, `AppRoute`, `AppTab`, and `PlaceholderScreen`. |
| `Luna/Features/QuickAdd/`, `EditBlock/`, `Focus/` | Yes | Empty placeholder sheet and cover until 1c.1, 1c.3, 1c.6. |
| `Luna/Shared/Settings/` | Yes | `AppTheme` and `SettingsKey` (the `@AppStorage` keys). |
| `Luna/Shared/Model/` | Yes | Value types (`Block`, `Step`, `Band`, `AnytimeTask`, `InboxItem`, `Habit`, `Area`, `Project`), pure rules (`Timeline`, `DayLimit`, `DurationFormat`), `PlannerStore`, `AppClock`, and DEBUG-only `SampleData`. |
| `Luna/Shared/Design/` | Yes | Tokens from [design-reference.md](../design/design-reference.md): `LunaColor`, `BlockColor`, `LunaTextStyle`, `LunaSpacing`, `LunaRadius`, `LunaShadow`, `LunaMotion`, `LunaGlass`. `DesignTokensPreview` shows all tokens in Xcode previews only. |
| `Luna/Shared/Components/` | Yes | Reusable views that two or more features use: `BlockPill`, `CheckCircle`, `ChipButton`, `RoundAddButton`, `IconTile`, `ProgressRing`, `GroupedList`, `GroupedRow`, `LargeTitleHeader`, `PressScaleButtonStyle`. DEBUG-only `ComponentsGallery`. |
| `LunaTests/` | Yes | Unit tests. Mirror the `Luna/` folders as tests grow. `LunaTests/Design/` tests the tokens. `LunaTests/Model/` tests the model and the store. `LunaTests/AppShell/` tests the router. `LunaTests/Components/` tests the component rules. `LunaTests/Settings/` tests the theme. |
| `docs/architecture/` | Yes | This map and the [overview](overview.md). |
| `docs/adr/` | Yes | [Decision records](../adr/README.md). |
| `docs/design/` | Yes | [Design reference](../design/design-reference.md). |
| `docs/screens/` | Yes | [Screen specs](../screens/README.md). |
| `docs/features/` | Yes | [Feature specs](../features/README.md). |
| `docs/roadmap.md` | Yes | [Phases, checkpoints, completion log](../roadmap.md). |
| `docs/open-questions.md` | Yes | [Open decisions](../open-questions.md). |
| `docs/release/` | Planned | Release checklist and privacy answers (roadmap 4.2, 4.3). |

When you add a top-level folder, add a row here.
