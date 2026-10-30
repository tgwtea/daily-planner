import SwiftUI

/// A circular progress stroke in an item color on a `surfaceTertiary` track.
/// The habit strip and project rows use it. See docs/design/design-reference.md#reusable-patterns.
///
/// The ring is decoration. The caller gives the progress in text or as an accessibility value.
struct ProgressRing<Content: View>: View {
    /// 0...1. Values outside the range are clamped.
    var progress: Double
    var color: Color
    var diameter: CGFloat = 60
    var lineWidth: CGFloat = 3
    @ViewBuilder var content: Content

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        ZStack {
            Circle().stroke(Color.surfaceTertiary, lineWidth: lineWidth)
            Circle()
                .trim(from: 0, to: Self.clamped(progress))
                .stroke(color, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(LunaMotion.animation(.easeOut(duration: LunaMotion.slow), reduceMotion: reduceMotion), value: progress)
            content
        }
        // The stroke centers on the path, so inset it to keep the outer edge at `diameter`.
        .padding(lineWidth / 2)
        .frame(width: diameter, height: diameter)
    }

    static func clamped(_ progress: Double) -> Double {
        guard progress.isFinite else { return 0 }
        return min(max(progress, 0), 1)
    }
}

extension ProgressRing where Content == EmptyView {
    init(progress: Double, color: Color, diameter: CGFloat = 60, lineWidth: CGFloat = 3) {
        self.init(progress: progress, color: color, diameter: diameter, lineWidth: lineWidth) { EmptyView() }
    }
}

#Preview("Dark") {
    ProgressRingPreview().preferredColorScheme(.dark)
}

#Preview("Light") {
    ProgressRingPreview().preferredColorScheme(.light)
}

private struct ProgressRingPreview: View {
    @State private var progress = 0.625

    var body: some View {
        HStack(spacing: 16) {
            ProgressRing(progress: progress, color: BlockColor.slate.color) {
                Image(systemName: "book").foregroundStyle(Color.textPrimary)
            }
            .onTapGesture { progress = progress >= 1 ? 0 : progress + 0.125 }
            ProgressRing(progress: 1, color: BlockColor.sage.color) {
                Image(systemName: "dumbbell").foregroundStyle(Color.textPrimary)
            }
            ProgressRing(progress: 0.3, color: BlockColor.plum.color, diameter: 24, lineWidth: 2.5)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.bgCanvas)
    }
}
