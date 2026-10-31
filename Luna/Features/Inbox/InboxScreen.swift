import SwiftUI

/// The Inbox tab: tasks with no time yet. A swipe places a task in a band of today. See docs/screens/inbox.md.
struct InboxScreen: View {
    @Environment(PlannerStore.self) private var store
    @Environment(AppRouter.self) private var router
    @Environment(\.appClock) private var clock
    @Environment(\.calendar) private var calendar
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    /// The band of the last place that found no free slot. It shows the inline message.
    @State private var noFitBand: Band?
    /// Changes on every place that finds no free slot. It plays the warning haptic and restarts the message timer.
    @State private var noFitCount = 0
    @State private var editingItemID: InboxItem.ID?
    @State private var draftTitle = ""

    /// Settings edits the band starts in 1b.5.
    private let schedule = BandSchedule.standard

    var body: some View {
        List {
            Section {
                if store.inboxItems.isEmpty {
                    InboxEmptyView()
                } else {
                    ForEach(store.inboxItems) { item in
                        InboxRow(
                            item: item,
                            tag: projectName(item.projectID),
                            onPlace: { place(item, in: $0) },
                            onEdit: { startEditing(item) },
                            onDelete: { withRowAnimation { store.deleteInboxItem(id: item.id) } }
                        )
                    }
                    .onMove { store.moveInboxItems(fromOffsets: $0, toOffset: $1) }
                }
            } header: {
                header
            } footer: {
                footer
            }
            .listRowBackground(Color.surfacePrimary)
            .listRowSeparatorTint(Color.dividerDefault)
            .listRowInsets(EdgeInsets(top: 0, leading: 14, bottom: 0, trailing: LunaSpacing.rowHorizontalPadding))
        }
        .environment(\.defaultMinListRowHeight, 0)
        .listStyle(.insetGrouped)
        .contentMargins(.top, 0, for: .scrollContent)
        .contentMargins(.horizontal, LunaSpacing.screenMargin, for: .scrollContent)
        .contentMargins(.bottom, LunaTabBar.height + LunaSpacing.sectionGap, for: .scrollContent)
        .scrollContentBackground(.hidden)
        .background(Color.bgCanvas)
        .toolbar(.hidden, for: .navigationBar)
        .sensoryFeedback(.warning, trigger: noFitCount)
        .task(id: noFitCount) {
            guard noFitBand != nil else { return }
            try? await Task.sleep(for: .seconds(2.5))
            withAnimation(LunaMotion.animation(.easeOut(duration: LunaMotion.fast), reduceMotion: reduceMotion)) {
                noFitBand = nil
            }
        }
        .alert("Edit title", isPresented: isEditing) {
            TextField("Title", text: $draftTitle)
            Button("Save") {
                if let editingItemID { store.renameInboxItem(id: editingItemID, title: draftTitle) }
            }
            Button("Cancel", role: .cancel) {}
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: Self.sectionSpacing) {
            LargeTitleHeader(title: "Inbox", subtitle: subtitle, subtitlePosition: .below)
            Button { router.openQuickAdd() } label: {
                HStack(spacing: 10) {
                    Image(systemName: "plus")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(Color.iconSecondary)
                    // 17 pt regular.
                    Text("Add to Inbox")
                        .font(.body)
                        .foregroundStyle(Color.textTertiary)
                }
                .padding(.horizontal, 18)
                .frame(maxWidth: .infinity, minHeight: 50, alignment: .leading)
                .background(Color.surfacePrimary, in: Capsule())
                .contentShape(Capsule())
            }
            .buttonStyle(PressScaleButtonStyle(scale: LunaMotion.PressScale.standard))
            .padding(.horizontal, LunaSpacing.screenMargin)
        }
        // The list margin already insets the row. The header keeps its own margin, as on Today.
        .padding(.horizontal, -LunaSpacing.screenMargin)
        .padding(.top, 14)
        .padding(.bottom, Self.sectionSpacing)
        .textCase(nil)
        .listRowInsets(EdgeInsets())
    }

    /// The mockup's gap between the header, the add button, the list card, and the footnote.
    private static let sectionSpacing: CGFloat = 20

    private var footer: some View {
        VStack(alignment: .leading, spacing: 10) {
            if let noFitBand {
                Label("No free time in \(noFitBand.displayName)", systemImage: "exclamationmark.circle")
                    .lunaTextStyle(.label)
                    .foregroundStyle(Color.textPrimary)
                    .transition(.opacity)
            }
            Text("Swipe right to place a task in Morning, Afternoon or Night. On Today, drag it from the Inbox drawer to an exact time.")
                .lunaTextStyle(.meta)
                .foregroundStyle(Color.textTertiary)
        }
        .textCase(nil)
        .padding(.top, 12)
        .listRowInsets(EdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 4))
    }

    private var subtitle: String {
        store.inboxItems.isEmpty ? "All scheduled" : "\(store.inboxItems.count) to schedule"
    }

    private var isEditing: Binding<Bool> {
        Binding(get: { editingItemID != nil }, set: { if !$0 { editingItemID = nil } })
    }

    private func projectName(_ id: UUID?) -> String? {
        guard let id else { return nil }
        return store.projects.first { $0.id == id }?.name
    }

    private func startEditing(_ item: InboxItem) {
        draftTitle = item.title
        editingItemID = item.id
    }

    /// Places the item at the first free slot of the band today, or shows "No free time in <Band>".
    private func place(_ item: InboxItem, in band: Band) {
        let placed = withRowAnimation {
            store.placeInBand(inboxItemID: item.id, band: band, now: clock.now(), schedule: schedule, calendar: calendar)
        }
        if placed == nil {
            withAnimation(LunaMotion.animation(.easeOut(duration: LunaMotion.fast), reduceMotion: reduceMotion)) {
                noFitBand = band
            }
            noFitCount += 1
            AccessibilityNotification.Announcement("No free time in \(band.displayName)").post()
        } else {
            noFitBand = nil
        }
    }

    private func withRowAnimation<Result>(_ body: () -> Result) -> Result {
        withAnimation(LunaMotion.animation(.easeInOut(duration: LunaMotion.normal), reduceMotion: reduceMotion), body)
    }
}

#Preview("Dark") {
    NavigationStack { InboxScreen() }
        .environment(AppRouter())
        .sampleEnvironment()
        .preferredColorScheme(.dark)
}

#Preview("Light") {
    NavigationStack { InboxScreen() }
        .environment(AppRouter())
        .sampleEnvironment()
        .preferredColorScheme(.light)
}

#Preview("Empty") {
    NavigationStack { InboxScreen() }
        .environment(AppRouter())
        .environment(PlannerStore())
        .preferredColorScheme(.dark)
}
