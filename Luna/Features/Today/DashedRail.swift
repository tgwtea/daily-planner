import SwiftUI

/// The 2 pt dashed vertical line under a pill and in a free gap row.
struct DashedRail: View {
    var color: Color = .borderStandard

    var body: some View {
        RailShape()
            .stroke(color, style: StrokeStyle(lineWidth: 2, dash: [4, 4]))
            .frame(width: 2)
            .accessibilityHidden(true)
    }

    /// `nonisolated`: SwiftUI calls `path(in:)` off the main actor.
    nonisolated private struct RailShape: Shape {
        func path(in rect: CGRect) -> Path {
            Path { path in
                path.move(to: CGPoint(x: rect.midX, y: rect.minY))
                path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
            }
        }
    }
}

#Preview("Dark") {
    DashedRail().frame(height: 80).padding().background(Color.bgCanvas).preferredColorScheme(.dark)
}

#Preview("Light") {
    DashedRail().frame(height: 80).padding().background(Color.bgCanvas).preferredColorScheme(.light)
}
