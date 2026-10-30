import Foundation

/// The duration text of the design: "15 min", "1 h", "1 h 30 min".
/// Roadmap 3.4 makes it locale-aware.
enum DurationFormat {
    static func string(minutes: Int) -> String {
        let hours = minutes / 60
        let rest = minutes % 60
        if hours == 0 { return "\(minutes) min" }
        if rest == 0 { return "\(hours) h" }
        return "\(hours) h \(rest) min"
    }
}
