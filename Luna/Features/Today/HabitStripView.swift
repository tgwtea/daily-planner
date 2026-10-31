import SwiftUI

/// A sideways row of habit rings on Today. A tap on a ring logs the habit on the shown day.
/// See docs/screens/today.md.
struct HabitStripView: View {
    var habits: [Habit]
    var day: Date
    var calendar: Calendar
    /// `false` on a future day (decided 2026-10-31).
    var canLog = true
    var onLog: (Habit.ID) -> Void = { _ in }

    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 12) {
                ForEach(habits) { habit in
                    Button { onLog(habit.id) } label: {
                        cell(habit)
                    }
                    .buttonStyle(PressScaleButtonStyle(scale: LunaMotion.PressScale.standard))
                    .disabled(!canLog)
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
        .contentShape(Rectangle())
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(canLog ? "Log \(habit.name)" : habit.name)
        .accessibilityValue(isDone ? "Done" : "\(value) of \(habit.goal)")
    }
}

#Preview("Dark") {
    HabitStripPreview().preferredColorScheme(.dark)
}

#Preview("Light") {
    HabitStripPreview().preferredColorScheme(.light)
}

private struct HabitStripPreview: View {
    @State private var store = PlannerStore.sample()

    var body: some View {
        HabitStripView(habits: store.habits, day: SampleData.now, calendar: SampleData.calendar) { id in
            store.logHabit(id: id, on: SampleData.now, calendar: SampleData.calendar)
        }
        .frame(maxHeight: .infinity)
        .background(Color.bgCanvas)
    }
}
