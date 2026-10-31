import SwiftUI

/// The Noir switch: 51 × 31 pt. Dark uses a white track with a black thumb when on.
/// The system switch keeps a white thumb, so it cannot show the dark "on" state.
struct LunaSwitchStyle: ToggleStyle {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    static let size = CGSize(width: 51, height: 31)
    static let thumbInset: CGFloat = 2

    func makeBody(configuration: Configuration) -> some View {
        Button {
            withAnimation(LunaMotion.animation(.easeOut(duration: LunaMotion.fast), reduceMotion: reduceMotion)) {
                configuration.isOn.toggle()
            }
        } label: {
            Capsule()
                .fill(configuration.isOn ? Color.switchTrackOn : Color.switchTrackOff)
                .overlay(alignment: configuration.isOn ? .trailing : .leading) {
                    Circle()
                        .fill(configuration.isOn ? Color.switchThumbOn : Color.switchThumbOff)
                        .shadow(color: .black.opacity(0.15), radius: 2, y: 1)
                        .padding(Self.thumbInset)
                }
                .frame(width: Self.size.width, height: Self.size.height)
                // The hit target is 44 pt tall, but the switch takes only its 31 pt in layout.
                .frame(height: LunaSpacing.minHitTarget)
                .contentShape(Rectangle())
                .padding(.vertical, -(LunaSpacing.minHitTarget - Self.size.height) / 2)
        }
        .buttonStyle(.plain)
        .accessibilityRepresentation {
            Toggle(isOn: configuration.$isOn) { configuration.label }
        }
    }
}

extension ToggleStyle where Self == LunaSwitchStyle {
    static var luna: LunaSwitchStyle { LunaSwitchStyle() }
}

#Preview("Dark") {
    LunaSwitchPreview().preferredColorScheme(.dark)
}

#Preview("Light") {
    LunaSwitchPreview().preferredColorScheme(.light)
}

private struct LunaSwitchPreview: View {
    @State private var on = true
    @State private var off = false

    var body: some View {
        HStack(spacing: 20) {
            Toggle("On", isOn: $on).labelsHidden()
            Toggle("Off", isOn: $off).labelsHidden()
        }
        .toggleStyle(.luna)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.bgCanvas)
    }
}
