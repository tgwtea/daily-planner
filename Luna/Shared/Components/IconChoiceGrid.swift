import SwiftUI

/// A grid of SF Symbols as square buttons, four per row. The selected icon is filled.
struct IconChoiceGrid: View {
    typealias Icon = (symbol: String, name: String)

    var icons: [Icon]
    @Binding var selection: String

    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 8) {
            ForEach(icons, id: \.symbol) { symbol, iconName in
                Button {
                    selection = symbol
                } label: {
                    Image(systemName: symbol)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(symbol == selection ? Color.textInverse : Color.textPrimary)
                        .frame(maxWidth: .infinity, minHeight: LunaSpacing.minHitTarget)
                        .background(
                            symbol == selection ? Color.textPrimary : Color.surfaceTertiary,
                            in: RoundedRectangle(cornerRadius: LunaRadius.iconTile)
                        )
                }
                .buttonStyle(.plain)
                .accessibilityLabel(iconName)
                .accessibilityAddTraits(symbol == selection ? .isSelected : [])
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview("Dark") {
    IconChoiceGridPreview().preferredColorScheme(.dark)
}

#Preview("Light") {
    IconChoiceGridPreview().preferredColorScheme(.light)
}

private struct IconChoiceGridPreview: View {
    @State private var icon = NewAreaSheet.icons[0].symbol

    var body: some View {
        IconChoiceGrid(icons: NewAreaSheet.icons, selection: $icon)
            .padding(LunaSpacing.screenMargin)
            .frame(maxHeight: .infinity)
            .background(Color.bgCanvas)
    }
}
