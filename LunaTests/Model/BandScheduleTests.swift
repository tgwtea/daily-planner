import Foundation
import Testing
@testable import Luna

@Suite struct BandScheduleTests {
    @Test(arguments: zip(
        [330, 360, 719, 720, 1079, 1080, 1439] as [Int],
        [Band.morning, .morning, .morning, .afternoon, .afternoon, .night, .night]
    ))
    func standardScheduleAssignsBand(minute: Int, band: Band) {
        #expect(BandSchedule.standard.band(forMinute: minute) == band)
    }

    @Test func blockBeforeMorningStartIsMorning() {
        #expect(BandSchedule.standard.band(forMinute: 0) == .morning)
    }

    @Test func customScheduleMovesBoundaries() {
        let schedule = BandSchedule(morningStart: 7 * 60, afternoonStart: 13 * 60, nightStart: 19 * 60)
        #expect(schedule.band(forMinute: 12 * 60 + 30) == .morning)
        #expect(schedule.band(forMinute: 18 * 60 + 30) == .afternoon)
        #expect(schedule.band(forMinute: 19 * 60) == .night)
    }

    @Test func nightEndsAtMidnight() {
        #expect(BandSchedule.standard.range(of: .night) == 1080..<1440)
        #expect(BandSchedule.standard.range(of: .morning) == 360..<720)
    }

    @Test func blockBandUsesStartTime() {
        let calendar = TestCalendar.utc
        let block = TestCalendar.task(start: TestCalendar.date(2026, 10, 29, 11, 30), minutes: 90)
        #expect(Timeline.band(of: block, schedule: .standard, calendar: calendar) == .morning)
    }

    @Test func defaultAllowedStartsKeepOneHourFromNeighbors() {
        let schedule = BandSchedule.standard
        let morning = schedule.allowedStarts(for: .morning)
        let afternoon = schedule.allowedStarts(for: .afternoon)
        let night = schedule.allowedStarts(for: .night)
        #expect(morning.first == 0)
        #expect(morning.last == 11 * 60)
        #expect(afternoon.first == 7 * 60)
        #expect(afternoon.last == 17 * 60)
        #expect(night.first == 13 * 60)
        #expect(night.last == 23 * 60)
    }

    @Test(arguments: Band.allCases)
    func allowedStartsUseFifteenMinuteSteps(band: Band) {
        let starts = BandSchedule.standard.allowedStarts(for: band)
        #expect(starts.allSatisfy { $0 % BandSchedule.step == 0 })
        #expect(zip(starts, starts.dropFirst()).allSatisfy { $1 - $0 == BandSchedule.step })
        #expect(starts.contains(BandSchedule.standard.start(of: band)))
    }

    @Test func setStartAcceptsAllowedValue() {
        var schedule = BandSchedule.standard
        let accepted = schedule.setStart(7 * 60 + 15, for: .morning)
        #expect(accepted)
        #expect(schedule.morningStart == 7 * 60 + 15)
        #expect(schedule.band(forMinute: 7 * 60) == .morning)
    }

    @Test func setStartRejectsOutOfOrderValue() {
        var schedule = BandSchedule.standard
        let lateMorning = schedule.setStart(11 * 60 + 15, for: .morning)
        #expect(!lateMorning)
        let lateAfternoon = schedule.setStart(18 * 60, for: .afternoon)
        #expect(!lateAfternoon)
        let earlyNight = schedule.setStart(12 * 60 + 30, for: .night)
        #expect(!earlyNight)
        let offStep = schedule.setStart(9 * 60 + 5, for: .morning)
        #expect(!offStep)
        #expect(schedule == .standard)
    }

    @Test func tightScheduleLeavesExactlyOneHourBands() {
        let schedule = BandSchedule(morningStart: 10 * 60, afternoonStart: 11 * 60, nightStart: 12 * 60)
        #expect(schedule.allowedStarts(for: .afternoon) == [11 * 60])
        #expect(schedule.allowedStarts(for: .morning).last == 10 * 60)
        #expect(schedule.allowedStarts(for: .night).first == 12 * 60)
    }

    @Test func movedAfternoonStartChangesBlockBand() {
        let calendar = TestCalendar.utc
        let block = TestCalendar.task(start: TestCalendar.date(2026, 10, 29, 16, 30), minutes: 30)
        #expect(Timeline.band(of: block, schedule: .standard, calendar: calendar) == .afternoon)
        var schedule = BandSchedule.standard
        let accepted = schedule.setStart(17 * 60, for: .afternoon)
        #expect(accepted)
        #expect(Timeline.band(of: block, schedule: schedule, calendar: calendar) == .morning)
    }
}
