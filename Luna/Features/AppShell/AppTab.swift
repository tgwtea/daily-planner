/// The four main tabs. Settings is a push from the Today header. See docs/screens/README.md#navigation-map.
enum AppTab: Hashable, CaseIterable, Sendable {
    case today
    case inbox
    case projects
    case habits

    var title: String {
        switch self {
        case .today: "Today"
        case .inbox: "Inbox"
        case .projects: "Projects"
        case .habits: "Habits"
        }
    }

    var systemImage: String {
        switch self {
        case .today: "calendar"
        case .inbox: "tray"
        case .projects: "folder"
        case .habits: "repeat"
        }
    }
}
