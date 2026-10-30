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
}
