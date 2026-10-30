import CoreGraphics
import Foundation

/// Unplanned time between two blocks in the same band.
struct FreeGap: Hashable, Sendable {
    var start: Date
    var minutes: Int
}

/// Pure layout rules for the Today timeline. See docs/features/timeline-and-day-bands.md.
enum Timeline {
    /// The smallest gap that shows as a free gap row.
    static let minimumGapMinutes = 20

    /// The wall-clock minutes after midnight in the given calendar.
    static func minuteOfDay(_ date: Date, calendar: Calendar) -> Int {
        let parts = calendar.dateComponents([.hour, .minute], from: date)
        return (parts.hour ?? 0) * 60 + (parts.minute ?? 0)
    }

    /// The band that contains the block's start time.
    static func band(of block: Block, schedule: BandSchedule, calendar: Calendar) -> Band {
        schedule.band(forMinute: minuteOfDay(block.start, calendar: calendar))
    }

    /// `min(112, 52 + duration × 0.5)` pt, rounded. A routine pill is 164 pt.
    static func pillHeight(for block: Block) -> CGFloat {
        if block.isRoutine { return 164 }
        return min(112, (52 + Double(block.durationMinutes) * 0.5).rounded())
    }

    /// The free gaps between the blocks of one band.
    /// A gap starts at the latest end time so far, so overlapping blocks never make a gap.
    static func freeGaps(in blocks: [Block], minimumMinutes: Int = minimumGapMinutes) -> [FreeGap] {
        var gaps: [FreeGap] = []
        var latestEnd: Date?
        for block in blocks.sorted(by: { $0.start < $1.start }) {
            if let latestEnd {
                let minutes = Int(block.start.timeIntervalSince(latestEnd) / 60)
                if minutes >= minimumMinutes {
                    gaps.append(FreeGap(start: latestEnd, minutes: minutes))
                }
            }
            latestEnd = max(latestEnd ?? block.end, block.end)
        }
        return gaps
    }
}
