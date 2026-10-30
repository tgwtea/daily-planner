/// The five main tabs. See docs/screens/README.md#navigation-map.
enum AppTab: Hashable, CaseIterable, Sendable {
    case today
    case inbox
    case projects
    case habits
    case settings

    var title: String {
        switch self {
        case .today: "Today"
        case .inbox: "Inbox"
        case .projects: "Projects"
        case .habits: "Habits"
        case .settings: "Settings"
        }
    }

    var systemImage: String {
        switch self {
        case .today: "calendar"
        case .inbox: "tray"
        case .projects: "folder"
        case .habits: "repeat"
        case .settings: "slider.horizontal.3"
        }
    }
}
