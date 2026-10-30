import SwiftUI

/// One block on the timeline: time label, pill with rail, text, and check.
/// A routine shows its steps. The active block shows Focus, a timer, and the now line.
/// See docs/screens/today.md.
struct BlockRow: View {
    var block: Block
    var now: Date
    var overlaps = false

    @Environment(PlannerStore.self) private var store
    @Environment(AppRouter.self) private var router

    private var isActive: Bool { Timeline.isActive(block, at: now) }
    private var isEvent: Bool { block.kind == .event }
    private var pillHeight: CGFloat { Timeline.pillHeight(for: block) }
    private var color: Color { block.color?.color ?? .surfaceRaised }

    var body: some View {
        HStack(alignment: .top, spacing: LunaSpacing.Timeline.columnGap) {
            Text(TimeText.time(block.start))
                .lunaTextStyle(.timeLabel)
                .foregroundStyle(Color.textTertiary)
                .padding(.top, 6)
                .frame(width: LunaSpacing.Timeline.timeColumn, alignment: .leading)
                .accessibilityHidden(true)

            VStack(spacing: 0) {
                BlockPill(
                    appearance: BlockPill.Appearance(block: block, now: now),
                    systemImage: block.icon,
                    height: pillHeight,
                    iconAtTop: block.isRoutine,
                    accessibilityLabel: "Edit \(block.title)",
                    action: isEvent ? nil : { router.editingBlockID = block.id }
                )
                DashedRail().frame(minHeight: 14, maxHeight: .infinity)
            }
            .frame(width: LunaSpacing.Timeline.pillColumn)

            content
                .frame(minHeight: pillHeight, alignment: block.isRoutine ? .top : .center)
                .padding(.bottom, 14)
                .frame(maxWidth: .infinity, alignment: .leading)

            Group {
                if !isEvent {
                    CheckCircle(isOn: block.isDone, tint: color) { store.toggleDone(blockID: block.id) }
                }
            }
            .frame(width: LunaSpacing.Timeline.checkColumn, height: pillHeight)
        }
        .fixedSize(horizontal: false, vertical: true)
        .overlay(alignment: .topLeading) {
            if isActive {
                let offset = pillHeight * Timeline.progress(of: block, at: now)
                NowLine(time: now)
                    .alignmentGuide(.top) { $0[VerticalAlignment.center] - offset }
            }
        }
    }

    private var content: some View {
        VStack(alignment: .leading, spacing: 3) {
            VStack(alignment: .leading, spacing: 3) {
                HStack(spacing: 5) {
                    if isEvent {
                        Image(systemName: "calendar").font(.system(size: 12, weight: .medium))
                    }
                    Text(meta)
                        .monospacedDigit()
                }
                .lunaTextStyle(.meta)
                .foregroundStyle(Color.textSecondary)

                Text(block.title)
                    .lunaTextStyle(.rowTitle)
                    .strikethrough(block.isDone)
                    .foregroundStyle(titleColor)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(accessibilityText)

            if block.isRoutine {
                RoutineSteps(block: block)
            }
            if isActive {
                ActiveControls(block: block)
            }
        }
    }

    private var titleColor: Color {
        let isPastEvent = isEvent && block.end <= now
        return block.isDone || isPastEvent ? .textTertiary : .textPrimary
    }

    /// "9:30 – 11:00 · 1 h 30 min", "· 40 min left" when active, or "· Work" for an event.
    private var meta: String {
        var parts = [TimeText.range(block)]
        if isEvent {
            if let name = block.calendarName { parts.append(name) }
        } else if isActive {
            parts.append("\(Timeline.minutesLeft(of: block, at: now)) min left")
        } else {
            parts.append(DurationFormat.string(minutes: block.durationMinutes))
        }
        if overlaps { parts.append("Overlaps") }
        return parts.joined(separator: " · ")
    }

    private var accessibilityText: String {
        var parts = [block.title, meta]
        if block.isDone { parts.append("Done") }
        if isEvent { parts.append("Calendar event") }
        return parts.joined(separator: ", ")
    }
}

/// The steps of a routine with 18 pt checks, a 48 × 4 pt bar, and "1/3".
private struct RoutineSteps: View {
    var block: Block

