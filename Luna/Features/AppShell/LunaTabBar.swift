import SwiftUI

/// The floating tab bar: a glass capsule with the five tabs and a separate primary "+" circle.
/// See docs/design/design-reference.md#reusable-patterns (Floating tab bar).
struct LunaTabBar: View {
    @Environment(AppRouter.self) private var router
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Namespace private var selection

    static let height: CGFloat = 64

    var body: some View {
        HStack(spacing: LunaSpacing.sectionHeaderGap) {
            HStack(spacing: 0) {
                ForEach(AppTab.allCases, id: \.self) { tab in
                    tabButton(tab)
                }
            }
            .padding(LunaSpacing.unit)
            .frame(height: Self.height)
            .lunaGlass(in: Capsule())

            Button("Add", systemImage: "plus") { router.openQuickAdd() }
                .labelStyle(.iconOnly)
                .font(.title2.weight(.semibold))
                .foregroundStyle(Color.actionPrimaryForeground)
                .frame(width: Self.height, height: Self.height)
                .background(Color.actionPrimaryBackground, in: Circle())
                .contentShape(Circle())
                .buttonStyle(PressScaleButtonStyle(scale: LunaMotion.PressScale.checkMark))
                .lunaShadow(.floating)
                .accessibilityLabel("Quick add")
        }
        .padding(.horizontal, LunaSpacing.screenMargin)
    }

    private func tabButton(_ tab: AppTab) -> some View {
        let isSelected = router.selectedTab == tab
        return Button {
            withAnimation(LunaMotion.animation(LunaMotion.selectionSpring, reduceMotion: reduceMotion)) {
                router.selectedTab = tab
            }
        } label: {
            VStack(spacing: 2) {
                Image(systemName: tab.systemImage)
                    .font(.system(size: 20, weight: .regular))
                    .frame(height: 24)
                Text(tab.title)
                    .lunaTextStyle(.tabLabel)
            }
            .foregroundStyle(isSelected ? Color.textPrimary : Color.iconSecondary)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background {
                if isSelected {
                    Capsule()
                        .fill(Color.glassItemHover)
                        .matchedGeometryEffect(id: "selection", in: selection)
                }
            }
            .contentShape(Capsule())
        }
        .buttonStyle(PressScaleButtonStyle(scale: LunaMotion.PressScale.standard))
        .accessibilityLabel(tab.title)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

/// Scales the label while pressed. No scale under Reduce Motion.
private struct PressScaleButtonStyle: ButtonStyle {
    let scale: CGFloat
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed && !reduceMotion ? scale : 1)
            .animation(.easeOut(duration: LunaMotion.instant), value: configuration.isPressed)
    }
}

private extension View {
    /// System glass, or the opaque fallback with a border under Reduce Transparency.
    func lunaGlass(in shape: some Shape) -> some View {
        modifier(LunaGlassModifier(shape: AnyShape(shape)))
    }
}

private struct LunaGlassModifier: ViewModifier {
    let shape: AnyShape
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency

    func body(content: Content) -> some View {
        if reduceTransparency {
            content
                .background(Color.glassFallback, in: shape)
                .overlay(shape.stroke(Color.glassBorder, lineWidth: 1))
                .lunaShadow(.floating)
        } else {
            content.glassEffect(.regular, in: shape)
        }
    }
}

#Preview("Dark") {
    ZStack(alignment: .bottom) {
        Color.bgCanvas.ignoresSafeArea()
        LunaTabBar()
    }
    .environment(AppRouter())
    .preferredColorScheme(.dark)
}

#Preview("Light") {
    ZStack(alignment: .bottom) {
        Color.bgCanvas.ignoresSafeArea()
        LunaTabBar()
    }
    .environment(AppRouter())
    .preferredColorScheme(.light)
}
