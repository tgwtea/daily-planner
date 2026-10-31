import SwiftUI

/// Seven round toggles, Monday to Sunday, for the days of a habit. See docs/screens/habit-editor.md.
struct WeekdayPicker: View {
    @Binding var selection: Set<Weekday>

    var body: some View {
        HStack(spacing: 0) {
            ForEach(Weekday.allCases) { day in
                let isOn = selection.contains(day)
                Button {
                    if isOn { selection.remove(day) } else { selection.insert(day) }
                } label: {
                    Text(day.initial)
                        .lunaTextStyle(.label)
                        .foregroundStyle(isOn ? Color.textInverse : Color.textPrimary)
                        .frame(width: 36, height: 36)
                        .background(isOn ? Color.textPrimary : Color.surfaceTertiary, in: Circle())
                        .frame(maxWidth: .infinity, minHeight: LunaSpacing.minHitTarget)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .accessibilityLabel(day.name)
                .accessibilityAddTraits(isOn ? .isSelected : [])
            }
        }
    }
}

#Preview("Dark") {
    WeekdayPickerPreview().preferredColorScheme(.dark)
}

#Preview("Light") {
    WeekdayPickerPreview().preferredColorScheme(.light)
}

private struct WeekdayPickerPreview: View {
    @State private var days: Set<Weekday> = [.monday, .wednesday, .friday]

    var body: some View {
        WeekdayPicker(selection: $days)
            .padding(LunaSpacing.screenMargin)
            .frame(maxHeight: .infinity)
            .background(Color.bgCanvas)
    }
}
