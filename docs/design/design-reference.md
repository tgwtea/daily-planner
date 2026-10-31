# Design reference

This is the central visual reference for Luna. Screen specs link here for shared values. They do not repeat them.

## Source

| Item | Value |
| --- | --- |
| Tool | Claude Design |
| Project | "Form submission waiting" (ID `feb8e067-7716-40d0-86ee-981e9a51c289`) |
| URL | https://claude.ai/design/p/feb8e067-7716-40d0-86ee-981e9a51c289?file=Plan+My+Day+v2.dc.html |
| Canvas file | `Plan My Day v2.dc.html`. It lists artboards 2a–2q with captions. |
| Prototype file | `Plan My Day v2 App.dc.html`. It holds all markup, logic, and sample data. This is the main source. |
| Runtime | `support.js`. The generic Claude Design template runtime. It has no product content. |
| Design system | `_ds/noir-design-system-…/` ("Noir"). Its tokens are in `tokens/*.css` and its guidance is in `readme.md`. |
| Superseded | `Plan My Day.dc.html` and `Plan My Day App.dc.html` (v1). Do not use them. |
| Not inspected | `uploads/refs-*.webp`, `uploads/refs-*.png` (two reference images). |

Inspected on 2026-10-30. If the design changes, update this file and the affected specs.

The canvas describes the app as a calm, reliable time blocker. It names its inspirations: a Structured-style timeline, Tiimo-style day bands, a Things-like Projects tab, TickTick-style calendar views and habits, and Todoist-style quick add.

### Artboards

| ID | Caption | Screen spec |
| --- | --- | --- |
| 2a | Interactive · scrolls to now | [Today](../screens/today.md) |
| 2b | Top of the day · habits · Anytime | [Today](../screens/today.md) |
| 2c | Now line · timer inside the active block | [Today](../screens/today.md) |
| 2d | Inbox drawer · dragging into a free gap | [Inbox drawer](../screens/inbox-drawer.md) |
| 2e | Empty day | [Today](../screens/today.md) |
| 2f | Light | [Today](../screens/today.md) |
| 2g | Quick add · parsed as you type | [Quick add](../screens/quick-add.md) |
| 2h | Edit block · color, icon, checklist | [Edit block](../screens/edit-block.md) |
| 2i | Full-screen focus | [Focus](../screens/focus.md) |
| 2j | Lock screen · Live Activity + Dynamic Island | [Live Activity](../screens/live-activity.md) |
| 2k | Inbox · swipe to place | [Inbox](../screens/inbox.md) |
| 2l | Projects · Upcoming, Anytime, Someday | [Projects](../screens/projects.md) |
| 2m | Habits · streaks + heatmap | [Habits](../screens/habits.md) |
| 2n | Settings | [Settings](../screens/settings.md) |
| 2o | 3 days | [Calendar](../screens/calendar.md) |
| 2p | Month | [Calendar](../screens/calendar.md) |
| 2q | Plan my day · suggestion sheet | [Plan my day](../screens/plan-my-day.md) |

The repository holds no exported PNGs of these artboards. To compare a screen, read the artboard from the design project. Decided (2026-10-31).

The mockup frame is 440 × 956 pt with a 66 pt corner radius. It draws a mock status bar, Dynamic Island, and home indicator. Do not draw these in the app. iOS provides them.

## Principles

From the Noir readme: "Typography creates hierarchy. Solid surfaces organize content. Glass reveals interaction. Everything else stays quiet."

- The UI is monochrome. Color appears only on blocks, habits, and projects that the user colors. Each block has one muted color and one line icon.
- Dark is the default theme. Light is a full alternate theme (artboard 2f).
- Solid graphite surfaces hold content. Glass is only for floating or temporary layers: tab bar, Inbox pill, sheets, Live Activity.
- Copy is calm and plain. Use sentence case. Buttons are verbs. Empty states say the situation, then the next step. No emoji in UI chrome. The metadata separator is a middle dot with spaces: "9:30 – 11:00 · 1 h 30 min".

