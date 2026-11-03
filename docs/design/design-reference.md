# Design reference

This is the central visual reference for Luna. Screen specs link here for shared values. They do not repeat them.

## Source

| Item | Value |
| --- | --- |
| Tool | Claude Design |
| Project | "Form submission waiting" (ID `feb8e067-7716-40d0-86ee-981e9a51c289`) |
| URL | https://claude.ai/design/p/feb8e067-7716-40d0-86ee-981e9a51c289?file=Plan+My+Day+v3.dc.html |
| Canvas file | `Plan My Day v3.dc.html`. It lists artboards 3a–3an with captions and short rationale notes. |
| Prototype file | `Plan My Day v3 App.dc.html`. It holds all markup, logic, and sample data. This is the main source. |
| Handoff file | `Plan My Day v3 Handoff.dc.html`. It holds the change log, the navigation tree, the screen inventory, the component list, the token notes, the key rules, and the accessibility notes. |
| Screenshot | `screenshots/v3-today.jpg` |
| Runtime | `support.js`. The generic Claude Design template runtime. It has no product content. |
| Design system | `_ds/noir-design-system-…/` ("Noir"). Its tokens are in `tokens/*.css` and its guidance is in `readme.md`. v3 uses the same Noir files as v2. |
| Superseded | `Plan My Day v2.dc.html` and `Plan My Day v2 App.dc.html` (v2), `Plan My Day.dc.html` and `Plan My Day App.dc.html` (v1). Do not use them as a reference. The completion log and older comparisons cite v2 artboard IDs (2a–2q). They are history. |
| Not inspected | `uploads/refs-*.webp`, `uploads/refs-*.png` (two reference images). |

v3 inspected on 2026-11-03. **Decided (2026-11-03):** v3 is the source of truth. It replaces v2. If the design changes, update this file and the affected specs.

v3 calls itself "cognitive-first": the same timeline and identity as v2, plus block types (Flexible, Fixed, Open time), planned versus actual, AI drafts that the user approves, capture that saves before it organizes, a Focus anchor with "I'm stuck", project pick-up summaries, and two-way sync for selected blocks. The prototype simulates AI, calendar, permissions, and network.

The handoff tags each screen **Existing** (v2, unchanged), **Enhanced**, or **New**, and each dependency **AI**, **iOS permission**, or **External**.

### Sample data

The v3 prototype uses a new sample (a student: "Algorithms lecture", "Linear algebra", "Operating systems", project "Plan My Day app"). The date and time are the same: Thursday, October 29, 2026, 10:20 AM. **Decided (2026-11-03):** the app keeps the v2 sample data. A checkpoint adds a v3 state to it (one Fixed block, one Open time block, one synced block, one capture item) only when it needs one. Compare layout and states with the artboards. Do not compare titles.

### Artboards

