import SwiftUI

/// A tile in a block color with an ink icon, for Anytime, Inbox, habit, drawer, and proposal rows.
/// See docs/design/design-reference.md#reusable-patterns. The tile is decoration.
struct IconTile: View {
    enum Shape {
        case roundedSquare
        case circle
    }

    var systemImage: String
    var color: BlockColor
    /// 36 pt in rows. 40 pt in larger cells.
    var size: CGFloat = 36
    var shape: Shape = .roundedSquare

    var body: some View {
        Image(systemName: systemImage)
            .font(.system(size: size / 2, weight: .medium))
            .foregroundStyle(BlockColor.ink)
            .frame(width: size, height: size)
            .background(color.color, in: tileShape)
            .accessibilityHidden(true)
    }

    private var tileShape: AnyShape {
        switch shape {
        case .roundedSquare: AnyShape(RoundedRectangle(cornerRadius: LunaRadius.iconTile))
        case .circle: AnyShape(Circle())
        }
    }
}

#Preview("Dark") {
    IconTilePreview().preferredColorScheme(.dark)
}

#Preview("Light") {
    IconTilePreview().preferredColorScheme(.light)
}

private struct IconTilePreview: View {
    var body: some View {
        HStack(spacing: 12) {
            IconTile(systemImage: "book", color: .rose)
            IconTile(systemImage: "phone", color: .slate)
            IconTile(systemImage: "basket", color: .sage, size: 40)
            IconTile(systemImage: "airplane", color: .sand, shape: .circle)
            IconTile(systemImage: "fork.knife", color: .plum, size: 40, shape: .circle)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.bgCanvas)
    }
}
