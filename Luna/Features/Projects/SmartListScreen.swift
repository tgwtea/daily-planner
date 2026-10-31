import SwiftUI

/// A pushed smart list: Upcoming, Anytime, Someday, or Logbook. See docs/screens/smart-list.md.
struct SmartListScreen: View {
    let list: SmartList

    @Environment(PlannerStore.self) private var store
    @Environment(\.appClock) private var clock
    @Environment(\.calendar) private var calendar

    var body: some View {
        let items = list.items(in: store, today: clock.now(), calendar: calendar)
        ScrollView {
            VStack(alignment: .leading, spacing: LunaSpacing.sectionGap) {
                if items.isEmpty {
                    ListEmptyView(systemImage: list.systemImage, message: list.emptyMessage)
                } else if list == .upcoming {
                    ForEach(days(of: items), id: \.day) { group in
                        GroupedSection(header: dayTitle(group.day)) {
                            ForEach(group.items) { ListItemRow(item: $0, showsDay: false) }
                        }
                    }
                } else {
                    GroupedList {
                        ForEach(items) { ListItemRow(item: $0) }
                    }
                }
            }
            .padding(.horizontal, LunaSpacing.screenMargin)
            .padding(.vertical, LunaSpacing.sectionHeaderGap)
        }
        .scrollIndicators(.hidden)
        .background(Color.bgCanvas)
        .navigationTitle(list.title)
        .navigationBarTitleDisplayMode(.large)
    }

    /// Upcoming items in runs of one day. The items are already in date order.
    private func days(of items: [ListItem]) -> [(day: Date, items: [ListItem])] {
        var groups: [(day: Date, items: [ListItem])] = []
        for item in items {
            guard let date = item.date else { continue }
            let day = calendar.startOfDay(for: date)
            if groups.last?.day == day {
                groups[groups.count - 1].items.append(item)
            } else {
                groups.append((day, [item]))
            }
        }
        return groups
    }

    /// "Friday, October 30".
    private func dayTitle(_ day: Date) -> String {
        let style = Date.FormatStyle(locale: calendar.locale ?? .autoupdatingCurrent, calendar: calendar, timeZone: calendar.timeZone)
        return style.weekday(.wide).month(.wide).day().format(day)
    }
}

#Preview("Upcoming, dark") {
    NavigationStack { SmartListScreen(list: .upcoming) }
        .sampleEnvironment()
        .preferredColorScheme(.dark)
}

#Preview("Logbook, light") {
    NavigationStack { SmartListScreen(list: .logbook) }
        .sampleEnvironment()
        .preferredColorScheme(.light)
}

#Preview("Empty") {
    NavigationStack { SmartListScreen(list: .someday) }
        .environment(PlannerStore())
        .preferredColorScheme(.dark)
}
