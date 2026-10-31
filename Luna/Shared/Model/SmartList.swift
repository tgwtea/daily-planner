import Foundation

/// A fixed list on the Projects tab. See docs/features/projects-and-areas.md#decisions.
enum SmartList: CaseIterable, Identifiable, Sendable {
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

    /// The row count. Only open items count. Logbook shows no count.
    /// - Upcoming: task and routine blocks and Anytime tasks with a day after today. Events do not count.
    /// - Anytime: Anytime tasks with no day.
    /// - Someday: Someday items.
    func count(in store: PlannerStore, today: Date, calendar: Calendar) -> Int? {
        switch self {
        case .upcoming:
            let startOfToday = calendar.startOfDay(for: today)
            let isAfterToday = { (date: Date) in calendar.startOfDay(for: date) > startOfToday }
            let blocks = store.blocks.filter { $0.kind != .event && !$0.isDone && isAfterToday($0.start) }
            let tasks = store.anytimeTasks.filter { task in !task.done && (task.day.map(isAfterToday) ?? false) }
            return blocks.count + tasks.count
        case .anytime:
            return store.anytimeTasks.filter { $0.day == nil && !$0.done }.count
        case .someday:
            return store.somedayItems.count
        case .logbook:
            return nil
        }
    }
}
