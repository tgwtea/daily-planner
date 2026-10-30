#if DEBUG
import SwiftUI

/// The mockup's sample week, for previews and the `-LunaSampleData` launch argument only.
/// Today is Thursday, October 29, 2026 at 10:20 AM. Icons are the SF Symbol mapping of the mockup's Lucide names.
enum SampleData {
    static let launchArgument = "-LunaSampleData"

    static let calendar = Calendar.current

    /// Thursday, October 29, 2026, 10:20 AM.
    static let now = date(dayOffset: 3, minute: 10 * 60 + 20)

    /// Monday, October 26, 2026: the first day of the sample week.
    private static let monday = calendar.date(from: DateComponents(year: 2026, month: 10, day: 26))!

    /// A time on the sample week. Day 0 is Monday, day 3 is Thursday (today).
    static func date(dayOffset: Int, minute: Int) -> Date {
        let day = calendar.date(byAdding: .day, value: dayOffset, to: monday)!
        return calendar.date(byAdding: .minute, value: minute, to: day)!
    }

    static func makeStore() -> PlannerStore {
        let work = Area(name: "Work", icon: "briefcase")
        let personal = Area(name: "Personal", icon: "house")
        let syncEngine = Project(name: "Sync engine", color: .slate, areaID: work.id, timing: .due(day(2026, 11, 14)))
        let q4Planning = Project(name: "Q4 planning", color: .sand, areaID: work.id, timing: .due(day(2026, 11, 6)))
        let hiringLoop = Project(name: "Hiring loop", color: .sage, areaID: work.id)
        let lisbonTrip = Project(name: "Lisbon trip", color: .plum, areaID: personal.id, timing: .span(day(2026, 12, 18), day(2026, 12, 27)))
        let home = Project(name: "Home", color: .sage, areaID: personal.id)
        let health = Project(name: "Health", color: .rose, areaID: personal.id, timing: .ongoing)

        return PlannerStore(
            blocks: blocks,
            anytimeTasks: [
                AnytimeTask(title: "Pay electricity bill", icon: "receipt", color: .sand, day: today),
                AnytimeTask(title: "Reply to Maya", icon: "envelope", color: .slate, day: today),
                AnytimeTask(title: "Water the plants", icon: "leaf", color: .sage, done: true, day: today),
            ],
            inboxItems: [
                InboxItem(title: "Call the dentist", durationMinutes: 15, icon: "phone", color: .rose, projectID: health.id),
                InboxItem(title: "Draft Q4 self-review", durationMinutes: 60, icon: "doc.text", color: .slate, projectID: q4Planning.id),
                InboxItem(title: "Book flights to Lisbon", durationMinutes: 30, icon: "airplane", color: .plum, projectID: lisbonTrip.id),
                InboxItem(title: "Order a new chalk bag", durationMinutes: 10, icon: "bag", color: .sand),
                InboxItem(title: "Renew passport", durationMinutes: 20, icon: "person.text.rectangle", color: .sage, projectID: lisbonTrip.id),
            ],
            habits: habits,
            areas: [work, personal],
            projects: [syncEngine, q4Planning, hiringLoop, lisbonTrip, home, health]
        )
    }

    private static var today: Date { date(dayOffset: 3, minute: 0) }

    private static func day(_ year: Int, _ month: Int, _ day: Int) -> Date {
        calendar.date(from: DateComponents(year: year, month: month, day: day))!
    }

    private static func task(
        _ dayOffset: Int, _ title: String, _ minute: Int, _ duration: Int,
        _ icon: String, _ color: BlockColor, done: Bool = false, steps: [Step] = []
    ) -> Block {
        Block(
            kind: .task, title: title, start: date(dayOffset: dayOffset, minute: minute),
            durationMinutes: duration, icon: icon, color: color, steps: steps, done: done
        )
    }

    private static func event(_ dayOffset: Int, _ title: String, _ minute: Int, _ duration: Int, _ calendarName: String) -> Block {
        Block(
            kind: .event, title: title, start: date(dayOffset: dayOffset, minute: minute),
            durationMinutes: duration, calendarName: calendarName
        )
    }

