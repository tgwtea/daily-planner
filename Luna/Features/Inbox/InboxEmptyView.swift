import SwiftUI

/// The empty Inbox, inside the list card. See docs/screens/inbox.md#states.
struct InboxEmptyView: View {
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "tray")
                .font(.system(size: 44, weight: .light))
                .foregroundStyle(Color.textTertiary)
                .padding(.bottom, 4)
                .accessibilityHidden(true)
            Text("Inbox is clear")
                .lunaTextStyle(.rowTitle)
                .foregroundStyle(Color.textPrimary)
            Text("Everything has a place in your day.")
                .font(.subheadline)
                .foregroundStyle(Color.textSecondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 36)
        .accessibilityElement(children: .combine)
    }
}

#Preview("Dark") {
    InboxEmptyView()
        .background(Color.surfacePrimary, in: RoundedRectangle(cornerRadius: LunaRadius.groupedList))
        .padding(LunaSpacing.screenMargin)
        .frame(maxHeight: .infinity)
        .background(Color.bgCanvas)
        .preferredColorScheme(.dark)
}

#Preview("Light") {
    InboxEmptyView()
        .background(Color.surfacePrimary, in: RoundedRectangle(cornerRadius: LunaRadius.groupedList))
        .padding(LunaSpacing.screenMargin)
        .frame(maxHeight: .infinity)
        .background(Color.bgCanvas)
        .preferredColorScheme(.light)
}