## Color

Use semantic roles in code. Do not use raw palette values.

In code: `Color` static properties in `Luna/Shared/Design/LunaColor.swift`. The property name is the role in camel case, for example `Color.surfacePrimary`. `action-primary-bg` / `-fg` are `actionPrimaryBackground` / `actionPrimaryForeground`. `glass-bg` is `glassBackground`. The Inbox drawer scrim is `drawerScrim`.

| Role | Dark | Light | Use |
| --- | --- | --- | --- |
| `bg-canvas` | `#000000` | `#FFFFFF` | Screen background |
| `bg-secondary` | `#1A1A1A` | `#F5F5F5` | Keyboard area in quick add |
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

Status colors exist in Noir (`#FF6961`, `#FFB340`, `#32D74B`, `#64B5FF` in dark). The mockup does not use them.

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
- A done block uses its color mixed 38% with the canvas, in oklch. A done icon uses ink at 55% opacity.
  - **Assumption (1a.2):** SwiftUI has no oklch mix. The app uses `Color.mix(with:by:in: .perceptual)`, the nearest native color space.
- The habit heatmap uses Slate mixed 35–100% with the canvas.

## Typography

The font is the system font (SF Pro). Use tabular figures for every time, count, and timer. The mockup sets sizes in points:

| Use | Size / weight | Tracking |
| --- | --- | --- |
| Lock screen clock | 104 bold | −0.045 em |
| Focus timer | 72 bold | −0.035 em |
| Large screen title (Today, Inbox, …) | 34 bold | −0.025 em |
| Calendar title | 28 bold | −0.02 em |
| Edit block title | 26 bold | −0.02 em |
| Sheet title, Live Activity timer | 24–30 bold | −0.02 em |
| Section heading, empty-state title | 20 semibold | −0.01 em |
| Row and block title | 17 semibold | — |
| Day number in week strip | 17 semibold | — |
| Body, step text | 15–16 regular | — |
| Band chip label, buttons | 14–15 semibold | — |
| Meta line, caption | 13 regular | — |
| Time label, weekday | 12 medium | — |
| Tab label | 10 semibold | — |

Noir defines a type scale (display 48/38, heading 30/24/20, body 17/16, label 15/14, caption 13/12). Map the rows above to Dynamic Type styles: 34 → `.largeTitle`, 20 → `.title3`, 17 → `.headline`/`.body`, 15 → `.subheadline`, 13 → `.footnote`, 12 → `.caption`. Fixed sizes such as the timers use `Font.system(size:weight:)` and scale with `@ScaledMetric`.

In code: `View.lunaTextStyle(_:)` with one `LunaTextStyle` case per row above (`Luna/Shared/Design/LunaTextStyle.swift`). Each style scales with Dynamic Type relative to the mapped text style. Times, counts, and timers get tabular figures. **Assumption (1a.2):** for a range, the style uses the low value (sheet title 24, body 16, label 15). The Live Activity timer is 30.

## Spacing and size

- 4 pt rhythm. Screen side margin 20 pt. Week strip margin 12 pt.
- Gap between sections: 22–28 pt. Gap between a section header and its group: 8–14 pt.
- Grouped list row padding: 10–14 pt vertical, 14–16 pt horizontal. Card padding: 20 pt.
- Minimum hit target: 44 × 44 pt. Small visual controls (34 pt chips, 26 pt check circles) get a 44 pt hit area.
- Timeline grid columns: 44 pt time label, 52 pt pill, flexible text, 44 pt check. Column gap 12 pt.

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
- No bounce loops, parallax, or decorative motion. Reduce Motion sets durations to zero.
- In code: `LunaMotion` (`Luna/Shared/Design/LunaMotion.swift`). `LunaMotion.animation(_:reduceMotion:)` returns `nil` under Reduce Motion.

