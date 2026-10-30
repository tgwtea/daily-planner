import Foundation
import Testing
@testable import Luna

@Suite struct DayPlanTests {
    private let day = TestCalendar.date(2026, 10, 29)

    private func block(_ minute: Int, _ duration: Int) -> Block {
        TestCalendar.task(start: day.addingTimeInterval(TimeInterval(minute * 60)), minutes: duration)
    }

    private func plan(_ blocks: [Block], showFreeTime: Bool = true) -> DayPlan {
        DayPlan.make(blocks: blocks, schedule: .standard, calendar: TestCalendar.utc, showFreeTime: showFreeTime)
    }

    @Test func blocksGroupByStartBand() {
        let plan = plan([block(1110, 60), block(300, 30), block(700, 60), block(800, 30)])
        #expect(plan.sections.map(\.band) == [.morning, .afternoon, .night])
        #expect(plan.sections.map(\.blocks.count) == [2, 1, 1])
    }

    @Test func gapRowSitsBetweenBlocks() {
        let first = block(600, 30)
        let second = block(660, 30)
        let rows = plan([second, first]).sections[0].rows
        #expect(rows == [.block(first), .gap(FreeGap(start: first.end, minutes: 30)), .block(second)])
    }

    @Test func freeTimeOffHidesGaps() {
        let rows = plan([block(600, 30), block(660, 30)], showFreeTime: false).sections[0].rows
        #expect(rows.count == 2)
    }

    @Test func countsAndTotals() {
        var done = block(600, 30)
        done.done = true
        let event = Block(kind: .event, title: "Sync", start: day.addingTimeInterval(640 * 60), durationMinutes: 15)
        let plan = plan([done, event, block(700, 45)])
        let morning = plan.sections[0]
        #expect(morning.totalMinutes == 90)
        #expect(morning.doneCount.done == 1)
        #expect(morning.doneCount.total == 2)
        #expect(!plan.isEmpty)
    }

    @Test func emptyDayIsEmpty() {
        #expect(plan([]).isEmpty)
    }

    @Test func sampleThursdayFooter() {
        let blocks = PlannerStore.sample().blocks(on: SampleData.now, calendar: SampleData.calendar)
        let plan = DayPlan.make(blocks: blocks, schedule: .standard, calendar: SampleData.calendar, showFreeTime: true)
        #expect(plan.doneCount.done == 2)
        #expect(plan.doneCount.total == 9)
        #expect(plan.overlappingIDs.isEmpty)
    }
}
