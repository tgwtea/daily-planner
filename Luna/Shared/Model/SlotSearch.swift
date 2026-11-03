import Foundation

/// The first free time for a task in one band of a day. See docs/features/inbox-scheduling.md.
enum SlotSearch {
    /// The search moves in steps of this many minutes.
    static let stepMinutes = 15
    /// No slot starts before 7:00 AM, even when Morning starts earlier.
    static let earliestMinute = 7 * 60

    /// The first start that fits `durationMinutes` in `band` of `day`, or `nil`.
    /// The search starts at the latest of the band start, 7:00 AM, and (on the day of `now`) `now` rounded up to 15 minutes.
    /// A slot fits when it ends by the band end (11:59 PM at the latest) and overlaps no block. Every block is busy, events too.
    static func firstFreeSlot(
        durationMinutes: Int,
        in band: Band,
        day: Date,
        blocks: [Block],
        now: Date,
        schedule: BandSchedule,
        calendar: Calendar
    ) -> Date? {
        guard durationMinutes > 0 else { return nil }
        let range = schedule.range(of: band)
        var startMinute = max(range.lowerBound, earliestMinute)
        if calendar.isDate(day, inSameDayAs: now) {
            startMinute = max(startMinute, roundedUp(Timeline.minuteOfDay(now, calendar: calendar)))
        }
        let dayStart = calendar.startOfDay(for: day)
        guard let bandEnd = LocalTime.boundary(minute: range.upperBound, on: dayStart, calendar: calendar),
              let latestEnd = DayLimit.latestEnd(forStart: dayStart, calendar: calendar)
        else { return nil }
        let end = min(bandEnd, latestEnd)
        let busy = blocks.filter { calendar.isDate($0.start, inSameDayAs: day) }

        for minute in stride(from: startMinute, to: range.upperBound, by: stepMinutes) {
            guard let slotStart = LocalTime.date(minute: minute, on: dayStart, calendar: calendar), slotStart >= now else { continue }
            guard Double(durationMinutes) <= end.timeIntervalSince(slotStart) / 60 else { continue }
            let slotEnd = slotStart.addingTimeInterval(TimeInterval(durationMinutes) * 60)
            if slotEnd > end { return nil }
            // Touching blocks do not overlap.
            if !busy.contains(where: { $0.start < slotEnd && slotStart < $0.end }) {
                return slotStart
            }
        }
        return nil
    }

    /// Rounds a minute of the day up to the next step. A minute on a step stays.
    static func roundedUp(_ minute: Int) -> Int {
        (minute + stepMinutes - 1) / stepMinutes * stepMinutes
    }

}
