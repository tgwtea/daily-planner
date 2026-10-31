import SwiftUI

/// A settings-style row: a 32 pt icon box, a title, a trailing value, and a chevron or a custom accessory.
/// Put it in a `GroupedList`. See docs/design/design-reference.md#reusable-patterns.
struct GroupedRow<Accessory: View>: View {
    var title: String
    var subtitle: String?
    var systemImage: String?
    var value: String?
    /// Shows a chevron after the value. Use it for a row that pushes or opens something.
    var showsChevron = false
    @ViewBuilder var accessory: Accessory

    static var iconBoxSize: CGFloat { 32 }

    var body: some View {
        HStack(spacing: 12) {
            if let systemImage {
                Image(systemName: systemImage)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(Color.textPrimary)
                    .frame(width: Self.iconBoxSize, height: Self.iconBoxSize)
                    .background(Color.surfaceTertiary, in: RoundedRectangle(cornerRadius: LunaRadius.iconBox))
                    .accessibilityHidden(true)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .lunaTextStyle(.body)
                    .foregroundStyle(Color.textPrimary)
                if let subtitle {
                    Text(subtitle)
                        .lunaTextStyle(.meta)
                        .foregroundStyle(Color.textSecondary)
                }
            }
            Spacer(minLength: 8)
            if let value {
                Text(value)
                    .lunaTextStyle(.body)
                    .foregroundStyle(Color.textSecondary)
            }
            accessory
            if showsChevron {
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Color.textTertiary)
                    .accessibilityHidden(true)
            }
        }
        .padding(.vertical, LunaSpacing.rowVerticalPadding)
        .padding(.horizontal, LunaSpacing.rowHorizontalPadding)
        .frame(minHeight: LunaSpacing.minHitTarget)
        .contentShape(Rectangle())
        .accessibilityElement(children: .combine)
    }
}

extension GroupedRow where Accessory == EmptyView {
    init(
        title: String, subtitle: String? = nil, systemImage: String? = nil,
        value: String? = nil, showsChevron: Bool = false
    ) {
        self.init(title: title, subtitle: subtitle, systemImage: systemImage, value: value, showsChevron: showsChevron) {
            EmptyView()
        }
    }
}

#Preview("Dark") {
    GroupedRowPreview().preferredColorScheme(.dark)
}

#Preview("Light") {
    GroupedRowPreview().preferredColorScheme(.light)
}

#if DEBUG
/// Shared by the `GroupedList` and `GroupedRow` previews.
struct GroupedRowPreview: View {
    @State private var showFreeTime = true

    var body: some View {
        GroupedList {
            GroupedRow(title: "Morning starts", systemImage: "sunrise", value: "6:00 AM", showsChevron: true)
            GroupedRow(title: "Show free time", systemImage: "clock") {
                Toggle("Show free time", isOn: $showFreeTime).labelsHidden()
            }
            GroupedRow(title: "Calendars", subtitle: "Work, Personal", systemImage: "calendar", value: "All", showsChevron: true)
        }
        .padding(LunaSpacing.screenMargin)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.bgCanvas)
    }
}
#endif
