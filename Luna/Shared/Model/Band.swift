import Foundation

/// One of the three day parts. The timeline groups blocks by band.
enum Band: String, CaseIterable, Identifiable, Sendable {
    case morning, afternoon, night

    var id: Self { self }

    var displayName: String {
        switch self {
        case .morning: "Morning"
        case .afternoon: "Afternoon"
        case .night: "Night"
        }
    }

    var systemImage: String {
        switch self {
        case .morning: "sunrise"
        case .afternoon: "sun.max"
        case .night: "moon"
        }
    }
}

/// The start minute (after midnight) of each band. Settings edits these values.
struct BandSchedule: Hashable, Sendable {
    var morningStart = 6 * 60
    var afternoonStart = 12 * 60
    var nightStart = 18 * 60

    static let standard = BandSchedule()

    /// A minute before the Morning start belongs to Morning (decided 2026-10-30).
    func band(forMinute minute: Int) -> Band {
        if minute < afternoonStart { return .morning }
        if minute < nightStart { return .afternoon }
        return .night
    }

    /// The minutes that a band covers. Night ends at midnight.
    func range(of band: Band) -> Range<Int> {
        switch band {
        case .morning: morningStart..<afternoonStart
        case .afternoon: afternoonStart..<nightStart
        case .night: nightStart..<(24 * 60)
        }
    }
}
