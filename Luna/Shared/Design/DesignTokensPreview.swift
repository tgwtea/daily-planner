#if DEBUG
import SwiftUI

/// A sheet of every design token, for Xcode previews only. The app never shows it.
struct DesignTokensPreview: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var isPressed = false

    private let colorRoles: [(String, Color)] = [
        ("bg-canvas", .bgCanvas),
        ("bg-secondary", .bgSecondary),
        ("surface-primary", .surfacePrimary),
        ("surface-secondary", .surfaceSecondary),
        ("surface-tertiary", .surfaceTertiary),
        ("surface-interactive", .surfaceInteractive),
        ("surface-raised", .surfaceRaised),
        ("surface-hover", .surfaceHover),
        ("text-primary", .textPrimary),
        ("text-secondary", .textSecondary),
        ("text-tertiary", .textTertiary),
        ("text-inverse", .textInverse),
        ("icon-secondary", .iconSecondary),
        ("border-subtle", .borderSubtle),
        ("border-standard", .borderStandard),
        ("border-strong", .borderStrong),
        ("divider-default", .dividerDefault),
        ("action-primary-bg", .actionPrimaryBackground),
        ("action-primary-fg", .actionPrimaryForeground),
        ("overlay-scrim", .overlayScrim),
        ("drawer-scrim", .drawerScrim),
        ("glass-bg", .glassBackground),
        ("glass-fallback", .glassFallback),
        ("glass-border", .glassBorder),
        ("glass-item-hover", .glassItemHover),
    ]

    private let spacings: [(String, CGFloat)] = [
        ("unit", LunaSpacing.unit),
        ("weekStripMargin", LunaSpacing.weekStripMargin),
        ("sectionHeaderGap", LunaSpacing.sectionHeaderGap),
        ("rowHorizontalPadding", LunaSpacing.rowHorizontalPadding),
        ("screenMargin", LunaSpacing.screenMargin),
        ("sectionGap", LunaSpacing.sectionGap),
        ("minHitTarget", LunaSpacing.minHitTarget),
    ]

    private let radii: [(String, CGFloat)] = [
        ("iconBox", LunaRadius.iconBox),
        ("textField", LunaRadius.textField),
        ("iconPickerCell", LunaRadius.iconPickerCell),
        ("groupedList", LunaRadius.groupedList),
        ("card", LunaRadius.card),
        ("dialog", LunaRadius.dialog),
        ("sheet", LunaRadius.sheet),
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: LunaSpacing.sectionGap) {
                Text("Design tokens").lunaTextStyle(.largeTitle)
                section("Color") { colors }
                section("Block colors") { blockColors }
                section("Typography") { typography }
                section("Spacing") { bars(spacings) }
                section("Radius") { radiusSwatches }
                section("Elevation and motion") { elevationAndMotion }
            }
            .padding(.horizontal, LunaSpacing.screenMargin)
            .foregroundStyle(Color.textPrimary)
        }
        .background(Color.bgCanvas)
    }

    private func section(_ title: String, @ViewBuilder content: () -> some View) -> some View {
        VStack(alignment: .leading, spacing: LunaSpacing.sectionHeaderGap) {
            Text(title).lunaTextStyle(.sectionHeading)
            content()
        }
    }

    private var colors: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 150), alignment: .leading)], spacing: 8) {
            ForEach(colorRoles, id: \.0) { name, color in
                HStack(spacing: 8) {
                    RoundedRectangle(cornerRadius: LunaRadius.iconBox)
                        .fill(color)
                        .strokeBorder(Color.borderStrong, lineWidth: 1)
                        .frame(width: 32, height: 32)
                    Text(name)
                        .lunaTextStyle(.meta)
                        .foregroundStyle(Color.textSecondary)
                }
            }
        }
    }

    private var blockColors: some View {
        HStack(spacing: 12) {
            ForEach(BlockColor.allCases) { blockColor in
                VStack(spacing: 6) {
                    Capsule()
                        .fill(blockColor.color)
                        .frame(width: 52, height: 72)
                        .overlay {
                            Image(systemName: "checkmark").foregroundStyle(BlockColor.ink)
                        }
                    Capsule()
                        .fill(blockColor.doneColor)
                        .frame(width: 52, height: 36)
                        .overlay {
                            Image(systemName: "checkmark")
                                .foregroundStyle(BlockColor.ink.opacity(BlockColor.doneInkOpacity))
                        }
                    Text(blockColor.displayName).lunaTextStyle(.timeLabel)
                }
            }
        }
    }

    private var typography: some View {
        VStack(alignment: .leading, spacing: 6) {
            ForEach(LunaTextStyle.allCases, id: \.self) { style in
                Text(verbatim: style.usesTabularFigures ? "10:20" : String(describing: style))
                    .lunaTextStyle(style)
                    .lineLimit(1)
                    .minimumScaleFactor(0.3)
            }
        }
    }

    private func bars(_ values: [(String, CGFloat)]) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            ForEach(values, id: \.0) { name, value in
                HStack(spacing: 8) {
                    Rectangle().fill(Color.textSecondary).frame(width: value, height: 12)
                    Text("\(name) \(Int(value))")
                        .lunaTextStyle(.meta)
                        .foregroundStyle(Color.textSecondary)
                }
            }
        }
    }

    private var radiusSwatches: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 88))], spacing: 12) {
            ForEach(radii, id: \.0) { name, value in
                VStack(spacing: 4) {
                    RoundedRectangle(cornerRadius: value).fill(Color.surfaceTertiary).frame(width: 80, height: 80)
                    Text("\(name) \(Int(value))")
                        .lunaTextStyle(.timeLabel)
                        .foregroundStyle(Color.textSecondary)
                }
            }
        }
    }

    private var elevationAndMotion: some View {
        HStack(spacing: 24) {
            Circle()
                .fill(Color.actionPrimaryBackground)
                .frame(width: 64, height: 64)
                .overlay { Image(systemName: "plus").foregroundStyle(Color.actionPrimaryForeground) }
                .lunaShadow(.floating)
                .scaleEffect(isPressed ? LunaMotion.PressScale.checkMark : 1)
                .animation(
                    LunaMotion.animation(.easeOut(duration: LunaMotion.instant), reduceMotion: reduceMotion),
                    value: isPressed
                )
                .onLongPressGesture(minimumDuration: 0.4) {} onPressingChanged: { isPressed = $0 }
                .accessibilityLabel("Press scale sample")
            RoundedRectangle(cornerRadius: LunaRadius.card)
                .fill(Color.glassFallback)
                .strokeBorder(Color.glassBorder, lineWidth: 1)
                .frame(width: 120, height: 64)
                .lunaShadow(.overlay)
        }
        .padding(.vertical, 24)
    }
}

#Preview("Dark") {
    DesignTokensPreview().preferredColorScheme(.dark)
}

#Preview("Light") {
    DesignTokensPreview().preferredColorScheme(.light)
}
#endif
