# Habits

Status: Planned
Artboards: 2m
Features: [Habits](../features/habits.md)

## Purpose

Log daily habits and see streaks and history.

## Layout (top to bottom)

1. Title "Habits" (34 pt bold). Subtitle "Thursday · 1 of 5 done today".
2. **History card** (`surface-primary`, radius 24, padding 20). Header "Water" with "Last 12 weeks". A heatmap of 12 columns × 7 rows (84 cells, 4 pt gap, radius 5). Three stats: "12 Day streak", "86% This month", "31 Best streak" (24 pt bold numbers, 13 pt labels).
3. **Habit cards**, one per habit (radius 24, padding 16):
   - Row: 40 pt colored icon tile, name (17 pt semibold), subtitle ("5 of 8 · 8 glasses a day" or "Every morning"), a flame icon with the streak count, and a 30 pt check circle.
   - For a multi-count habit that is not done, the circle shows the count number. Otherwise it shows a check.
   - A week row: seven columns M–S, each a 24 pt dot. A done day is filled with the habit color. Today is outlined in `text-secondary` when not done. Future days are outlined in `surface-tertiary`.

## Sample data (Observed)

| Habit | Icon | Color | Value / goal | Streak | Subtitle |
| --- | --- | --- | --- | --- | --- |
| Water | glass-water | Slate | 5 / 8 | 12 | 8 glasses a day |
| Stretch | person-standing | Sage | 1 / 1 | 23 | Every morning |
| Read | book-open | Sand | 0 / 1 | 4 | 20 minutes |
| Meditate | wind | Plum | 0 / 1 | 0 | 10 minutes |
| Walk | footprints | Rose | 0 / 1 | 6 | 8,000 steps |

## Interactions

- Tap the check circle: add one to the count. At the goal, the next tap resets to zero. The same rule applies to the ring on Today.
- A streak of 0 shows in tertiary text.

## States

- **Assumption:** with no habits, show an empty state with an add action. The mockup has none.

## Accessibility and iOS notes

- The heatmap needs a summary label (for example "Water, last 12 weeks, 86 percent this month"). Do not expose 84 cells to VoiceOver.
- The check button label is "Log Water".

## Open questions

- The history card, schedule, and management decisions are in [Habits](../features/habits.md#decisions).
- See [open-questions.md](../open-questions.md#habits).
