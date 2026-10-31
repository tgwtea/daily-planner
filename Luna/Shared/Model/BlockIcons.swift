import Foundation

/// The 12 icons that a user can give a block, in the mockup picker order.
/// Quick add cycles through them. Edit block shows them as a grid.
enum BlockIcons {
    static let all: [IconChoiceGrid.Icon] = [
        ("laptopcomputer", "Laptop"), ("doc.text", "Document"), ("arrow.triangle.pull", "Pull request"),
        ("dumbbell", "Workout"), ("bicycle", "Bike"), ("fork.knife", "Meal"),
        ("book", "Book"), ("phone", "Phone"), ("basket", "Shopping"),
        ("moon", "Moon"), ("sunrise", "Sunrise"), ("airplane", "Travel"),
    ]

    /// The icon after `symbol`. The last icon goes back to the first. An unknown symbol gives the first icon.
    static func next(after symbol: String) -> String {
        guard let index = all.firstIndex(where: { $0.symbol == symbol }) else { return all[0].symbol }
        return all[(index + 1) % all.count].symbol
    }

    /// The spoken name of an icon, or the symbol name for an icon that is not in the list.
    static func name(of symbol: String) -> String {
        all.first { $0.symbol == symbol }?.name ?? symbol
    }
}
