import SwiftUI

/// The 12-week heatmap and three numbers on the Habits tab. See docs/screens/habits.md.
/// It shows all habits together, or one habit when the user selects a habit card.
struct HabitHistoryCard: View {
    var title: String
    /// One habit, or all habits.
    var habits: [Habit]
    var color: BlockColor
    var today: Date
    var calendar: Calendar

    var body: some View {
        let monthPercent = HabitStats.monthPercent(habits, today: today, calendar: calendar)
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .firstTextBaseline, spacing: 12) {
                Text(title)
                    .lunaTextStyle(.rowTitle)
                    .foregroundStyle(Color.textPrimary)
                    .lineLimit(1)
                    .accessibilityAddTraits(.isHeader)
                Spacer(minLength: 0)
                Text("Last 12 weeks")
                    .lunaTextStyle(.meta)
                    .foregroundStyle(Color.textSecondary)
                    .accessibilityHidden(true)
            }
            heatmap
                .accessibilityElement(children: .ignore)
                .accessibilityLabel("\(title), last 12 weeks, \(monthPercent) percent this month")
            HStack(alignment: .top, spacing: 24) {
                stat(HabitStats.streak(habits, today: today, calendar: calendar).formatted(), "Day streak")
                stat("\(monthPercent)%", "This month")
                stat(HabitStats.bestStreak(habits, today: today, calendar: calendar).formatted(), "Best streak")
            }
        }
        .padding(LunaSpacing.cardPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.surfacePrimary, in: RoundedRectangle(cornerRadius: LunaRadius.card))
    }

    private var heatmap: some View {
        let cells = HabitStats.heatmap(habits, today: today, calendar: calendar)
        return HStack(spacing: Self.cellGap) {
            ForEach(0..<HabitStats.heatmapWeeks, id: \.self) { week in
                VStack(spacing: Self.cellGap) {
                    ForEach(0..<7, id: \.self) { row in
                        RoundedRectangle(cornerRadius: 5)
                            .fill(cellColor(cells[week * 7 + row]))
                            .aspectRatio(1, contentMode: .fit)
                    }
                }
            }
        }
    }

    private static let cellGap: CGFloat = 4

    private func cellColor(_ share: Double?) -> Color {
        guard let share, share > 0 else { return .surfaceTertiary }
        return color.color.mix(with: .bgCanvas, by: 1 - HabitStats.heatStrength(share), in: .perceptual)
    }

    private func stat(_ value: String, _ label: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            // 24 pt bold.
            Text(value)
                .lunaTextStyle(.sheetTitle)
                .monospacedDigit()
                .foregroundStyle(Color.textPrimary)
            Text(label)
                .lunaTextStyle(.meta)
                .foregroundStyle(Color.textSecondary)
        }
        .accessibilityElement(children: .combine)
    }
}

#Preview("Dark") {
    HabitHistoryCard(
        title: "All habits", habits: PlannerStore.sample().habits, color: .slate,
        today: SampleData.now, calendar: SampleData.calendar
    )
    .padding(LunaSpacing.screenMargin)
    .frame(maxHeight: .infinity)
    .background(Color.bgCanvas)
    .preferredColorScheme(.dark)
}

#Preview("Light") {
    HabitHistoryCard(
        title: "Water", habits: Array(PlannerStore.sample().habits.prefix(1)), color: .slate,
        today: SampleData.now, calendar: SampleData.calendar
    )
    .padding(LunaSpacing.screenMargin)
    .frame(maxHeight: .infinity)
    .background(Color.bgCanvas)
    .preferredColorScheme(.light)
}
