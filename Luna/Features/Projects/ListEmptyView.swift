import SwiftUI

/// The card of a smart list or a project with no items.
struct ListEmptyView: View {
    var systemImage: String
    var message: String

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: systemImage)
                .font(.title2)
                .foregroundStyle(Color.iconSecondary)
                .accessibilityHidden(true)
            Text(message)
                .lunaTextStyle(.meta)
                .foregroundStyle(Color.textSecondary)
        }
        .multilineTextAlignment(.center)
        .padding(.vertical, 40)
        .padding(.horizontal, LunaSpacing.cardPadding)
        .frame(maxWidth: .infinity)
        .background(Color.surfacePrimary, in: RoundedRectangle(cornerRadius: LunaRadius.card))
        .accessibilityElement(children: .combine)
    }
}

#Preview("Dark") {
    ListEmptyView(systemImage: "book.closed", message: SmartList.logbook.emptyMessage)
        .padding(LunaSpacing.screenMargin)
        .frame(maxHeight: .infinity)
        .background(Color.bgCanvas)
        .preferredColorScheme(.dark)
}

#Preview("Light") {
    ListEmptyView(systemImage: "book.closed", message: SmartList.logbook.emptyMessage)
        .padding(LunaSpacing.screenMargin)
        .frame(maxHeight: .infinity)
        .background(Color.bgCanvas)
        .preferredColorScheme(.light)
}