| ID | Caption | Screen spec |
| --- | --- | --- |
| 3a | Interactive v3 · start here | [Today](../screens/today.md) |
| 3b | Before · v2 bottom edge | History only |
| 3c | After · scrolled, compact bar, one accessory | [Navigation map](../screens/README.md#navigation-map) |
| 3d | Settings · grouped, progressive | [Settings](../screens/settings.md) |
| 3e | Busy day · top | [Today](../screens/today.md) |
| 3f | Night · open time, events, fixed | [Today](../screens/today.md) |
| 3g | Partially planned · Friday | [Today](../screens/today.md) |
| 3h | Empty day | [Today](../screens/today.md) |
| 3i | Light | [Today](../screens/today.md) |
| 3j | Inbox drawer · drag into a gap | [Inbox drawer](../screens/inbox-drawer.md) |
| 3k | Plan sheet · unfinished work follow-up | [Plan hub](../screens/plan-my-day.md) |
| 3l | Daily draft · on the timeline | [Today](../screens/today.md), [Plan hub](../screens/plan-my-day.md) |
| 3m | Conflicting proposal | [Today](../screens/today.md) |
| 3n | Running long · gentle nudge | [Today](../screens/today.md) |
| 3o | Before / after | [Before and after](../screens/before-after.md) |
| 3p | AI unavailable · plan by hand | [Plan hub](../screens/plan-my-day.md) |
| 3q | Capture · detected details | [Capture](../screens/capture.md) |
| 3r | Saved immediately · organizing | [Inbox](../screens/inbox.md) |
| 3s | AI organization suggestion | [Inbox](../screens/inbox.md) |
| 3t | Inbox review | [Quick review](../screens/quick-review.md) |
| 3u | Offline capture | [Inbox](../screens/inbox.md) |
| 3v | Focus anchor · timer | [Focus](../screens/focus.md) |
| 3w | No timer | [Focus](../screens/focus.md) |
| 3x | "I'm stuck" reorientation | [I'm stuck sheet](../screens/stuck-sheet.md) |
| 3y | Optional check-in | [Focus](../screens/focus.md) |
| 3z | Ending · done is your call | [End Focus sheet](../screens/end-focus-sheet.md) |
| 3aa | Live Activity | [Live Activity](../screens/live-activity.md) |
| 3ab | Projects | [Projects](../screens/projects.md) |
| 3ac | Simple project | [Project detail](../screens/project-detail.md) |
| 3ad | Rich project · context summary | [Project detail](../screens/project-detail.md) |
| 3ae | Not enough context · honest fallback | [Project detail](../screens/project-detail.md) |
| 3af | Block · type and per-block sync | [Block detail](../screens/block-detail.md) |
| 3ag | Sync conflict | [Sync conflict](../screens/sync-conflict.md) |
| 3ah | Calendar settings · sync scope | [Settings group](../screens/settings-group.md) |
| 3ai | Permission denied | [Today](../screens/today.md) |
| 3aj | 3-day calendar | [Calendar](../screens/calendar.md) |
| 3ak | Habits · streaks hidden | [Habits](../screens/habits.md) |
| 3al | AI planning settings (light) | [Settings group](../screens/settings-group.md) |
| 3am | Onboarding | [Onboarding](../screens/onboarding.md) |
| 3an | First launch · no tasks | [Today](../screens/today.md) |

v3 has no artboard for the Month view, smart lists, the habit editor, or archived habits. Their v2 specs stay valid. The Month view is still in the v3 prototype (`calView` `month`).

The repository holds no exported PNGs of these artboards. To compare a screen, read the artboard from the design project. Decided (2026-10-31).

The mockup frame is 440 × 956 pt with a 66 pt corner radius. It draws a mock status bar, Dynamic Island, keyboard, and home indicator. Do not draw these in the app. iOS provides them.

## Principles

From the Noir readme: "Typography creates hierarchy. Solid surfaces organize content. Glass reveals interaction. Everything else stays quiet."

- The UI is monochrome. Color appears only on blocks, habits, and projects that the user colors. Each block has one muted color and one line icon.
- Dark is the default theme. Light is a full alternate theme (artboard 2f).
- Solid graphite surfaces hold content. Glass is only for floating or temporary layers: tab bar, bottom accessory, Now · Next bar, sheets, dialogs, toasts, Live Activity.
- State is never color-only. A glyph and text carry it too: lock (Fixed), shield (Open time), calendar (event), sparkles (suggestion), refresh (synced), triangle-alert (sync conflict).
- Nothing is marked complete because time passed or a session ended. AI output is always a draft.
- Copy is calm and plain. Use sentence case. Buttons are verbs. Empty states say the situation, then the next step. No emoji in UI chrome. The metadata separator is a middle dot with spaces: "9:30 – 11:00 · 1 h 30 min".

## Color

Use semantic roles in code. Do not use raw palette values.

In code: `Color` static properties in `Luna/Shared/Design/LunaColor.swift`. The property name is the role in camel case, for example `Color.surfacePrimary`. `action-primary-bg` / `-fg` are `actionPrimaryBackground` / `actionPrimaryForeground`. `glass-bg` is `glassBackground`. The Inbox drawer scrim is `drawerScrim`.

| Role | Dark | Light | Use |
| --- | --- | --- | --- |
| `bg-canvas` | `#000000` | `#FFFFFF` | Screen background |
| `bg-secondary` | `#1A1A1A` | `#F5F5F5` | Keyboard area in Capture |
| `surface-primary` | `#1C1C1E` | `#F2F2F3` | Cards, grouped lists, band chips |
| `surface-secondary` | `#2C2C2E` | `#E8E8EA` | Past event pill, focus ring track |
| `surface-tertiary` | `#3A3A3C` | `#D6D6D9` | Upcoming event pill, ring tracks, empty heat cells |
| `surface-interactive` | `#3C3C3C` | `#E3E3E6` | Keys |
| `surface-raised` | `#434343` | `#FFFFFF` | Calendar event blocks, swipe action buttons, drag ghost |
| `surface-hover` | white 6% | black 4% | Chips and rows on glass |
| `text-primary` | `#FFFFFF` | `#111111` | Titles, selected fills |
| `text-secondary` | `#98989D` | `#6B6B70` | Meta lines, captions |
| `text-tertiary` | `#7C7C81` | `#86868B` | Times, counts, done titles |
| `text-inverse` | `#000000` | `#FFFFFF` | Text on a selected fill |
| `icon-secondary` | `#98989D` | `#6B6B70` | Chip and toolbar icons |
| `border-subtle` | white 8% | black 6% | Dashed rail in empty day |
| `border-standard` | white 12% | black 10% | Dashed timeline rail |
| `border-strong` | white 24% | black 22% | Unchecked rings, grabber |
| `divider-default` | white 10% | black 8% | Row dividers, calendar hour lines |
| `action-primary-bg` / `-fg` | white / black | black / white | Primary buttons, "+" button, Focus button |
| `overlay-scrim` | black 54% | black 24% | Behind sheets. The Inbox drawer uses black 18%. |
| `glass-bg` | `rgba(58,58,60,0.74)` | `rgba(246,246,248,0.78)` | Glass layers |
| `glass-border` | white 12% | black 8% | Glass outline |
| `glass-item-hover` | white 10% | black 6% | Selected tab background |

High contrast (from Noir `tokens/colors.css`, dark only): `text-secondary` becomes `#C7C7CC`, `text-tertiary` becomes `#98989D`, `border-subtle` white 20%, `border-standard` white 32%, `divider-default` white 24%. The app maps this to the Increase Contrast setting.

**Assumption (1a.2):** Noir has no light high-contrast values. The app uses `text-secondary` `#3D3D40`, `text-tertiary` `#6B6B70`, `border-subtle` black 18%, `border-standard` black 28%, `divider-default` black 20%.

Status colors exist in Noir (`#FF6961`, `#FFB340`, `#32D74B`, `#64B5FF` in dark). v3 uses two of them: `status-warning` only for calendar conflicts and sync changes (for example the meta line "Changed in Calendar"), and `status-error` only for a delete action. Do not use the others.

### Block colors

The mockup defines five block colors in oklch. The same values are used in both themes. The hex values are an sRGB conversion that I computed. They are not in the source. A second conversion in 1a.2 gave the same values.

In code: `BlockColor` in `Luna/Shared/Design/BlockColor.swift`, with `displayName`, `color`, `doneColor`, and `BlockColor.ink`.

| Name | oklch (source) | sRGB hex (computed) |
| --- | --- | --- |
| Rose | `oklch(0.72 0.075 18)` | `#D09293` |
| Slate | `oklch(0.71 0.05 245)` | `#88A5BF` |
| Sage | `oklch(0.75 0.06 150)` | `#93B99A` |
| Sand | `oklch(0.80 0.065 80)` | `#D4BA8E` |
| Plum | `oklch(0.67 0.07 330)` | `#AE86AA` |

- An icon or check mark on a block color uses ink `#151517` in both themes.
- Tints mix the block color with the canvas, in oklch: done 38%, unconfirmed 55%, suggestion 20%. A done icon uses ink at 55% opacity. A suggestion icon uses the block color.
- An Open time pill is transparent with a 2 pt dashed `border-strong` outline and an `icon-secondary` shield or icon. A suggestion pill has a 2 pt dashed outline in its block color.
  - **Assumption (1a.2):** SwiftUI has no oklch mix. The app uses `Color.mix(with:by:in: .perceptual)`, the nearest native color space.
- The habit heatmap uses Slate mixed 35–100% with the canvas. A heatmap filtered to one habit uses that habit's color (1b.3).

## Typography

The font is the system font (SF Pro). Use tabular figures for every time, count, and timer. The mockup sets sizes in points:

| Use | Size / weight | Tracking |
| --- | --- | --- |
| Lock screen clock | 104 bold | −0.045 em |
| Focus timer | 72 bold | −0.035 em |
| Large screen title (Today, Inbox, …) | 34 bold | −0.025 em |
| Calendar title | 28 bold | −0.02 em |
| Block detail title | 26 bold | −0.02 em |
| Sheet title, Live Activity timer | 24–30 bold | −0.02 em |
| Section heading, empty-state title | 20 semibold | −0.01 em |
| Row and block title | 17 semibold | — |
| Day number in week strip | 17 semibold | — |
| Body, step text | 15–16 regular | — |
| Band chip label, buttons | 14–15 semibold | — |
| Meta line, caption | 13 regular | — |
| Time label, weekday | 12 medium | — |
| Tab label | 11 semibold (v2: 10) | — |
| Now · Next title | 15 semibold, labels 12 medium | — |
| Capture field | 19 medium | — |

Noir defines a type scale (display 48/38, heading 30/24/20, body 17/16, label 15/14, caption 13/12). Map the rows above to Dynamic Type styles: 34 → `.largeTitle`, 20 → `.title3`, 17 → `.headline`/`.body`, 15 → `.subheadline`, 13 → `.footnote`, 12 → `.caption`. Fixed sizes such as the timers use `Font.system(size:weight:)` and scale with `@ScaledMetric`.

In code: `View.lunaTextStyle(_:)` with one `LunaTextStyle` case per row above (`Luna/Shared/Design/LunaTextStyle.swift`). Each style scales with Dynamic Type relative to the mapped text style. Times, counts, and timers get tabular figures. **Assumption (1a.2):** for a range, the style uses the low value (sheet title 24, body 16, label 15). The Live Activity timer is 30.

## Spacing and size

- 4 pt rhythm. Screen side margin 20 pt. Week strip margin 12 pt.
- Gap between sections: 22–28 pt. Gap between a section header and its group: 8–14 pt.
- Grouped list row padding: 10–14 pt vertical, 14–16 pt horizontal. Card padding: 20 pt.
- Minimum hit target: 44 × 44 pt. Small visual controls (34 pt chips, 26 pt check circles) get a 44 pt hit area.
- Timeline grid columns: 44 pt time label, 52 pt pill, flexible text, 44 pt check. Column gap 12 pt.
- Tab bar: 64 pt high, 52 pt when compact. 20 pt side margin, 30 pt from the bottom of the frame. The Capture circle matches the bar height. 12 pt gap.
- Bottom accessory: 106 pt above the frame bottom, 94 pt when the bar is compact. 16 pt side margin (Focus mini-player 20 pt). The bottom accessory moves in 250 ms.
- Today bottom content padding: 200 pt.

In code: `LunaSpacing` (`Luna/Shared/Design/LunaSpacing.swift`). **Assumption (1a.2):** for a range, the token is a 4 pt step inside it: section gap 24, header gap 12, row padding 12 × 16.

## Shape

| Element | Radius |
| --- | --- |
| Icon box in a list row | 8 |
| Text field | 12 |
| Anytime and Inbox icon tiles | 12–14 |
| Icon picker cells | 16 |
| Grouped lists, menus | 20 |
| Cards | 24 |
| Dialogs, Live Activity card | 28 |
| Sheet top corners | 36 |
| Buttons, chips, band chips, tab bar, search | Capsule |
| Icon buttons, "+" button, check marks | Circle |
| Timeline pill | 52 pt wide capsule (radius 26) |
| Now · Next bar | 18 |
| Bottom accessory | 28 (Focus mini-player: capsule) |
| Banner (calendar off) | 16 |

In code: `LunaRadius` (`Luna/Shared/Design/LunaRadius.swift`). Icon tiles use 12.

## Materials and elevation

- Elevation comes from surface lightness first. Content cards have no border and no shadow.
- Glass: `glass-bg` + 24 pt blur + 160% saturation + 1 pt border in `glass-border`. On iOS 26 use `.glassEffect()` or the system glass of `TabView` and `.sheet`. Compare the result with the mockup. Fall back to an opaque `glass-fallback` color (`#2C2C2E` dark, `#F9F9F9` light) under Reduce Transparency.
- Shadows: floating controls `0 6 20` black 36% (14% light). Overlays and sheets `0 −18 48` black 44% (16% light). The drag ghost uses the overlay shadow and a −2.5° tilt.
- In code: glass colors are in `LunaColor.swift`. Shadows are `View.lunaShadow(_:)` (`LunaShadow.swift`). The SwiftUI shadow radius is half the CSS blur.

## Motion

| Token | Value | Use |
| --- | --- | --- |
| Instant | 120 ms | Press feedback |
| Fast | 180 ms | Check fill, selection, tab change |
| Normal | 250 ms | Chevron rotate, pill color, progress bars |
| Slow | 350 ms | Sheet in, ring progress, swipe reveal, hero pill height |

- Press: scale to 0.97 (0.94 for icon buttons, 0.95 for the timeline pill, 0.88–0.92 for check marks and the "+" button). In code: `PressScaleButtonStyle` with a `LunaMotion.PressScale` value. Reduce Motion turns the scale off.
- Selection and pill changes use a slight-overshoot spring (`cubic-bezier(.34,1.3,.64,1)`). Map it to `.spring(duration: 0.25, bounce: 0.15)` or similar.
- Sheets enter with ease-out in 350 ms and exit with ease-in in 250 ms. Use the system sheet animation.
- The focus ring moves linearly once a second.
- The tab bar height and the bottom accessory position animate in 250 ms with `cubic-bezier(.2,.8,.2,1)`.
- Reduce Motion: no pill fill animation. Sheets cross-fade.
- No bounce loops, parallax, or decorative motion. Reduce Motion sets durations to zero.
- In code: `LunaMotion` (`Luna/Shared/Design/LunaMotion.swift`). `LunaMotion.animation(_:reduceMotion:)` returns `nil` under Reduce Motion.

## Reusable patterns

These patterns appear on two or more screens. Build each one as a shared view when the second screen needs it.

| Pattern | Where | Description |
| --- | --- | --- |
| Large title header | Today, Inbox, Projects, Habits, Settings | 34 pt bold title, optional 15 pt secondary line above or below |
| Capsule chip button | Band headers, Anytime, Plan, Capture chips | 34 pt (30 pt in Capture) capsule on `surface-primary` or `surface-hover`, icon + label + count |
| Round add button | Band headers, Anytime | 34 pt circle, plus icon |
| Check circle | Blocks, Anytime, steps, habits, proposals | 26 pt (18–30 pt variants) ring in the block color. Filled with the color and an ink check when done. |
| Colored icon tile | Anytime, Inbox, habits, drawer, proposals | 36–40 pt rounded square or circle in the block color, ink icon |
| Grouped list | Projects, Settings, Block detail, Inbox | `surface-primary`, radius 20, hairline dividers between rows |
| Settings row | Settings, Projects, Block detail | Leading 32 pt icon box, title, trailing value, chevron or switch |
| Progress ring | Habits strip, projects | Circular stroke in the item color on a `surface-tertiary` track |
| Glass sheet | Capture, drawer, Plan, Before and after, Quick review, I'm stuck, End Focus | Radius 36 top corners, grabber 36 × 5 pt |
| Glass dialog | Sync conflict, delete | Radius 28, title, body, stacked full-width buttons |
| Toast | All screens | Glass capsule with an icon and one line. Hides after 2.6 s. |
| Floating tab bar | Main tabs | Glass capsule, 4 tabs (Today, Inbox, Projects, Habits), 64 pt high, 52 pt and icons only when compact. The Inbox tab has a count badge. A separate primary Capture circle (plus icon) of the same height. |
| Bottom accessory | Today, all roots while Focus runs | One glass slot above the tab bar. Priority: Focus mini-player, then draft approval bar, then running-late nudge. |
| Now · Next bar | Today | Sticky glass bar under the header: an 8 × 28 pt color bar, "Now · 40 min left" and the title, then "Next · 12:00" and the title. Tap scrolls to now. |
| Header icon button | Root headers | 44 pt glass circle. Settings gear on every root. The Today Inbox drawer button has a count badge. |
| Segmented control | Calendar, Block detail, Focus, Plan hub | Calendar views; block type (Flexible, Fixed, Open time); Timer or No timer; Rest of today or Tomorrow |
| Selected-day fill | Week strip, calendar, month | Circle filled with `text-primary`, number in `text-inverse` |

v3 handoff component names: TimelineBlockRow (variants: flexible, fixed, open, event, suggestion new / move / conflict, active, focusing, done, unconfirmed), FreeGap (shown at 20 min or more), NowLine, BandHeader, NowNextBar, BottomAccessory (FocusMini, DraftBar, Nudge), SuggestionField (check toggle, label, value, status note), ReviewCard (item, reason chips, two-column action grid), FocusRing, FocusAnchor (next step and checklist), CheckInSheet, StuckSheet, PickupCard (next step, summary, source line, details disclosure). Build each as a shared view when the second screen needs it.

In code (1a.5): `Luna/Shared/Components/`. `LargeTitleHeader`, `ChipButton` (34 pt, `isCompact` 30 pt), `RoundAddButton`, `CheckCircle` (`.small` 18, `.regular` 26, `.large` 30, optional `count` for a multi-count habit), `IconTile`, `GroupedList` with `GroupedRow`, `ProgressRing`, and `BlockPill` (the timeline pill). The tab bar is `LunaTabBar`. Glass is `View.lunaGlass(in:)` (`LunaGlass.swift`). The other patterns come with their screens.

Added in 1b.5: `GroupedSection` (small header, grouped list, optional footer) and `LunaSwitchStyle` (the Noir 51 × 31 pt switch). Switch colors (`switch-track-off`, `switch-track-on`, `switch-thumb-off`, `switch-thumb-on`): dark `#3A3A3C`, `#FFFFFF`, `#FFFFFF`, `#000000`; light `#D6D6D9`, `#000000`, `#FFFFFF`, `#FFFFFF`.

Component values from the prototype (read 2026-10-31):

- Pill: fill rules in [Today](../screens/today.md#states). Done wins over active. Height `clamp(52, 52 + 0.5 × minutes, 112)`. Routine pill 150 pt (v2: 164). The active fill is a hard stop at the progress point. Icon 20 pt. A routine pill shows its icon at the top.
- Check circle: ring 2 pt (1.75 pt at 18 pt). An unconfirmed block has a dashed ring in `text-tertiary`. Check 14 pt (11 pt at 18 pt). The ring takes the block color. Block detail steps use `border-strong` when off. Plan proposals fill with `text-primary` and a `text-inverse` check.
- Chip: padding 0 × 12 pt, 15 pt semibold, 16 pt icon, count in `text-tertiary`, chevron in `icon-secondary`.
- Round add button: 34 pt `surface-primary` circle, 16 pt plus in `icon-secondary`.
- Icon tile: 36 pt, radius 12, 18 pt ink icon.
- Progress ring: 60 pt, 3 pt stroke, round cap, starts at the top, 350 ms.
- Grouped list: a 1 pt `divider-default` line above each row after the first. It spans the full row width.

**Assumption (1a.5):** the prototype does not draw the settings row icon box. The app uses a 32 pt `surface-tertiary` box, radius 8, with a 16 pt `text-primary` icon. The 30 pt check circle uses a 16 pt check. A chip, a check circle, and the add button keep a 44 pt hit area around the smaller shape.

## Icons

The mockup uses Lucide icon names through the Noir `Icon` component. Use SF Symbols in the app. Noir rules: outline style, monochrome, 12/16/20/24/30/44 pt sizes, color from the foreground style.

| Lucide name in mockup | SF Symbol candidate |
| --- | --- |
| calendar-days | `calendar` |
| inbox | `tray` |
| folder | `folder` |
| repeat-2 | `repeat` |
| settings-2 | `slider.horizontal.3` |
| sunrise / sun / moon | `sunrise` / `sun.max` / `moon` |
| sparkles | `sparkles` |
| plus | `plus` |
| check | `checkmark` |
| clock / timer / bell | `clock` / `timer` / `bell` |
| chevron-down / -right / -left / -up | `chevron.down` / `.right` / `.left` / `.up` |
| grip-vertical | `line.3.horizontal` |
| play / pause | `play.fill` / `pause.fill` |
| flame | `flame` |
| laptop, file-text, git-pull-request, dumbbell, bike, utensils, book-open, phone, shopping-basket, plane | `laptopcomputer`, `doc.text`, `arrow.triangle.pull`, `dumbbell`, `bicycle`, `fork.knife`, `book`, `phone`, `basket`, `airplane` |
| lock / shield / refresh-cw / triangle-alert | `lock` / `shield` / `arrow.triangle.2.circlepath` / `exclamationmark.triangle` |
| panel-bottom-open / text-quote / mic / shapes | `rectangle.bottomhalf.inset.filled` / `text.quote` / `mic` / `square.on.circle` |
| wifi-off / loader / circle-alert / circle-slash | `wifi.slash` / `progress.indicator` (or `ProgressView`) / `exclamationmark.circle` / `nosign` |
| calendar-off / calendar-plus / calendar-clock / calendar-range / calendar-cog | `calendar.badge.exclamationmark` / `calendar.badge.plus` / `calendar.badge.clock` / `calendar` / `calendar.badge.checkmark` |
| hourglass / square / circle-dashed / circle-dot / arrow-right | `hourglass` / `stop.fill` / `circle.dashed` / `smallcircle.filled.circle` / `arrow.right` |
| zap / minus / cloud-fog / battery-medium | `bolt` / `minus` / `cloud.fog` / `battery.50percent` |
| archive / archive-x / book-check / layers / list-checks / target / notebook-text / link | `archivebox` / `xmark.bin` / `book.closed` / `square.stack` / `checklist` / `scope` / `note.text` / `link` |
| hand / sun-moon / cloud / users / sofa / gamepad-2 / heart / sigma / notebook-pen | `hand.raised` / `circle.lefthalf.filled` / `icloud` / `person.2` / `sofa` / `gamecontroller` / `heart` / `sum` / `square.and.pencil` |

The candidates are assumptions. Check each one in the SF Symbols app.

## Accessibility (v3 handoff)

- Dynamic Type: rows grow. Pill heights are minimums. 44 pt targets throughout.
- VoiceOver block label: title, time range, type, status. Example: "Build SwiftUI timeline, 10:00 to 11:30, flexible, 70 minutes left". A suggestion announces "Suggested".
- Reduce Motion: no pill fill animation. Sheets cross-fade.
- Reduce Transparency: glass becomes opaque graphite (`glass-fallback`).
- Light theme: white canvas. Block accents do not change. Ink stays dark on pills.

## Native SwiftUI notes

- Tab bar: **Decided (2026-11-03):** keep the custom floating `LunaTabBar` over a `TabView` with the system bar hidden, plus the separate Capture circle. Add the v3 behavior by hand: compact to icons only on a downward scroll (64 to 52 pt), labels return on an upward scroll, and one bottom accessory slot. The v3 handoff suggests `.tabBarMinimizeBehavior(.onScrollDown)` and `.tabViewBottomAccessory`. They are not used, because the system bar cannot hold the separate Capture circle. The custom bar itself was decided on 2026-10-30.
- Four tabs: Today, Inbox, Projects, Habits. A Settings gear is on every root header, Today included. **Decided (2026-11-03):** this follows the handoff. The v3 canvas omits the gear on Today.
- The tab bar hides on pushed screens (Calendar, Block detail, project detail, Settings) and while Capture is open.
- Pushed screens: Calendar (from "Today ▾"), Block detail, project detail, Settings and its groups. Sheets: Plan hub, Capture, Quick review, Inbox drawer (medium detent), Before and after, I'm stuck, End Focus. Full-screen cover: Focus, onboarding. Dialogs: sync conflict, delete.
- Capture sits above the system keyboard. The mockup draws a fake keyboard. Do not build it.
- Lists with swipe actions: `List` with `.swipeActions`. The Inbox places with a leading swipe and deletes with a trailing swipe (decided 2026-10-30). Native swipe buttons use `Color.swipeActionTint`: `surface-raised` in dark, a dark neutral in light, because the system draws the icon white.
- Drag and drop: use `.draggable` and `.dropDestination` on timeline gaps.
- Calendar: EventKit. Events are read-only. Synced blocks are written to one dedicated calendar (two-way sync, decided 2026-11-03).
- AI: on-device only (Apple Foundation Models) with a deterministic fallback. **Decided (2026-11-03).** See [Plan hub suggestions](../features/plan-my-day-suggestions.md).
- Live Activity: ActivityKit and a widget extension.
- Dictation in Capture: the Speech framework.
- Haptics: `.sensoryFeedback`. Settings has a Haptics switch.
