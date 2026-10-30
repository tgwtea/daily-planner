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

    // MARK: Time states

    /// A task or routine that is not done and runs at `now` (`start ≤ now < end`). An event is never active.
    static func isActive(_ block: Block, at now: Date) -> Bool {
        block.kind != .event && !block.isDone && block.start <= now && now < block.end
    }

    /// The elapsed fraction of the block at `now`, clamped to 0...1.
    static func progress(of block: Block, at now: Date) -> Double {
        let total = block.end.timeIntervalSince(block.start)
        guard total > 0 else { return 0 }
        return min(max(now.timeIntervalSince(block.start) / total, 0), 1)
    }

    /// The whole minutes left until the block ends, rounded up. Zero after the end.
    static func minutesLeft(of block: Block, at now: Date) -> Int {
        max(0, Int((block.end.timeIntervalSince(now) / 60).rounded(.up)))
    }

    /// The done count and the total of tasks and routines. Events do not count.
    static func doneCount(_ blocks: [Block]) -> (done: Int, total: Int) {
        let tasks = blocks.filter { $0.kind != .event }
        return (tasks.filter(\.isDone).count, tasks.count)
    }

    /// The blocks whose time overlaps the time of another block. Touching blocks do not overlap.
    static func overlappingIDs(_ blocks: [Block]) -> Set<Block.ID> {
        var ids: Set<Block.ID> = []
        let sorted = blocks.sorted { $0.start < $1.start }
        for (index, block) in sorted.enumerated() {
            for other in sorted[(index + 1)...] {
                guard other.start < block.end else { break }
                ids.insert(block.id)
                ids.insert(other.id)
            }
        }
        return ids
    }

    /// The time of the empty-day ghost pill: the band start plus 2 hours (decided 2026-10-30).
    static func ghostMinute(for band: Band, schedule: BandSchedule) -> Int {
        schedule.range(of: band).lowerBound + 120
    }
}
