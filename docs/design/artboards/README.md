# Artboard PNGs

This folder holds the exported artboards from the design canvas. Each screen checkpoint compares simulator screenshots with these files. See [AGENTS.md](../../../AGENTS.md#validation).

The artboard IDs and captions come from the [design reference](../design-reference.md#artboards).

## File names

Use `<id>-<screen>-<theme>.png`:

- `<id>` is the artboard ID, for example `2b`.
- `<screen>` is the screen spec file name without `.md`, for example `today`.
- `<theme>` is `dark` or `light`.

Example: `2b-today-dark.png`.

## Files

Every artboard needs a dark file and a light file. That is 34 files.

| ID | Caption | Dark | Light |
| --- | --- | --- | --- |
| 2a | Interactive · scrolls to now | `2a-today-dark.png` | `2a-today-light.png` |
| 2b | Top of the day · habits · Anytime | `2b-today-dark.png` | `2b-today-light.png` |
| 2c | Now line · timer inside the active block | `2c-today-dark.png` | `2c-today-light.png` |
| 2d | Inbox drawer · dragging into a free gap | `2d-inbox-drawer-dark.png` | `2d-inbox-drawer-light.png` |
| 2e | Empty day | `2e-today-dark.png` | `2e-today-light.png` |
| 2f | Light | `2f-today-dark.png` | `2f-today-light.png` |
| 2g | Quick add · parsed as you type | `2g-quick-add-dark.png` | `2g-quick-add-light.png` |
| 2h | Edit block · color, icon, checklist | `2h-edit-block-dark.png` | `2h-edit-block-light.png` |
| 2i | Full-screen focus | `2i-focus-dark.png` | `2i-focus-light.png` |
| 2j | Lock screen · Live Activity + Dynamic Island | `2j-live-activity-dark.png` | `2j-live-activity-light.png` |
| 2k | Inbox · swipe to place | `2k-inbox-dark.png` | `2k-inbox-light.png` |
| 2l | Projects · Upcoming, Anytime, Someday | `2l-projects-dark.png` | `2l-projects-light.png` |
| 2m | Habits · streaks + heatmap | `2m-habits-dark.png` | `2m-habits-light.png` |
| 2n | Settings | `2n-settings-dark.png` | `2n-settings-light.png` |
| 2o | 3 days | `2o-calendar-dark.png` | `2o-calendar-light.png` |
| 2p | Month | `2p-calendar-dark.png` | `2p-calendar-light.png` |
| 2q | Plan my day · suggestion sheet | `2q-plan-my-day-dark.png` | `2q-plan-my-day-light.png` |

## How to export

A person does this step. No agent tool can export from the design canvas.

1. Open the canvas file. The URL is in the [design reference](../design-reference.md#source).
2. Set the theme to dark.
3. Export each artboard frame as a PNG at its full 440 × 956 pt size.
4. Save each file in this folder with the exact name from the table.
5. Set the theme to light. Do steps 3 and 4 again.

Notes:

- 2a is interactive. Export its first state, before any scroll or tap.
- 2f shows Today in light tokens. Its dark file shows the same layout in dark tokens.
