import SwiftUI

/// A `surfacePrimary` group with radius 20 and a divider above every row after the first.
/// Projects, Settings, Edit block, Inbox, and Anytime use it.
/// See docs/design/design-reference.md#reusable-patterns.
///
/// Use it for a static group of rows. A list that needs swipe actions uses `List`.
struct GroupedList<Content: View>: View {
    @ViewBuilder var content: Content

    var body: some View {
        VStack(spacing: 0) {
            Group(subviews: content) { rows in
                ForEach(Array(rows.enumerated()), id: \.element.id) { index, row in
                    if index > 0 {
                        Rectangle().fill(Color.dividerDefault).frame(height: 1)
                    }
                    row
                }
            }
        }
        .background(Color.surfacePrimary)
        .clipShape(RoundedRectangle(cornerRadius: LunaRadius.groupedList))
    }
}

#Preview("Dark") {
    GroupedRowPreview().preferredColorScheme(.dark)
}

#Preview("Light") {
    GroupedRowPreview().preferredColorScheme(.light)
}
