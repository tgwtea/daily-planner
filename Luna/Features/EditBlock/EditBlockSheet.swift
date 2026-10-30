import SwiftUI

/// The empty Edit block sheet. Checkpoint 1c.3 builds it. See docs/screens/edit-block.md.
struct EditBlockSheet: View {
    @Environment(PlannerStore.self) private var store
    @Environment(\.dismiss) private var dismiss
    let blockID: Block.ID

    var body: some View {
        NavigationStack {
            Color.bgCanvas
                .ignoresSafeArea()
                .navigationTitle(store.blocks.first { $0.id == blockID }?.title ?? "Edit block")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Close", systemImage: "xmark") { dismiss() }
                    }
                }
        }
    }
}

#Preview("Dark") {
    EditBlockSheet(blockID: PlannerStore.sample().blocks[0].id)
        .sampleEnvironment()
        .preferredColorScheme(.dark)
}

#Preview("Light") {
    EditBlockSheet(blockID: PlannerStore.sample().blocks[0].id)
        .sampleEnvironment()
        .preferredColorScheme(.light)
}
