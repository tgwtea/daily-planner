import SwiftUI

/// One habit on the Habits tab: icon, name, streak, a log button, and the current week. See docs/screens/habits.md.
/// A tap on the card outside the log button selects the habit for the history card.
struct HabitCard: View {
    var habit: Habit
    var today: Date
    var calendar: Calendar
    var isSelected: Bool
    var onLog: () -> Void
    var onSelect: () -> Void

    var body: some View {
        let value = habit.value(on: today, calendar: calendar)
        let isDone = habit.isDone(on: today, calendar: calendar)
        let streak = HabitStats.streak([habit], today: today, calendar: calendar)
        VStack(spacing: 14) {
            HStack(spacing: 12) {
                summary(value: value, streak: streak)
                CheckCircle(
                    isOn: isDone,
                    tint: habit.color.color,
                    size: .large,
                    label: "Log \(habit.name)",
                    count: habit.goal > 1 ? value : nil,
                    action: onLog
                )
                .accessibilityValue(isDone ? "Done" : "\(value) of \(habit.goal)")
            }
            weekRow(isDoneToday: isDone)
        }
        .padding(16)
        .background(Color.surfacePrimary, in: RoundedRectangle(cornerRadius: LunaRadius.card))
        .overlay {
            // Assumption: the mockup has no selected card. A ring shows which habit the history card shows.
            RoundedRectangle(cornerRadius: LunaRadius.card)
                .strokeBorder(Color.borderStrong, lineWidth: 1.5)
                .opacity(isSelected ? 1 : 0)
        }
        .contentShape(RoundedRectangle(cornerRadius: LunaRadius.card))
        .onTapGesture(perform: onSelect)
    }

    private func summary(value: Int, streak: Int) -> some View {
        HStack(spacing: 12) {
            IconTile(systemImage: habit.icon, color: habit.color, size: 40, cornerRadius: 14)
            VStack(alignment: .leading, spacing: 3) {
                Text(habit.name)
                    .lunaTextStyle(.rowTitle)
                    .foregroundStyle(Color.textPrimary)
                Text(subtitle(value: value))
                    .lunaTextStyle(.meta)
                    .monospacedDigit()
                    .foregroundStyle(Color.textSecondary)
            }
            .lineLimit(1)
            Spacer(minLength: 0)
            HStack(spacing: 4) {
                Image(systemName: "flame")
                    .font(.footnote.weight(.semibold))
                Text(streak, format: .number)
                    .lunaTextStyle(.label)
                    .monospacedDigit()
            }
            .foregroundStyle(streak == 0 ? Color.textTertiary : Color.textPrimary)
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(habit.name), \(subtitle(value: value)), \(streak) day streak")
        .accessibilityHint("Shows this habit in the history card")
        .accessibilityAddTraits(isSelected ? [.isButton, .isSelected] : .isButton)
        .accessibilityAction(.default, onSelect)
    }

    private func subtitle(value: Int) -> String {
        habit.goal > 1 ? "\(value) of \(habit.goal) · \(habit.subtitle)" : habit.subtitle
    }

    private func weekRow(isDoneToday: Bool) -> some View {
        let days = Week.days(containing: today, calendar: calendar)
        let todayStart = calendar.startOfDay(for: today)
        let doneDays = days.filter { $0 <= todayStart && habit.isDone(on: $0, calendar: calendar) }
        return HStack(spacing: 6) {
            ForEach(days, id: \.self) { day in
                VStack(spacing: 6) {
                    // 11 pt medium.
                    Text(day.formatted(.dateTime.weekday(.narrow)))
                        .font(.caption2.weight(.medium))
                        .foregroundStyle(Color.textTertiary)
                    dot(isDone: doneDays.contains(day), isToday: day == todayStart)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("This week")
        .accessibilityValue(doneDays.isEmpty
            ? "No days done"
            : "Done on " + doneDays.map { $0.formatted(.dateTime.weekday(.wide)) }.formatted(.list(type: .and)))
    }

    private func dot(isDone: Bool, isToday: Bool) -> some View {
        Circle()
            .fill(isDone ? habit.color.color : .clear)
            .strokeBorder(
                isDone ? Color.clear : (isToday ? Color.textSecondary : Color.surfaceTertiary),
                lineWidth: 2
            )
            .frame(width: 24, height: 24)
    }
}

#Preview("Dark") {
    HabitCardPreview().preferredColorScheme(.dark)
}

#Preview("Light") {
    HabitCardPreview().preferredColorScheme(.light)
}

private struct HabitCardPreview: View {
    @State private var store = PlannerStore.sample()

    var body: some View {
        VStack(spacing: 10) {
            ForEach(store.habits.prefix(3)) { habit in
                HabitCard(
                    habit: habit, today: SampleData.now, calendar: SampleData.calendar, isSelected: habit.name == "Stretch",
                    onLog: { store.logHabit(id: habit.id, on: SampleData.now, calendar: SampleData.calendar) },
                    onSelect: {}
                )
            }
        }
        .padding(LunaSpacing.screenMargin)
        .frame(maxHeight: .infinity)
        .background(Color.bgCanvas)
    }
}
