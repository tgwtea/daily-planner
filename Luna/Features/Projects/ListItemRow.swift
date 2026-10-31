import SwiftUI

/// One item in a smart list or on project detail: an icon tile, the title, a meta line, and a check circle.
/// Inbox and Someday items have no check circle. See docs/screens/smart-list.md.
struct ListItemRow: View {
    let item: ListItem
    /// Shows the project name in the meta line. Project detail turns it off.
    var showsProject = true
    /// Shows the day of a dated item. Upcoming turns it off, because its day headers show the day.
    var showsDay = true

    @Environment(PlannerStore.self) private var store
    @Environment(\.appClock) private var clock
    @Environment(\.calendar) private var calendar
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        let meta = metaText
        HStack(spacing: 12) {
            IconTile(systemImage: item.icon, color: item.color)
            VStack(alignment: .leading, spacing: 3) {
                Text(item.title)
                    .lunaTextStyle(.rowTitle)
                    .strikethrough(item.isDone)
                    .foregroundStyle(item.isDone ? Color.textTertiary : Color.textPrimary)
                    .lineLimit(1)
                if let meta {
                    Text(meta)
                        .lunaTextStyle(.meta)
                        .monospacedDigit()
                        .foregroundStyle(Color.textSecondary)
                        .lineLimit(1)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(item.isDone ? "\(item.title), done" : item.title)
            .accessibilityValue(meta ?? "")
            if item.canToggle {
                CheckCircle(isOn: item.isDone, tint: item.color.color, label: "Complete \(item.title)", action: toggle)
            }
        }
        .padding(.vertical, 10)
        .padding(.leading, 14)
        .padding(.trailing, item.canToggle ? 6 : LunaSpacing.rowHorizontalPadding)
        .frame(minHeight: 64)
    }

    private func toggle() {
        withAnimation(LunaMotion.animation(.easeInOut(duration: LunaMotion.normal), reduceMotion: reduceMotion)) {
            switch item {
            case .block(let block): store.toggleDone(blockID: block.id, now: clock.now())
            case .anytimeTask(let task): store.toggleAnytimeTask(id: task.id, now: clock.now())
            case .inbox, .someday: break
            }
        }
    }

    /// "Done Oct 28", "Fri, Oct 30 · 9:00 AM", "30 min", each with " · <Project>" when shown.
    private var metaText: String? {
        let style = Date.FormatStyle(locale: calendar.locale ?? .autoupdatingCurrent, calendar: calendar, timeZone: calendar.timeZone)
        var parts: [String] = []
        if item.isDone {
            if let completedAt = item.completedAt {
                parts.append("Done \(style.month(.abbreviated).day().format(completedAt))")
            }
        } else {
            switch item {
            case .block(let block):
                if showsDay { parts.append(style.weekday(.abbreviated).month(.abbreviated).day().format(block.start)) }
                parts.append(style.hour().minute().format(block.start))
            case .anytimeTask(let task):
                if showsDay, let day = task.day { parts.append(style.weekday(.abbreviated).month(.abbreviated).day().format(day)) }
            case .inbox(let inboxItem):
                parts.append("Inbox, \(DurationFormat.string(minutes: inboxItem.durationMinutes))")
            case .someday(let somedayItem):
                parts.append(DurationFormat.string(minutes: somedayItem.durationMinutes))
            }
        }
        if showsProject, let id = item.projectID, let project = store.projects.first(where: { $0.id == id }) {
            parts.append(project.name)
        }
        return parts.isEmpty ? nil : parts.joined(separator: " · ")
    }
}

#if DEBUG
private struct ListItemRowPreview: View {
    @Environment(PlannerStore.self) private var store

    var body: some View {
        let items = SmartList.logbook.items(in: store, today: SampleData.now, calendar: .current).prefix(2)
            + SmartList.upcoming.items(in: store, today: SampleData.now, calendar: .current).prefix(2)
            + SmartList.someday.items(in: store, today: SampleData.now, calendar: .current).prefix(1)
        GroupedList {
            ForEach(Array(items)) { ListItemRow(item: $0) }
        }
        .padding(LunaSpacing.screenMargin)
        .frame(maxHeight: .infinity)
        .background(Color.bgCanvas)
    }
}

#Preview("Dark") {
    ListItemRowPreview().sampleEnvironment().preferredColorScheme(.dark)
}

#Preview("Light") {
    ListItemRowPreview().sampleEnvironment().preferredColorScheme(.light)
}
#endif
