import SwiftUI

/// The pushed list of start times for one band. Each start stays at least one hour
/// after the band before it (decided 2026-10-31).
struct BandStartPicker: View {
    let band: Band

    @Environment(\.dismiss) private var dismiss
    @Environment(\.calendar) private var calendar
    @BandScheduleStorage private var schedule

    var body: some View {
        let current = schedule.start(of: band)
        ScrollViewReader { proxy in
            ScrollView {
                GroupedList {
                    ForEach(schedule.allowedStarts(for: band), id: \.self) { minute in
                        Button { select(minute) } label: {
                            GroupedRow(title: BandStartText.label(minute: minute, calendar: calendar)) {
                                if minute == current { checkmark }
                            }
                        }
                        .accessibilityAddTraits(minute == current ? .isSelected : [])
                        .id(minute)
                    }
                }
                .buttonStyle(.plain)
                .padding(.horizontal, LunaSpacing.screenMargin)
                .padding(.vertical, LunaSpacing.sectionGap)
            }
            .onAppear { proxy.scrollTo(current, anchor: .center) }
        }
        .scrollIndicators(.hidden)
        .background(Color.bgCanvas)
        .navigationTitle("\(band.displayName) starts")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var checkmark: some View {
        Image(systemName: "checkmark")
            .font(.system(size: 15, weight: .semibold))
            .foregroundStyle(Color.textPrimary)
            .accessibilityHidden(true)
    }

    private func select(_ minute: Int) {
        var updated = schedule
        if updated.setStart(minute, for: band) { schedule = updated }
        dismiss()
    }
}

#Preview("Dark") {
    NavigationStack { BandStartPicker(band: .morning) }
        .preferredColorScheme(.dark)
}

#Preview("Light") {
    NavigationStack { BandStartPicker(band: .afternoon) }
        .preferredColorScheme(.light)
}
