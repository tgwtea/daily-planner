#if DEBUG
import SwiftUI

/// Every shared component in every state, for Xcode previews and the 1a.5 check. The app never shows it.
struct ComponentsGallery: View {
    /// Launch with this argument to show the gallery instead of the app (DEBUG only).
    static let launchArgument = "-LunaComponentsGallery"

    @State private var blockDone = false
    @State private var stepDone = true
    @State private var bandExpanded = true
    @State private var habitCount = 5
    @State private var showFreeTime = true

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: LunaSpacing.sectionGap) {
                LargeTitleHeader(title: "Components", subtitle: "Thursday, October 29") {
                    ChipButton(title: "Plan", systemImage: "sparkles") {}
                }
                .padding(.horizontal, -LunaSpacing.screenMargin)

                section("Block pill") {
                    HStack(alignment: .top, spacing: 10) {
                        BlockPill(appearance: .planned(.slate), systemImage: "laptopcomputer", height: 97, accessibilityLabel: "Deep work") {}
                        BlockPill(appearance: .active(.rose, progress: 0.4), systemImage: "doc.text", height: 82, accessibilityLabel: "Write") {}
                        BlockPill(appearance: .done(.sage), systemImage: "dumbbell", height: 67, accessibilityLabel: "Gym") {}
                        BlockPill(appearance: .planned(.sand), systemImage: "sunrise", height: 164, iconAtTop: true, accessibilityLabel: "Morning routine") {}
                        BlockPill(appearance: .event(isPast: false), height: 67, accessibilityLabel: "Standup")
                        BlockPill(appearance: .event(isPast: true), height: 67, accessibilityLabel: "Sync")
                    }
                }

                section("Check circle") {
                    HStack(spacing: 0) {
                        CheckCircle(isOn: blockDone, tint: BlockColor.slate.color) { blockDone.toggle() }
                        CheckCircle(isOn: stepDone, tint: BlockColor.rose.color, size: .small) { stepDone.toggle() }
                        CheckCircle(isOn: false, tint: BlockColor.rose.color, offRing: .borderStrong, size: .small) {}
                        CheckCircle(isOn: true, tint: BlockColor.sage.color, size: .large) {}
                        CheckCircle(isOn: true, tint: .textPrimary, offRing: .borderStrong, checkColor: .textInverse) {}
                        CheckCircle(isOn: false, tint: .textPrimary, offRing: .borderStrong, checkColor: .textInverse) {}
                    }
                }

                section("Chips and add button") {
                    HStack(spacing: 4) {
                        ChipButton(title: "Morning", systemImage: "sunrise", count: 4, isExpanded: bandExpanded) {
                            bandExpanded.toggle()
                        }
                        Spacer()
                        RoundAddButton(label: "Add to Morning") {}
                    }
                    HStack(spacing: 8) {
                        ChipButton(title: "Plan", systemImage: "sparkles") {}
                        ChipButton(title: "Today", systemImage: "calendar", isCompact: true) {}
                    }
                }

                section("Icon tile") {
                    HStack(spacing: 12) {
                        ForEach(BlockColor.allCases) { color in
                            IconTile(systemImage: "book", color: color)
                        }
                        IconTile(systemImage: "airplane", color: .sand, size: 40, shape: .circle)
                    }
                }

                section("Progress ring") {
                    HStack(spacing: 16) {
                        ProgressRing(progress: Double(habitCount) / 8, color: BlockColor.slate.color) {
                            Image(systemName: "drop").foregroundStyle(Color.textPrimary)
                        }
                        .onTapGesture { habitCount = habitCount >= 8 ? 0 : habitCount + 1 }
                        .accessibilityValue("\(habitCount) of 8")
                        ProgressRing(progress: 1, color: BlockColor.sage.color) {
                            Image(systemName: "dumbbell").foregroundStyle(Color.textPrimary)
                        }
                        ProgressRing(progress: 0.3, color: BlockColor.plum.color, diameter: 24, lineWidth: 2.5)
                    }
                }

                section("Grouped list") {
                    GroupedList {
                        GroupedRow(title: "Morning starts", systemImage: "sunrise", value: "6:00 AM", showsChevron: true)
                        GroupedRow(title: "Show free time", systemImage: "clock") {
                            Toggle("Show free time", isOn: $showFreeTime).labelsHidden()
                        }
                        GroupedRow(title: "Calendars", systemImage: "calendar", value: "All", showsChevron: true)
                    }
                }
            }
            .padding(.horizontal, LunaSpacing.screenMargin)
            .padding(.bottom, 40)
        }
        .background(Color.bgCanvas)
    }

    private func section(_ title: String, @ViewBuilder content: () -> some View) -> some View {
        VStack(alignment: .leading, spacing: LunaSpacing.sectionHeaderGap) {
            Text(title)
                .lunaTextStyle(.sectionHeading)
                .foregroundStyle(Color.textPrimary)
            content()
        }
    }
}

#Preview("Dark") {
    ComponentsGallery().preferredColorScheme(.dark)
}

#Preview("Light") {
    ComponentsGallery().preferredColorScheme(.light)
}
#endif
