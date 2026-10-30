# Architecture overview

## What exists now

- One iOS app target, `Luna`, with a `@main` app type and one placeholder view.
- Design tokens in `Luna/Shared/Design/`.
- The domain model in `Luna/Shared/Model/`: value types, pure timeline rules, one `@Observable` `PlannerStore` (in memory), an `AppClock`, and DEBUG sample data.
- One unit test target, `LunaTests`, with Swift Testing tests.
- No persistence, no networking, no packages.

The foundation decisions are in [ADR-0001](../adr/0001-native-swiftui-foundation.md).

## Planned shape

This section is a guide, not a requirement. Create each part only when a feature needs it.

```
Luna/
├── App/            # App entry, root tab shell, app-wide environment setup
├── Features/
│   ├── Today/      # Timeline, bands, week strip, Anytime
│   ├── Inbox/
│   ├── Projects/
│   ├── Habits/
│   ├── Settings/
│   ├── Calendar/
│   ├── BlockEditor/
│   ├── QuickAdd/
│   ├── Focus/
│   └── PlanSuggestions/
├── Shared/
│   ├── Model/      # Value types used by two or more features (Block, BlockColor, Band)
│   ├── Design/     # Color, type, and spacing tokens from the design reference
│   └── Components/ # Views that two or more features use (pill, check circle, ring)
└── Resources/      # Asset catalog, string catalog
```

A Live Activity needs a widget extension target later. See [Focus and Live Activity](../features/focus-and-live-activity.md).

## Layers

| Layer | Holds | Rule |
| --- | --- | --- |
| View | SwiftUI views | Renders state. Sends user intents. Has no business rules. |
| Model and logic | `@Observable` models, value types, pure functions | Holds rules such as slot search and quick-add parsing. Unit tested. |
| Persistence | Storage of blocks, habits, settings | SwiftData, local only (decided 2026-10-30). ADR-0002 in roadmap 2.1 records it. Keep the model CloudKit-compatible for later iCloud sync. |
| System services | EventKit, ActivityKit, notifications | Add each one only when a feature needs it. Wrap it in a small type. |

## Design tokens

The design system ("Noir") defines semantic color, type, spacing, radius, and motion tokens. The first UI phase turns these into Swift constants in `Shared/Design/`. Do not build a full component library first. Add a shared component when the second screen needs it.
