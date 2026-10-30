# Architecture decision records

An architecture decision record (ADR) records one technical decision, why it was made, and what it costs.

## When to write an ADR

Write a new ADR when a change does one of these:

- Adds a dependency, a framework, a target, or a build tool.
- Chooses a storage, sync, or system integration approach (for example persistence, EventKit, ActivityKit).
- Changes the folder structure, the layer rules, or the state management pattern.
- Changes a project setting that affects all code (deployment target, Swift mode, device family).
- Reverses or replaces an earlier ADR.

Do not write an ADR for a product decision. Record product decisions in the feature spec and remove them from [open-questions.md](../open-questions.md).

## Rules

- Number ADRs in order: `0002-short-title.md`.
- Do not edit the decision of an accepted ADR. To change it, write a new ADR. Set the old status to `Superseded by ADR-NNNN`.
- You may fix typos and add links in an old ADR.
- Add each ADR to the index below.

## Template

```markdown
# ADR-NNNN: Title

- Status: Proposed | Accepted | Superseded by ADR-NNNN
- Date: YYYY-MM-DD

## Context
## Decision
## Rationale
## Consequences
## Alternatives considered
```

## Index

| ADR | Title | Status |
| --- | --- | --- |
| [0001](0001-native-swiftui-foundation.md) | Native SwiftUI foundation | Accepted |
