import Foundation

/// The rows of one day on Today, grouped by band. See docs/features/timeline-and-day-bands.md.
struct DayPlan {
    enum Row: Identifiable, Hashable {
        case block(Block)
        case gap(FreeGap)

        var id: String {
            switch self {
            case .block(let block): block.id.uuidString
            case .gap(let gap): "gap-\(gap.start.timeIntervalSinceReferenceDate)"
            }
        }
    }

    struct BandSection: Identifiable {
        var band: Band
        var blocks: [Block]
        var rows: [Row]

        var id: Band { band }
        var totalMinutes: Int { blocks.reduce(0) { $0 + $1.durationMinutes } }
        var doneCount: (done: Int, total: Int) { Timeline.doneCount(blocks) }
    }

    var sections: [BandSection]
    var overlappingIDs: Set<Block.ID>

    var blocks: [Block] { sections.flatMap(\.blocks) }
    var isEmpty: Bool { sections.allSatisfy(\.blocks.isEmpty) }
    /// The day footer: "5 of 11 blocks done".
    var doneCount: (done: Int, total: Int) { Timeline.doneCount(blocks) }

    /// - Parameter blocks: the blocks of one day.
    /// - Parameter showFreeTime: the Settings switch. Off hides the free gap rows.
    static func make(blocks: [Block], schedule: BandSchedule, calendar: Calendar, showFreeTime: Bool) -> DayPlan {
        let sorted = blocks.sorted { $0.start < $1.start }
        let sections = Band.allCases.map { band in
            let bandBlocks = sorted.filter { Timeline.band(of: $0, schedule: schedule, calendar: calendar) == band }
            let gaps = showFreeTime ? Timeline.freeGaps(in: bandBlocks) : []
            // A gap sorts before the block that ends it.
            let rows = (bandBlocks.map { (date: $0.start, order: 1, row: Row.block($0)) }
                + gaps.map { (date: $0.start, order: 0, row: Row.gap($0)) })
                .sorted { ($0.date, $0.order) < ($1.date, $1.order) }
                .map(\.row)
            return BandSection(band: band, blocks: bandBlocks, rows: rows)
        }
        return DayPlan(sections: sections, overlappingIDs: Timeline.overlappingIDs(sorted))
    }
}
