import SwiftUI

/// The parsed chips under the Quick add text field. The chips wrap to more rows when they do not fit.
struct QuickAddChipRow: View {
    var chips: [QuickAddChip]
    var onTap: (QuickAddChip.Kind) -> Void

    var body: some View {
        WrapLayout(spacing: 6) {
            ForEach(chips) { chip in
                QuickAddChipView(chip: chip) { onTap(chip.kind) }
            }
        }
    }
}

/// One 30 pt capsule on `surface-hover` with a 44 pt hit area.
private struct QuickAddChipView: View {
    var chip: QuickAddChip
    var action: () -> Void

    @ScaledMetric(relativeTo: .footnote) private var textSize: CGFloat = 13

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                if let dot = chip.dot {
                    Circle().fill(dot.color).frame(width: 10, height: 10)
                }
                if let systemImage = chip.systemImage {
                    Image(systemName: systemImage)
                        .font(.system(size: textSize, weight: .medium))
                        .foregroundStyle(Color.iconSecondary)
                }
                Text(chip.title)
                    .font(.system(size: textSize, weight: .medium))
                    .monospacedDigit()
                    .foregroundStyle(Color.textPrimary)
            }
            .padding(.leading, 10)
            .padding(.trailing, 12)
            .frame(minHeight: 30)
            .background(Color.surfaceHover, in: Capsule())
            .frame(minHeight: LunaSpacing.minHitTarget)
            .contentShape(Rectangle())
        }
        .buttonStyle(PressScaleButtonStyle(scale: LunaMotion.PressScale.standard))
        .accessibilityLabel(chip.accessibilityLabel)
    }
}

/// Places views left to right and starts a new row when the width is full.
private struct WrapLayout: Layout {
    var spacing: CGFloat

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let rows = rows(width: proposal.width ?? .infinity, subviews: subviews)
        let width = rows.map(\.width).max() ?? 0
        let height = rows.map(\.height).reduce(0, +)
        return CGSize(width: proposal.width ?? width, height: height)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var y = bounds.minY
        for row in rows(width: bounds.width, subviews: subviews) {
            var x = bounds.minX
            for index in row.indices {
                let size = subviews[index].sizeThatFits(.unspecified)
                subviews[index].place(at: CGPoint(x: x, y: y), proposal: ProposedViewSize(size))
                x += size.width + spacing
            }
            y += row.height
        }
    }

    private struct Row {
        var indices: [Int] = []
        var width: CGFloat = 0
        var height: CGFloat = 0
    }

    private func rows(width: CGFloat, subviews: Subviews) -> [Row] {
        var rows: [Row] = []
        var row = Row()
        for index in subviews.indices {
            let size = subviews[index].sizeThatFits(.unspecified)
            let added = row.indices.isEmpty ? size.width : row.width + spacing + size.width
            if added > width, !row.indices.isEmpty {
                rows.append(row)
                row = Row()
            }
            row.width = row.indices.isEmpty ? size.width : row.width + spacing + size.width
            row.height = max(row.height, size.height)
            row.indices.append(index)
        }
        if !row.indices.isEmpty { rows.append(row) }
        return rows
    }
}

#Preview("Dark") {
    QuickAddChipRowPreview().preferredColorScheme(.dark)
}

#Preview("Light") {
    QuickAddChipRowPreview().preferredColorScheme(.light)
}

private struct QuickAddChipRowPreview: View {
    var body: some View {
        var draft = QuickAddDraft()
        draft.text = "Call the dentist tomorrow 9am 15m"
        return QuickAddChipRow(chips: draft.chips(QuickAddContext(now: SampleData.now, calendar: SampleData.calendar))) { _ in }
            .padding()
            .frame(maxHeight: .infinity)
            .background(Color.bgCanvas)
    }
}
