import Foundation
import Testing
@testable import Luna

@Suite struct TimelineTests {
    private let day = TestCalendar.date(2026, 10, 29)

    private func block(_ minute: Int, _ duration: Int) -> Block {
        TestCalendar.task(start: day.addingTimeInterval(TimeInterval(minute * 60)), minutes: duration)
    }

    // MARK: Pill height

    @Test(arguments: zip([5, 15, 90, 120, 200], [55, 60, 97, 112, 112] as [CGFloat]))
    func pillHeightFollowsDuration(minutes: Int, height: CGFloat) {
        #expect(Timeline.pillHeight(for: block(600, minutes)) == height)
    }

    @Test func routinePillIsFixed() {
        var routine = block(600, 45)
        routine.kind = .routine
        routine.steps = [Step(title: "Stretch")]
        #expect(Timeline.pillHeight(for: routine) == 164)
    }

    @Test func routineWithoutStepsUsesTaskHeight() {
        var routine = block(600, 45)
        routine.kind = .routine
        #expect(Timeline.pillHeight(for: routine) == 75)
    }

    // MARK: Free gaps

    @Test func gapUnderTwentyMinutesIsHidden() {
        #expect(Timeline.freeGaps(in: [block(600, 30), block(649, 30)]).isEmpty)
    }

    @Test func gapOfTwentyMinutesShows() {
        let gaps = Timeline.freeGaps(in: [block(600, 30), block(650, 30)])
        #expect(gaps == [FreeGap(start: day.addingTimeInterval(630 * 60), minutes: 20)])
    }

    @Test func overlapUsesLatestEnd() {
        // 10:00–12:00 covers 10:30–11:00, so the next gap starts at 12:00.
        let gaps = Timeline.freeGaps(in: [block(600, 120), block(630, 30), block(750, 30)])
        #expect(gaps == [FreeGap(start: day.addingTimeInterval(720 * 60), minutes: 30)])
    }

    @Test func unsortedInputIsSorted() {
        let gaps = Timeline.freeGaps(in: [block(700, 30), block(600, 30)])
        #expect(gaps.map(\.minutes) == [70])
    }

    @Test func singleBlockHasNoGap() {
        #expect(Timeline.freeGaps(in: [block(600, 30)]).isEmpty)
    }

    @Test func minuteOfDayUsesCalendar() {
        #expect(Timeline.minuteOfDay(TestCalendar.date(2026, 10, 29, 10, 20), calendar: TestCalendar.utc) == 620)
    }

    // MARK: Time states

    private func at(_ minute: Int) -> Date { day.addingTimeInterval(TimeInterval(minute * 60)) }

    @Test func sampleWriteMigrationPlanIsActive() {
        let thursday = PlannerStore.sample().blocks(on: SampleData.now, calendar: SampleData.calendar)
        let active = thursday.filter { Timeline.isActive($0, at: SampleData.now) }
        #expect(active.map(\.title) == ["Write migration plan"])
        let block = active[0]
        #expect(abs(Timeline.progress(of: block, at: SampleData.now) - 50.0 / 90) < 0.0001)
        #expect(Timeline.minutesLeft(of: block, at: SampleData.now) == 40)
    }

    @Test func startIsInclusiveAndEndIsExclusive() {
        let block = block(600, 30)
        #expect(!Timeline.isActive(block, at: at(599)))
        #expect(Timeline.isActive(block, at: at(600)))
        #expect(Timeline.isActive(block, at: at(629)))
        #expect(!Timeline.isActive(block, at: at(630)))
    }

    @Test func doneBlockIsNotActive() {
        var block = block(600, 30)
        block.done = true
        #expect(!Timeline.isActive(block, at: at(610)))
    }

    @Test func eventIsNotActive() {
        let event = Block(kind: .event, title: "Standup", start: at(600), durationMinutes: 30, calendarName: "Work")
        #expect(!Timeline.isActive(event, at: at(610)))
    }

    @Test func blockOnAnotherDayIsNotActive() {
        #expect(!Timeline.isActive(block(600, 30), at: at(600 + 24 * 60)))
    }

    @Test func progressIsClamped() {
        let block = block(600, 60)
        #expect(Timeline.progress(of: block, at: at(500)) == 0)
        #expect(Timeline.progress(of: block, at: at(615)) == 0.25)
        #expect(Timeline.progress(of: block, at: at(700)) == 1)
    }

    @Test func minutesLeftRoundsUp() {
        let block = block(600, 60)
        #expect(Timeline.minutesLeft(of: block, at: at(615).addingTimeInterval(30)) == 45)
        #expect(Timeline.minutesLeft(of: block, at: at(615)) == 45)
        #expect(Timeline.minutesLeft(of: block, at: at(700)) == 0)
    }

    @Test func doneCountSkipsEvents() {
        var done = block(600, 30)
        done.done = true
        let event = Block(kind: .event, title: "Sync", start: at(700), durationMinutes: 30)
        let count = Timeline.doneCount([done, block(640, 30), event])
        #expect(count.done == 1)
        #expect(count.total == 2)
    }

    // MARK: Overlaps and ghost times

    @Test func overlappingBlocksAreFound() {
        let first = block(600, 60)
        let inside = block(630, 15)
        let touching = block(660, 30)
        let later = block(800, 30)
        #expect(Timeline.overlappingIDs([later, touching, inside, first]) == [first.id, inside.id])
    }

    @Test func ghostTimesAreBandStartPlusTwoHours() {
        let minutes = Band.allCases.map { Timeline.ghostMinute(for: $0, schedule: .standard) }
        #expect(minutes == [8 * 60, 14 * 60, 20 * 60])
    }
}