## Reusable patterns

These patterns appear on two or more screens. Build each one as a shared view when the second screen needs it.

| Pattern | Where | Description |
| --- | --- | --- |
| Large title header | Today, Inbox, Projects, Habits, Settings | 34 pt bold title, optional 15 pt secondary line above or below |
| Capsule chip button | Band headers, Anytime, Plan, quick-add chips | 34 pt (30 pt in quick add) capsule on `surface-primary` or `surface-hover`, icon + label + count |
| Round add button | Band headers, Anytime | 34 pt circle, plus icon |
| Check circle | Blocks, Anytime, steps, habits, proposals | 26 pt (18–30 pt variants) ring in the block color. Filled with the color and an ink check when done. |
| Colored icon tile | Anytime, Inbox, habits, drawer, proposals | 36–40 pt rounded square or circle in the block color, ink icon |
| Grouped list | Projects, Settings, Edit block, Inbox | `surface-primary`, radius 20, hairline dividers between rows |
| Settings row | Settings, Projects, Edit block | Leading 32 pt icon box, title, trailing value, chevron or switch |
| Progress ring | Habits strip, projects | Circular stroke in the item color on a `surface-tertiary` track |
| Glass sheet | Quick add, drawer, Plan | Radius 36 top corners, grabber 36 × 5 pt |
| Floating tab bar | Main tabs | Glass capsule, 64 pt high, 5 tabs, plus a separate 64 pt primary "+" circle |
| Segmented control | Calendar | Day, 3 days, Week, Month |
| Selected-day fill | Week strip, calendar, month | Circle filled with `text-primary`, number in `text-inverse` |

In code (1a.5): `Luna/Shared/Components/`. `LargeTitleHeader`, `ChipButton` (34 pt, `isCompact` 30 pt), `RoundAddButton`, `CheckCircle` (`.small` 18, `.regular` 26, `.large` 30), `IconTile`, `GroupedList` with `GroupedRow`, `ProgressRing`, and `BlockPill` (the timeline pill). The tab bar is `LunaTabBar`. Glass is `View.lunaGlass(in:)` (`LunaGlass.swift`). The other patterns come with their screens.

Component values from the prototype (read 2026-10-31):

- Pill: fill rules in [Today](../screens/today.md#states). Done wins over active. The active fill is a hard stop at the progress point. Icon 20 pt. A routine pill shows its icon at the top.
- Check circle: ring 2 pt (1.75 pt at 18 pt). Check 14 pt (11 pt at 18 pt). The ring takes the block color. Edit block steps use `border-strong` when off. Plan proposals fill with `text-primary` and a `text-inverse` check.
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

The candidates are assumptions. Check each one in the SF Symbols app.

## Native SwiftUI notes

- Tab bar: use `TabView` with five `Tab`s and hide the system tab bar. **Decided (2026-10-30):** a custom floating tab bar draws the design: a glass capsule with five tabs and a separate primary "+" circle. A system bar with five tabs fills the iPhone width, so a "+" circle cannot sit next to it. See [screens/README.md](../screens/README.md#navigation-map).
- Sheets: use `.sheet` with `presentationDetents`. The Inbox drawer is a medium detent (440 of 956 pt). Quick add sits above the system keyboard. The mockup draws a fake keyboard. Do not build it.
- Lists with swipe actions: `List` with `.swipeActions`. The Inbox places with a leading swipe and deletes with a trailing swipe (decided 2026-10-30). Native swipe buttons use `Color.swipeActionTint`: `surface-raised` in dark, a dark neutral in light, because the system draws the icon white.
- Drag and drop: use `.draggable` and `.dropDestination` on timeline gaps.
- Calendar events: EventKit, read-only.
- Live Activity: ActivityKit and a widget extension.
- Haptics: `.sensoryFeedback`. Settings has a Haptics switch.
