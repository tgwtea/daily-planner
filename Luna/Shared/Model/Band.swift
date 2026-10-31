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
    /// A band is at least one hour long. Decided 2026-10-31.
    static let minimumLength = 60
    static let step = 15
    static let dayLength = 24 * 60

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
        case .night: nightStart..<Self.dayLength
        }
    }

    func start(of band: Band) -> Int {
        switch band {
        case .morning: morningStart
        case .afternoon: afternoonStart
        case .night: nightStart
        }
    }

    /// The starts a band can take while it keeps the order Morning < Afternoon < Night
    /// with each band at least `minimumLength` long. Values are in `step` increments.
    func allowedStarts(for band: Band) -> [Int] {
        let gap = Self.minimumLength
        let bounds = switch band {
        case .morning: (0, afternoonStart - gap)
        case .afternoon: (morningStart + gap, nightStart - gap)
        case .night: (afternoonStart + gap, Self.dayLength - gap)
        }
        let first = (bounds.0 + Self.step - 1) / Self.step * Self.step
        guard first <= bounds.1 else { return [] }
        return Array(stride(from: first, through: bounds.1, by: Self.step))
    }

    /// Sets a band start. Returns false and changes nothing when the value is not allowed.
    @discardableResult
    mutating func setStart(_ minute: Int, for band: Band) -> Bool {
        guard allowedStarts(for: band).contains(minute) else { return false }
        switch band {
        case .morning: morningStart = minute
        case .afternoon: afternoonStart = minute
        case .night: nightStart = minute
        }
        return true
    }
}