    @Environment(PlannerStore.self) private var store
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        let color = block.color?.color ?? .textPrimary
        let done = block.steps.filter(\.done).count
        VStack(alignment: .leading, spacing: 2) {
            ForEach(block.steps) { step in
                HStack(spacing: 0) {
                    CheckCircle(isOn: step.done, tint: color, size: .small, label: step.title) {
                        store.toggleStep(blockID: block.id, stepID: step.id)
                    }
                    .padding(.leading, -13)
                    Text(step.title)
                        .lunaTextStyle(.body)
                        .strikethrough(step.done)
                        .foregroundStyle(step.done ? Color.textTertiary : Color.textPrimary)
                        .padding(.leading, -3)
                        .accessibilityHidden(true)
                }
                .frame(minHeight: 30)
            }
            HStack(spacing: 8) {
                Capsule()
                    .fill(Color.surfaceTertiary)
                    .frame(width: 48, height: 4)
                    .overlay(alignment: .leading) {
                        Capsule()
                            .fill(color)
                            .frame(width: 48 * Double(done) / Double(max(block.steps.count, 1)))
                            .animation(LunaMotion.animation(.easeOut(duration: LunaMotion.normal), reduceMotion: reduceMotion), value: done)
                    }
                Text("\(done)/\(block.steps.count)")
                    .lunaTextStyle(.timeLabel)
                    .foregroundStyle(Color.textTertiary)
            }
            .padding(.top, 4)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("\(done) of \(block.steps.count) steps done")
        }
        .padding(.top, 6)
    }
}

/// The Focus button and the remaining-time capsule of the active block.
private struct ActiveControls: View {
    var block: Block

    @Environment(AppRouter.self) private var router
    @Environment(\.appClock) private var clock

    var body: some View {
        HStack(spacing: 8) {
            Button {
                router.focusBlockID = block.id
            } label: {
                Label("Focus", systemImage: "play.fill")
                    .labelStyle(CompactIconLabelStyle())
                    .font(.subheadline.weight(.semibold))
                    .fixedSize()
                    .foregroundStyle(Color.actionPrimaryForeground)
                    .padding(.leading, 11)
                    .padding(.trailing, 14)
                    .frame(height: 32)
                    .background(Color.actionPrimaryBackground, in: Capsule())
                    .frame(minHeight: LunaSpacing.minHitTarget)
                    .contentShape(Rectangle())
            }
            .buttonStyle(PressScaleButtonStyle(scale: LunaMotion.PressScale.standard))

            TimelineView(.periodic(from: .now, by: 1)) { _ in
                let seconds = Int(block.end.timeIntervalSince(clock.now()).rounded(.down))
                Text(TimeText.countdown(seconds: seconds))
                    .font(.subheadline.weight(.semibold))
                    .monospacedDigit()
                    .fixedSize()
                    .foregroundStyle(Color.textPrimary)
                    .padding(.horizontal, 12)
                    .frame(height: 32)
                    .background(Color.surfacePrimary, in: Capsule())
                    .accessibilityLabel("Time left")
                    .accessibilityValue(TimeText.countdown(seconds: seconds))
            }
        }
        .padding(.top, 2)
    }
}

/// A 12 pt icon and a title with a 6 pt gap.
private struct CompactIconLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 6) {
            configuration.icon.font(.system(size: 12, weight: .bold))
            configuration.title
        }
    }
}

/// The 2 pt now line with its time capsule. It crosses the active pill.
struct NowLine: View {
    var time: Date

    var body: some View {
        HStack(spacing: 0) {
            Text(TimeText.time(time))
                .font(.system(size: 11, weight: .bold))
                .monospacedDigit()
                .foregroundStyle(Color.textInverse)
                .padding(.horizontal, 6)
                .padding(.vertical, 4)
                .background(Color.textPrimary, in: Capsule())
            Rectangle().fill(Color.textPrimary).frame(height: 2)
        }
        .frame(width: 118)
        .allowsHitTesting(false)
        .accessibilityLabel("Now, \(TimeText.time(time))")
    }
}

#Preview("Dark") {
    BlockRowPreview().preferredColorScheme(.dark)
}

#Preview("Light") {
    BlockRowPreview().preferredColorScheme(.light)
}

private struct BlockRowPreview: View {
    @State private var store = PlannerStore.sample()

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(store.blocks(on: SampleData.now, calendar: SampleData.calendar).prefix(6)) { block in
                    BlockRow(block: block, now: SampleData.now)
                }
            }
            .padding(.horizontal, LunaSpacing.screenMargin)
        }
        .background(Color.bgCanvas)
        .environment(store)
        .environment(AppRouter())
        .environment(\.appClock, .fixed(SampleData.now))
    }
}
