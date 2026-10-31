import SwiftUI

/// The five block colors as round buttons. The selected color has a ring.
struct ColorChoiceRow: View {
    @Binding var selection: BlockColor

    var body: some View {
        HStack(spacing: 0) {
            ForEach(BlockColor.allCases) { color in
                Button {
                    selection = color
                } label: {
                    Circle()
                        .fill(color.color)
                        .frame(width: 28, height: 28)
                        .padding(4)
                        .overlay {
                            if color == selection {
                                Circle().strokeBorder(Color.textPrimary, lineWidth: 2)
                            }
                        }
                        .frame(maxWidth: .infinity, minHeight: LunaSpacing.minHitTarget)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .accessibilityLabel(color.displayName)
                .accessibilityAddTraits(color == selection ? .isSelected : [])
            }
        }
    }
}

#Preview("Dark") {
    ColorChoiceRowPreview().preferredColorScheme(.dark)
}

#Preview("Light") {
    ColorChoiceRowPreview().preferredColorScheme(.light)
}

private struct ColorChoiceRowPreview: View {
    @State private var color = BlockColor.sage

    var body: some View {
        ColorChoiceRow(selection: $color)
            .padding(LunaSpacing.screenMargin)
            .frame(maxHeight: .infinity)
            .background(Color.bgCanvas)
    }
}
