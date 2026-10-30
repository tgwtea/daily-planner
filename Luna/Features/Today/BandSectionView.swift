import SwiftUI

/// One band: the chip header with progress and "+", then its rows or a summary line.
/// See docs/features/timeline-and-day-bands.md.
struct BandSectionView: View {
    var section: DayPlan.BandSection
    var now: Date
    var overlappingIDs: Set<Block.ID>
    @Binding var isCollapsed: Bool

    @Environment(AppRouter.self) private var router
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private var isOpen: Bool { !isCollapsed && !section.blocks.isEmpty }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            header
            if isOpen {
                VStack(spacing: 0) {
                    ForEach(section.rows) { row in
                        switch row {
                        case .block(let block):
                            BlockRow(block: block, now: now, overlaps: overlappingIDs.contains(block.id))
                                .id(block.id)
                        case .gap(let gap):
                            FreeGapRow(gap: gap)
                        }
                    }
                }
            } else {
                Text(summary)
                    .font(.subheadline)
                    .monospacedDigit()
                    .foregroundStyle(Color.textSecondary)
                    .padding(.horizontal, 4)
            }
        }
    }

    private var header: some View {
        HStack(spacing: 8) {
            ChipButton(
                title: section.band.displayName,
                systemImage: section.band.systemImage,
                count: section.blocks.count,
                isExpanded: !isCollapsed
            ) {
                withAnimation(LunaMotion.animation(.easeInOut(duration: LunaMotion.normal), reduceMotion: reduceMotion)) {
                    isCollapsed.toggle()
                }
            }
            .fixedSize()
            Spacer(minLength: 0)
            let count = section.doneCount
            if count.total > 0 {
                Text("\(count.done) of \(count.total) done")
                    .lunaTextStyle(.meta)
                    .monospacedDigit()
                    .foregroundStyle(Color.textTertiary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            RoundAddButton(label: "Add to \(section.band.displayName)") { router.openQuickAdd() }
        }
    }

    /// "4 blocks · 3 h 15 min", or "Nothing planned".
    private var summary: String {
        let count = section.blocks.count
        guard count > 0 else { return "Nothing planned" }
        return "\(count) \(count == 1 ? "block" : "blocks") · \(DurationFormat.string(minutes: section.totalMinutes))"
    }
}

/// Unplanned time between two blocks: "45 min free".
struct FreeGapRow: View {
    var gap: FreeGap

    var body: some View {
        HStack(alignment: .top, spacing: LunaSpacing.Timeline.columnGap) {
            Text(TimeText.time(gap.start))
                .lunaTextStyle(.timeLabel)
                .foregroundStyle(Color.textTertiary)
                .padding(.top, 2)
                .frame(width: LunaSpacing.Timeline.timeColumn, alignment: .leading)
            DashedRail()
                .frame(width: LunaSpacing.Timeline.pillColumn)
                .frame(maxHeight: .infinity)
            Text("\(DurationFormat.string(minutes: gap.minutes)) free")
                .lunaTextStyle(.meta)
                .monospacedDigit()
                .foregroundStyle(Color.textTertiary)
                .padding(.bottom, 12)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        }
        .frame(minHeight: 46)
        .fixedSize(horizontal: false, vertical: true)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(DurationFormat.string(minutes: gap.minutes)) free from \(TimeText.time(gap.start))")
    }
}

#Preview("Dark") {
    BandSectionPreview().preferredColorScheme(.dark)
}

#Preview("Light") {
    BandSectionPreview().preferredColorScheme(.light)
}

private struct BandSectionPreview: View {
    @State private var store = PlannerStore.sample()
    @State private var collapsed = false

    var body: some View {
        let plan = DayPlan.make(
            blocks: store.blocks(on: SampleData.now, calendar: SampleData.calendar),
            schedule: .standard, calendar: SampleData.calendar, showFreeTime: true
        )
        ScrollView {
            BandSectionView(section: plan.sections[0], now: SampleData.now, overlappingIDs: [], isCollapsed: $collapsed)
                .padding(.horizontal, LunaSpacing.screenMargin)
        }
        .background(Color.bgCanvas)
        .environment(store)
        .environment(AppRouter())
        .environment(\.appClock, .fixed(SampleData.now))
    }
}
