import Foundation
import Testing
@testable import Luna

@Suite struct SlotSearchTests {
    private let calendar = TestCalendar.utc
    private let day = TestCalendar.date(2026, 10, 29)
    /// A `now` on another day, so that the now rule does not apply.
    private let yesterday = TestCalendar.date(2026, 10, 28, 12)

    private func at(_ hour: Int, _ minute: Int = 0) -> Date {
        TestCalendar.date(2026, 10, 29, hour, minute)
    }

    private func slot(
        _ minutes: Int, in band: Band, blocks: [Block] = [], now: Date? = nil,
        schedule: BandSchedule = .standard
    ) -> Date? {
        SlotSearch.firstFreeSlot(
            durationMinutes: minutes, in: band, day: day, blocks: blocks,
            now: now ?? yesterday, schedule: schedule, calendar: calendar
        )
    }

    @Test func startsAtBandStart() {
        #expect(slot(30, in: .afternoon) == at(12))
        #expect(slot(30, in: .night) == at(18))
    }

    @Test func morningStartsNoEarlierThanSevenAM() {
        #expect(slot(30, in: .morning) == at(7))
        var early = BandSchedule.standard
        early.morningStart = 5 * 60
        #expect(slot(30, in: .morning, schedule: early) == at(7))
        var late = BandSchedule.standard
        late.morningStart = 8 * 60
        #expect(slot(30, in: .morning, schedule: late) == at(8))
    }

    @Test func todayStartsAtNowRoundedUpToFifteenMinutes() {
        #expect(slot(15, in: .morning, now: at(10, 20)) == at(10, 30))
        #expect(slot(15, in: .morning, now: at(10, 30)) == at(10, 30))
        #expect(slot(15, in: .morning, now: at(10, 46)) == at(11))
    }

    @Test func nowBeforeBandKeepsBandStart() {
        #expect(slot(15, in: .afternoon, now: at(10, 20)) == at(12))
    }

    @Test func nowAfterBandMeansNoFit() {
        #expect(slot(15, in: .morning, now: at(13)) == nil)
    }

    @Test func anotherDayIgnoresNow() {
        #expect(slot(15, in: .morning, now: yesterday) == at(7))
    }

    @Test func skipsOverlappingBlocks() {
        let blocks = [TestCalendar.task(start: at(12), minutes: 50)]
        #expect(slot(30, in: .afternoon, blocks: blocks) == at(13))
    }

    @Test func eventCountsAsBusy() {
        let event = Block(kind: .event, title: "Standup", start: at(12), durationMinutes: 15, calendarName: "Work")
        #expect(slot(15, in: .afternoon, blocks: [event]) == at(12, 15))
    }

    @Test func touchingBlockFits() {
        let blocks = [TestCalendar.task(start: at(12, 30), minutes: 30)]
        #expect(slot(30, in: .afternoon, blocks: blocks) == at(12))
    }

    @Test func blockOnAnotherDayIsNotBusy() {
        let blocks = [TestCalendar.task(start: TestCalendar.date(2026, 10, 30, 12), minutes: 60)]
        #expect(slot(30, in: .afternoon, blocks: blocks) == at(12))
    }

    @Test func slotMustEndByBandEnd() {
        let blocks = [TestCalendar.task(start: at(12), minutes: 5 * 60 + 30)]
        #expect(slot(30, in: .afternoon, blocks: blocks) == at(17, 30))
        #expect(slot(45, in: .afternoon, blocks: blocks) == nil)
    }

    @Test func tooLongNeverFits() {
        #expect(slot(7 * 60, in: .afternoon) == nil)
    }

    @Test func nightEndsAtElevenFiftyNine() {
        #expect(slot(15, in: .night, now: at(23, 30)) == at(23, 30))
        #expect(slot(15, in: .night, now: at(23, 45)) == nil)
    }

    @Test func zeroDurationNeverFits() {
        #expect(slot(0, in: .afternoon) == nil)
    }

    @Test func roundedUpKeepsQuarterHours() {
        #expect(SlotSearch.roundedUp(600) == 600)
        #expect(SlotSearch.roundedUp(601) == 615)
        #expect(SlotSearch.roundedUp(614) == 615)
    }
}
