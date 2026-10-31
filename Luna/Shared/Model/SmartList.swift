import Foundation

/// A fixed list on the Projects tab. See docs/features/projects-and-areas.md#decisions.
enum SmartList: CaseIterable, Identifiable, Hashable, Sendable {
    case upcoming
    case anytime
    case someday
    case logbook

    var id: Self { self }

    var title: String {
        switch self {
        case .upcoming: "Upcoming"
        case .anytime: "Anytime"
        case .someday: "Someday"
        case .logbook: "Logbook"
        }
    }

    /// The SF Symbol for the mockup's Lucide icon.
    var systemImage: String {
        switch self {
        case .upcoming: "calendar"
        case .anytime: "square.3.layers.3d"
        case .someday: "archivebox"
        case .logbook: "book.closed"
        }
    }

    /// The items of the list. See docs/features/projects-and-areas.md#decisions.
    /// - Upcoming: open task and routine blocks and open Anytime tasks with a day after today, earliest first.
    ///   Events do not show.
    /// - Anytime: open Anytime tasks with no day, in store order.
    /// - Someday: Someday items, in store order.
    /// - Logbook: done blocks and done Anytime tasks, newest first.
    func items(in store: PlannerStore, today: Date, calendar: Calendar) -> [ListItem] {
        switch self {
        case .upcoming:
            let startOfToday = calendar.startOfDay(for: today)
            let isAfterToday = { (date: Date) in calendar.startOfDay(for: date) > startOfToday }
            let blocks = store.blocks
                .filter { $0.kind != .event && !$0.isDone && isAfterToday($0.start) }
                .map(ListItem.block)
            let tasks = store.anytimeTasks
                .filter { task in !task.done && (task.day.map(isAfterToday) ?? false) }
                .map(ListItem.anytimeTask)
            return ListItem.sortedByDate(blocks + tasks)
        case .anytime:
            return store.anytimeTasks.filter { $0.day == nil && !$0.done }.map(ListItem.anytimeTask)
        case .someday:
            return store.somedayItems.map(ListItem.someday)
        case .logbook:
            let blocks = store.blocks.filter { $0.kind != .event && $0.isDone }.map(ListItem.block)
            let tasks = store.anytimeTasks.filter(\.done).map(ListItem.anytimeTask)
            return ListItem.sortedNewestFirst(blocks + tasks)
        }
    }

    /// The row count: the number of items. Logbook shows no count.
    func count(in store: PlannerStore, today: Date, calendar: Calendar) -> Int? {
        self == .logbook ? nil : items(in: store, today: today, calendar: calendar).count
    }

    /// The text when the list has no items.
    var emptyMessage: String {
        switch self {
        case .upcoming: "Nothing planned after today."
        case .anytime: "No tasks without a day."
        case .someday: "Nothing set aside for later."
        case .logbook: "Done tasks show here."
        }
    }
}
