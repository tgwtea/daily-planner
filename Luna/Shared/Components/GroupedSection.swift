import SwiftUI

/// A grouped list with a small header above it and an optional footer below it.
/// Settings uses it. See docs/design/design-reference.md#reusable-patterns.
struct GroupedSection<Content: View>: View {
    var header: String
    var footer: String?
    @ViewBuilder var content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(header)
                .lunaTextStyle(.label)
                .foregroundStyle(Color.textSecondary)
                .padding(.horizontal, 4)
                .accessibilityAddTraits(.isHeader)
            GroupedList { content }
            if let footer {
                Text(footer)
                    .lunaTextStyle(.meta)
                    .foregroundStyle(Color.textSecondary)
                    .padding(.horizontal, 4)
            }
        }
    }
}

#Preview("Dark") {
    GroupedSectionPreview().preferredColorScheme(.dark)
}

#Preview("Light") {
    GroupedSectionPreview().preferredColorScheme(.light)
}

private struct GroupedSectionPreview: View {
    @State private var isOn = true

    var body: some View {
        GroupedSection(header: "Plan my day", footer: "Nothing is scheduled until you add it.") {
            GroupedRow(title: "Suggestions") {
                Toggle("Suggestions", isOn: $isOn).labelsHidden()
            }
        }
        .padding(LunaSpacing.screenMargin)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.bgCanvas)
    }
}
