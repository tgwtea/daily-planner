import Foundation
import Testing
@testable import Luna

@Suite struct SampleDataTests {
    private let store = PlannerStore.sample()
    private let calendar = SampleData.calendar
    private let today = SampleData.now

    private var thursday: [Block] { store.blocks(on: today, calendar: calendar) }

    @Test func nowIsThursdayMorning() {
        let parts = calendar.dateComponents([.year, .month, .day, .hour, .minute, .weekday], from: today)
        #expect(parts.year == 2026 && parts.month == 10 && parts.day == 29)
        #expect(parts.hour == 10 && parts.minute == 20)
        #expect(parts.weekday == 5)
    }

    @Test func countsMatchMockup() {
        #expect(thursday.count == 13)
        #expect(store.blocks.count == 22)
        #expect(store.anytimeTasks(on: today, calendar: calendar).count == 3)
        #expect(store.inboxItems.count == 5)
        #expect(store.habits.count == 5)
        #expect(store.areas.count == 2)
        #expect(store.projects.count == 6)
    }

    @Test func thursdayFooterCountsTasksAndRoutines() {
        let tasks = thursday.filter { $0.kind != .event }
        #expect(tasks.count == 9)
        #expect(tasks.filter(\.isDone).count == 2)
    }

    @Test func thursdayGapsMatchMockupRule() {
        let gaps = Band.allCases.map { band in
            let blocks = thursday.filter { Timeline.band(of: $0, schedule: .standard, calendar: calendar) == band }
            return Timeline.freeGaps(in: blocks).map(\.minutes)
        }
        #expect(gaps == [[30], [60, 30], [45, 30]])
    }

    @Test func activeBlockIsMigrationPlan() {
        let active = thursday.filter { $0.kind != .event && !$0.isDone && $0.start <= today && today < $0.end }
        #expect(active.map(\.title) == ["Write migration plan"])
    }

    @Test func habitValuesMatchMockup() {
        let values = store.habits.map { $0.value(on: today, calendar: calendar) }
        #expect(values == [5, 1, 0, 0, 0])
    }

    @Test func projectProgressMatchesMockup() {
        let values = store.projects.map { project in
            let progress = ProjectProgress(projectID: project.id, in: store)
            return "\(project.name) \(progress.percent) \(progress.open)"
        }
        // Sync engine shows 58%, Lisbon trip 33%, Health 71%: the mockup values have no whole-number item counts.
        #expect(values == [
            "Sync engine 58 5", "Q4 planning 25 3", "Hiring loop 80 2",
            "Lisbon trip 33 4", "Home 50 6", "Health 71 2",
        ])
    }

    @Test func smartListCountsMatchMockup() {
        let counts = SmartList.allCases.map { $0.count(in: store, today: today, calendar: calendar) }
        #expect(counts == [12, 8, 14, nil])
    }

    @Test func everySampleBlockFitsItsDay() {
        #expect(store.blocks.allSatisfy { $0.fitsDay(calendar: calendar) })
    }
}
