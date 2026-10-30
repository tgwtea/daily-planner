import SwiftUI

/// A day with no blocks: three dashed ghost pills, then a card with "Add block" and "Open Inbox".
/// See docs/screens/today.md#states.
struct EmptyDayView: View {
    var day: Date
    var schedule: BandSchedule
    var calendar: Calendar

    @Environment(AppRouter.self) private var router

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            VStack(spacing: 0) {
                ForEach(Band.allCases) { band in
                    ghostRow(band)
                }
            }
            .padding(.top, 4)
            card
        }
    }

    private func ghostRow(_ band: Band) -> some View {
        HStack(alignment: .top, spacing: LunaSpacing.Timeline.columnGap) {
            Text(TimeText.time(minute: Timeline.ghostMinute(for: band, schedule: schedule), on: day, calendar: calendar))
                .lunaTextStyle(.timeLabel)
                .foregroundStyle(Color.textTertiary)
                .padding(.top, 8)
                .frame(width: LunaSpacing.Timeline.timeColumn, alignment: .leading)
            VStack(spacing: 0) {
                Capsule()
                    .strokeBorder(Color.borderStrong, style: StrokeStyle(lineWidth: 2, dash: [5, 4]))
                    .frame(width: LunaSpacing.Timeline.pillColumn, height: 60)
                    .overlay {
                        Image(systemName: band.systemImage)
                            .font(.system(size: 20))
                            .foregroundStyle(Color.textTertiary)
                    }
                DashedRail(color: .borderSubtle).frame(height: 22)
            }
            VStack(alignment: .leading, spacing: 3) {
                Text(band.displayName)
                    .lunaTextStyle(.rowTitle)
                    .foregroundStyle(Color.textSecondary)
                Text("Free")
                    .lunaTextStyle(.meta)
                    .foregroundStyle(Color.textTertiary)
            }
            .frame(minHeight: 60)
            Spacer(minLength: 0)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(band.displayName), free")
    }

    private var card: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 6) {
                Text("\(TimeText.weekday(day)) is wide open")
                    .lunaTextStyle(.sectionHeading)
                    .foregroundStyle(Color.textPrimary)
                    .accessibilityAddTraits(.isHeader)
                Text("Add a block, or bring something in from Inbox.")
                    .font(.subheadline)
                    .foregroundStyle(Color.textSecondary)
            }
            HStack(spacing: 10) {
                Button("Add block", systemImage: "plus") { router.openQuickAdd() }
                    .buttonStyle(CapsuleButtonStyle(isPrimary: true))
                // Temporary: the Inbox drawer comes in 1c.2 (decided 2026-10-31).
                Button("Open Inbox", systemImage: "tray") { router.selectedTab = .inbox }
                    .buttonStyle(CapsuleButtonStyle(isPrimary: false))
            }
        }
        .padding(.top, 24)
        .padding([.horizontal, .bottom], LunaSpacing.cardPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.surfacePrimary, in: RoundedRectangle(cornerRadius: LunaRadius.card))
    }
}

/// A 44 pt capsule button: primary (`action-primary`) or secondary (`surface-tertiary`).
private struct CapsuleButtonStyle: ButtonStyle {
    var isPrimary: Bool
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .labelStyle(TitleAndIconLabelStyle())
            .font(.subheadline.weight(.semibold))
            .foregroundStyle(isPrimary ? Color.actionPrimaryForeground : Color.textPrimary)
            .padding(.horizontal, 18)
            .frame(minHeight: LunaSpacing.minHitTarget)
            .background(isPrimary ? Color.actionPrimaryBackground : Color.surfaceTertiary, in: Capsule())
            .scaleEffect(PressScaleButtonStyle.effectiveScale(
                LunaMotion.PressScale.standard, isPressed: configuration.isPressed, reduceMotion: reduceMotion
            ))
    }
}

#Preview("Dark") {
    EmptyDayView(day: SampleData.date(dayOffset: 6, minute: 0), schedule: .standard, calendar: SampleData.calendar)
        .padding(LunaSpacing.screenMargin)
        .frame(maxHeight: .infinity)
        .background(Color.bgCanvas)
        .environment(AppRouter())
        .preferredColorScheme(.dark)
}

#Preview("Light") {
    EmptyDayView(day: SampleData.date(dayOffset: 6, minute: 0), schedule: .standard, calendar: SampleData.calendar)
        .padding(LunaSpacing.screenMargin)
        .frame(maxHeight: .infinity)
        .background(Color.bgCanvas)
        .environment(AppRouter())
        .preferredColorScheme(.light)
}
