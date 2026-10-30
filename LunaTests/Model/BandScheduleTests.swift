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
}
