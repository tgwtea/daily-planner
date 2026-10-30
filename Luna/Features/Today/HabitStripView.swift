import SwiftUI

/// A sideways row of habit rings on Today. Display only until checkpoint 1b.3 adds logging.
/// See docs/screens/today.md.
struct HabitStripView: View {
    var habits: [Habit]
    var day: Date
    var calendar: Calendar

    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 12) {
                ForEach(habits) { habit in
                    cell(habit)
                }
            }
            .padding(.horizontal, LunaSpacing.screenMargin)
            .padding(.bottom, 4)
        }
        .scrollIndicators(.hidden)
    }

    private func cell(_ habit: Habit) -> some View {
        let value = habit.value(on: day, calendar: calendar)
        let isDone = habit.isDone(on: day, calendar: calendar)
        return VStack(spacing: 8) {
            ProgressRing(progress: Double(value) / Double(max(habit.goal, 1)), color: habit.color.color) {
                ZStack {
                    Circle().fill(isDone ? habit.color.color : Color.surfacePrimary)
                    Image(systemName: habit.icon)
                        .font(.system(size: 22, weight: .regular))
                        .foregroundStyle(isDone ? BlockColor.ink : Color.textPrimary)
                }
            }
            Text(habit.goal > 1 ? "\(value)/\(habit.goal)" : habit.name)
                .lunaTextStyle(.timeLabel)
                .foregroundStyle(Color.textSecondary)
                .lineLimit(1)
        }
        .frame(width: 66)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(habit.name)
        .accessibilityValue(isDone ? "Done" : "\(value) of \(habit.goal)")
    }
}

#Preview("Dark") {
    HabitStripView(habits: PlannerStore.sample().habits, day: SampleData.now, calendar: SampleData.calendar)
        .frame(maxHeight: .infinity)
        .background(Color.bgCanvas)
        .preferredColorScheme(.dark)
}

#Preview("Light") {
    HabitStripView(habits: PlannerStore.sample().habits, day: SampleData.now, calendar: SampleData.calendar)
        .frame(maxHeight: .infinity)
        .background(Color.bgCanvas)
        .preferredColorScheme(.light)
}
