import Foundation

/// A project in an area. See docs/features/projects-and-areas.md.
struct Project: Identifiable, Hashable, Sendable {
    /// The date line of a project row: "No date", "Ongoing", "Due Nov 14", "Dec 18 – 27".
    enum Timing: Hashable, Sendable {
        case noDate
        case ongoing
        case due(Date)
        case span(Date, Date)
    }

    var id = UUID()
    var name: String
    var color: BlockColor
    var areaID: UUID?
    var timing: Timing = .noDate
}
