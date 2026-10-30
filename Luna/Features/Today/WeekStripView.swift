import SwiftUI

/// Seven day cells, Monday to Sunday. A horizontal swipe pages one week. See docs/screens/today.md.
struct WeekStripView: View {
    @Binding var selectedDay: Date
    var today: Date
    var calendar: Calendar
    var hasBlocks: (Date) -> Bool

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        HStack(spacing: 0) {
            ForEach(Week.days(containing: selectedDay, calendar: calendar), id: \.self) { day in
                dayCell(day)
            }
        }
        .padding(.horizontal, LunaSpacing.weekStripMargin)
        .contentShape(Rectangle())
        .gesture(
            DragGesture(minimumDistance: 24).onEnded { value in
                guard abs(value.translation.width) > abs(value.translation.height) else { return }
                page(by: value.translation.width < 0 ? 1 : -1)
            }
        )
        .accessibilityAction(named: "Next week") { page(by: 1) }
        .accessibilityAction(named: "Previous week") { page(by: -1) }
    }

    private func page(by weeks: Int) {
        withAnimation(LunaMotion.animation(LunaMotion.selectionSpring, reduceMotion: reduceMotion)) {
            selectedDay = Week.shift(selectedDay, weeks: weeks, calendar: calendar)
        }
    }

    private func dayCell(_ day: Date) -> some View {
        let isSelected = calendar.isDate(day, inSameDayAs: selectedDay)
        let isToday = calendar.isDate(day, inSameDayAs: today)
        let isPast = day < calendar.startOfDay(for: today)
        let dot: Color = hasBlocks(day) ? (isToday && !isSelected ? .textPrimary : .textTertiary) : .clear
        let numberColor: Color = isSelected ? .textInverse : isToday ? .textPrimary : isPast ? .textTertiary : .textSecondary

        return Button {
            withAnimation(LunaMotion.animation(.easeOut(duration: LunaMotion.fast), reduceMotion: reduceMotion)) {
                selectedDay = day
            }
        } label: {
            VStack(spacing: 6) {
                Text(day.formatted(.dateTime.weekday(.narrow)))
                    .lunaTextStyle(.timeLabel)
                    .foregroundStyle(Color.textTertiary)
                Text(day.formatted(.dateTime.day()))
                    .lunaTextStyle(.dayNumber)
                    .foregroundStyle(numberColor)
                    .frame(width: 38, height: 38)
                    .background(isSelected ? Color.textPrimary : .clear, in: Circle())
                Circle().fill(dot).frame(width: 4, height: 4)
            }
            .padding(.vertical, 2)
            .frame(maxWidth: .infinity, minHeight: LunaSpacing.minHitTarget)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(day.formatted(.dateTime.weekday(.wide).month(.wide).day()))
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

#Preview("Dark") {
    WeekStripPreview().preferredColorScheme(.dark)
}

#Preview("Light") {
    WeekStripPreview().preferredColorScheme(.light)
}

private struct WeekStripPreview: View {
    @State private var day = SampleData.now

    var body: some View {
        WeekStripView(selectedDay: $day, today: SampleData.now, calendar: SampleData.calendar) { day in
            SampleData.calendar.component(.weekday, from: day) != 1
        }
        .frame(maxHeight: .infinity)
        .background(Color.bgCanvas)
    }
}
