import SwiftUI

/// The Habits tab with no habits. The mockup has none. Checkpoint 1b.7 adds the add action.
struct HabitsEmptyView: View {
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "repeat")
                .font(.title2)
                .foregroundStyle(Color.iconSecondary)
                .accessibilityHidden(true)
            Text("No habits yet")
                .lunaTextStyle(.rowTitle)
                .foregroundStyle(Color.textPrimary)
            Text("Habits you track show here.")
                .lunaTextStyle(.meta)
                .foregroundStyle(Color.textSecondary)
        }
        .multilineTextAlignment(.center)
        .padding(.vertical, 40)
        .frame(maxWidth: .infinity)
        .background(Color.surfacePrimary, in: RoundedRectangle(cornerRadius: LunaRadius.card))
        .accessibilityElement(children: .combine)
    }
}

#Preview("Dark") {
    HabitsEmptyView()
        .padding(LunaSpacing.screenMargin)
        .frame(maxHeight: .infinity)
        .background(Color.bgCanvas)
        .preferredColorScheme(.dark)
}

#Preview("Light") {
    HabitsEmptyView()
        .padding(LunaSpacing.screenMargin)
        .frame(maxHeight: .infinity)
        .background(Color.bgCanvas)
        .preferredColorScheme(.light)
}
