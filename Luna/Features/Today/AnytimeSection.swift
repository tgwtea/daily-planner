import SwiftUI

/// The Anytime chip, its "+" button, and the list of tasks with no time. See docs/features/anytime-tasks.md.
struct AnytimeSection: View {
    var day: Date
    var tasks: [AnytimeTask]
    @Binding var isExpanded: Bool

    @Environment(PlannerStore.self) private var store
    @Environment(AppRouter.self) private var router
    @Environment(\.appClock) private var clock
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                ChipButton(title: "Anytime", systemImage: "clock", count: tasks.count, isExpanded: isExpanded) {
                    withAnimation(LunaMotion.animation(.easeInOut(duration: LunaMotion.normal), reduceMotion: reduceMotion)) {
                        isExpanded.toggle()
                    }
                }
                Spacer()
                RoundAddButton(label: "Add to Anytime") { router.openQuickAdd(.anytime(day: day)) }
            }
            if isExpanded && !tasks.isEmpty {
                GroupedList {
                    ForEach(tasks) { task in
                        row(task)
                    }
                }
            }
        }
    }

    private func row(_ task: AnytimeTask) -> some View {
        HStack(spacing: 12) {
            IconTile(systemImage: task.icon, color: task.color)
            Text(task.title)
                .lunaTextStyle(.rowTitle)
                .strikethrough(task.done)
                .foregroundStyle(task.done ? Color.textTertiary : Color.textPrimary)
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)
                .accessibilityLabel(task.done ? "\(task.title), done" : task.title)
            CheckCircle(isOn: task.done, tint: task.color.color) {
                store.toggleAnytimeTask(id: task.id, now: clock.now())
            }
        }
        .padding(.vertical, 10)
        .padding(.leading, 14)
        .padding(.trailing, 6)
    }
}

#Preview("Dark") {
    AnytimeSectionPreview().preferredColorScheme(.dark)
}

#Preview("Light") {
    AnytimeSectionPreview().preferredColorScheme(.light)
}

private struct AnytimeSectionPreview: View {
    @State private var store = PlannerStore.sample()
    @State private var expanded = true

    var body: some View {
        AnytimeSection(day: SampleData.now, tasks: store.anytimeTasks(on: SampleData.now, calendar: SampleData.calendar), isExpanded: $expanded)
            .padding(LunaSpacing.screenMargin)
            .frame(maxHeight: .infinity)
            .background(Color.bgCanvas)
            .environment(store)
            .environment(AppRouter())
    }
}
