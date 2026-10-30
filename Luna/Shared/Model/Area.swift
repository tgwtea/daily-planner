import Foundation

/// A group of projects, for example Work or Personal.
struct Area: Identifiable, Hashable, Sendable {
    var id = UUID()
    var name: String
    /// An SF Symbol name.
    var icon: String
}
