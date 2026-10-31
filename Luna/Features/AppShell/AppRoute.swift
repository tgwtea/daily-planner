import Foundation

/// A screen that a tab pushes onto its `NavigationStack`.
enum AppRoute: Hashable, Sendable {
    case calendar
    case project(Project.ID)
    case smartList(SmartList)
    case bandStart(Band)
    case theme
}
