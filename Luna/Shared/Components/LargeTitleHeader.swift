import SwiftUI

/// The 34 pt screen title with an optional 15 pt secondary line and trailing controls.
/// Today, Inbox, Projects, Habits, and Settings use it.
/// See docs/design/design-reference.md#reusable-patterns.
struct LargeTitleHeader<Trailing: View>: View {
    enum SubtitlePosition {
        case above
        case below
    }

    var title: String
    var subtitle: String?
    var subtitlePosition: SubtitlePosition = .above
    @ViewBuilder var trailing: Trailing

    var body: some View {
        HStack(alignment: .bottom, spacing: 12) {
            VStack(alignment: .leading, spacing: 2) {
                if subtitlePosition == .above { subtitleText }
                Text(title)
                    .lunaTextStyle(.largeTitle)
                    // A long weekday ("Wednesday") next to trailing controls shrinks instead of wrapping.
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                    .foregroundStyle(Color.textPrimary)
                    .accessibilityAddTraits(.isHeader)
                if subtitlePosition == .below { subtitleText }
            }
            Spacer(minLength: 0)
            HStack(spacing: 8) { trailing }
                .padding(.bottom, 2)
        }
        .padding(.horizontal, LunaSpacing.screenMargin)
    }

    @ViewBuilder private var subtitleText: some View {
        if let subtitle {
            Text(subtitle)
                // 15 pt medium. `.subheadline` is 15 pt and scales with Dynamic Type.
                .font(.subheadline.weight(.medium))
                .foregroundStyle(Color.textSecondary)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
    }
}

extension LargeTitleHeader where Trailing == EmptyView {
    init(title: String, subtitle: String? = nil, subtitlePosition: SubtitlePosition = .above) {
        self.init(title: title, subtitle: subtitle, subtitlePosition: subtitlePosition) { EmptyView() }
    }
}

#Preview("Dark") {
    LargeTitleHeaderPreview().preferredColorScheme(.dark)
}

#Preview("Light") {
    LargeTitleHeaderPreview().preferredColorScheme(.light)
}

private struct LargeTitleHeaderPreview: View {
    var body: some View {
        VStack(alignment: .leading, spacing: LunaSpacing.sectionGap) {
            LargeTitleHeader(title: "Today", subtitle: "Thursday, October 29") {
                ChipButton(title: "Plan", systemImage: "sparkles") {}
            }
            LargeTitleHeader(title: "Inbox", subtitle: "5 items", subtitlePosition: .below)
            LargeTitleHeader(title: "Settings")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color.bgCanvas)
    }
}
