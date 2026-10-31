import SwiftUI

/// One Inbox task: icon tile, title, "15 min · Health", and a grip. See docs/screens/inbox.md.
/// A leading swipe places the task in a band. The context menu has the same actions and "Open <Project>".
struct InboxRow: View {
    var item: InboxItem
    /// The name of the item's project, shown as its tag.
    var tag: String?
    var onPlace: (Band) -> Void
    var onEdit: () -> Void
    var onDelete: () -> Void
    /// Pushes the project of the tag. `nil` for an item with no project.
    var onOpenProject: (() -> Void)? = nil

    var body: some View {
        HStack(spacing: 12) {
            IconTile(systemImage: item.icon, color: item.color, size: 40, cornerRadius: 14)
            VStack(alignment: .leading, spacing: 3) {
                Text(item.title)
                    .lunaTextStyle(.rowTitle)
                    .foregroundStyle(Color.textPrimary)
                    .lineLimit(1)
                Text(meta)
                    .lunaTextStyle(.meta)
                    .monospacedDigit()
                    .foregroundStyle(Color.textSecondary)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            Image(systemName: "line.3.horizontal")
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(Color.textTertiary)
                .accessibilityHidden(true)
        }
        .padding(.vertical, LunaSpacing.rowVerticalPadding)
        .frame(minHeight: 64)
        // The divider spans the full card width, as in the mockup.
        .alignmentGuide(.listRowSeparatorLeading) { _ in -14 }
        .contentShape(Rectangle())
        // A tap gesture, not a `Button`: a List cell with a button fires it when a swipe ends without opening the actions.
        .onTapGesture(perform: onEdit)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(item.title), \(meta)")
        .accessibilityHint("Edit title")
        .accessibilityAddTraits(.isButton)
        .accessibilityAction { onEdit() }
        .accessibilityActions {
            if let onOpenProject, let tag {
                Button(Self.openProjectLabel(tag), action: onOpenProject)
            }
        }
        .swipeActions(edge: .leading, allowsFullSwipe: false) {
            ForEach(Band.allCases) { band in
                Button(Self.placeLabel(band), systemImage: band.systemImage) { onPlace(band) }
                    .labelStyle(.iconOnly)
                    .tint(Color.swipeActionTint)
            }
        }
        .swipeActions(edge: .trailing) {
            Button("Delete", systemImage: "trash", role: .destructive, action: onDelete)
        }
        .contextMenu {
            ForEach(Band.allCases) { band in
                Button(Self.placeLabel(band), systemImage: band.systemImage) { onPlace(band) }
            }
            Divider()
            if let onOpenProject, let tag {
                Button(Self.openProjectLabel(tag), systemImage: "folder", action: onOpenProject)
            }
            Button("Edit title", systemImage: "pencil", action: onEdit)
            Button("Delete", systemImage: "trash", role: .destructive, action: onDelete)
        }
    }

    private var meta: String {
        let duration = DurationFormat.string(minutes: item.durationMinutes)
        guard let tag else { return duration }
        return "\(duration) · \(tag)"
    }

    static func placeLabel(_ band: Band) -> String {
        "Place in \(band.displayName)"
    }

    static func openProjectLabel(_ tag: String) -> String {
        "Open \(tag)"
    }
}

#Preview("Dark") {
    InboxRowPreview().preferredColorScheme(.dark)
}

#Preview("Light") {
    InboxRowPreview().preferredColorScheme(.light)
}

private struct InboxRowPreview: View {
    @State private var store = PlannerStore.sample()

    var body: some View {
        List {
            ForEach(store.inboxItems) { item in
                InboxRow(item: item, tag: item.projectID == nil ? nil : "Health", onPlace: { _ in }, onEdit: {}, onDelete: {})
                    .listRowBackground(Color.surfacePrimary)
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color.bgCanvas)
    }
}