    private static var blocks: [Block] {
        var routine = task(3, "Morning routine", 435, 45, "sunrise", .rose, steps: [
            Step(title: "Stretch", done: true),
            Step(title: "Shower", done: true),
            Step(title: "Breakfast"),
        ])
        routine.kind = .routine

        return [
            // Thursday (today)
            task(3, "Wake up", 420, 15, "alarm", .sand, done: true),
            routine,
            task(3, "Bike to the office", 480, 30, "bicycle", .sage, done: true),
            event(3, "Standup", 540, 15, "Work"),
            task(3, "Write migration plan", 570, 90, "laptopcomputer", .slate, steps: [
                Step(title: "Outline the phases", done: true),
                Step(title: "Rollback plan"),
                Step(title: "Share with Alex"),
            ]),
            event(3, "Design review", 660, 60, "Work"),
            task(3, "Lunch with Priya", 750, 60, "fork.knife", .sand),
            task(3, "Review pull requests", 870, 45, "arrow.triangle.pull", .slate),
            event(3, "1:1 with Alex", 930, 30, "Work"),
            task(3, "Groceries", 990, 30, "basket", .sage),
            task(3, "Gym", 1110, 75, "dumbbell", .rose),
            event(3, "Dinner with Sam", 1230, 90, "Personal"),
            task(3, "Wind down", 1350, 30, "moon", .plum),
            // Friday
            event(4, "Standup", 540, 15, "Work"),
            task(4, "Write docs", 600, 120, "doc.text", .slate),
            task(4, "Lunch", 750, 45, "fork.knife", .sand),
            task(4, "Climbing", 1110, 90, "mountain.2", .rose),
            // Saturday
            task(5, "Farmers market", 600, 60, "carrot", .sage),
            task(5, "Plan Lisbon trip", 840, 60, "airplane", .plum),
            // Monday to Wednesday
            task(0, "Deep work", 570, 120, "laptopcomputer", .slate, done: true),
            task(1, "Run", 420, 45, "figure.walk", .rose, done: true),
            task(2, "Reading", 1320, 30, "book", .sand, done: true),
        ]
    }

    private static var habits: [Habit] {
        [
            habit("Water", "waterbottle", .slate, goal: 8, "8 glasses a day", today: 5, doneDaysBefore: 12),
            habit("Stretch", "figure.stand", .sage, goal: 1, "Every morning", today: 1, doneDaysBefore: 22),
            habit("Read", "book", .sand, goal: 1, "20 minutes", today: 0, recent: [true, false, true]),
            habit("Meditate", "wind", .plum, goal: 1, "10 minutes", today: 0, recent: [false, true, false]),
            habit("Walk", "figure.walk", .rose, goal: 1, "8,000 steps", today: 0, doneDaysBefore: 6),
        ]
    }

    private static func habit(
        _ name: String, _ icon: String, _ color: BlockColor, goal: Int, _ subtitle: String,
        today value: Int, doneDaysBefore count: Int
    ) -> Habit {
        habit(name, icon, color, goal: goal, subtitle, today: value, recent: Array(repeating: true, count: count) + [false])
    }

    /// Builds 12 weeks of history. `recent[0]` is yesterday. Older days follow a fixed pattern.
    private static func habit(
        _ name: String, _ icon: String, _ color: BlockColor, goal: Int, _ subtitle: String,
        today value: Int, recent: [Bool]
    ) -> Habit {
        var history: [Date: Int] = [:]
        if value > 0 { history[today] = value }
        for daysBack in 1..<84 {
            let done = daysBack <= recent.count ? recent[daysBack - 1] : (daysBack * 37 + 11) % 10 >= 3
            if done, let day = calendar.date(byAdding: .day, value: -daysBack, to: today) {
                history[day] = goal
            }
        }
        return Habit(name: name, icon: icon, color: color, goal: goal, subtitle: subtitle, history: history)
    }
}

extension PlannerStore {
    static func sample() -> PlannerStore { SampleData.makeStore() }
}

extension View {
    /// The sample store and a clock fixed at the mockup's "now". For `#Preview` only.
    func sampleEnvironment() -> some View {
        environment(PlannerStore.sample())
            .environment(\.appClock, .fixed(SampleData.now))
    }
}
#endif
