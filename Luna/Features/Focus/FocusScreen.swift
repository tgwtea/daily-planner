import SwiftUI

/// The empty Focus screen, shown as a full-screen cover. Checkpoint 1c.6 builds it. See docs/screens/focus.md.
struct FocusScreen: View {
    @Environment(PlannerStore.self) private var store
    @Environment(\.dismiss) private var dismiss
    let blockID: Block.ID

    var body: some View {
        NavigationStack {
            Color.bgCanvas
                .ignoresSafeArea()
                .navigationTitle(store.blocks.first { $0.id == blockID }?.title ?? "Focus")
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
    FocusScreen(blockID: PlannerStore.sample().blocks[0].id)
        .sampleEnvironment()
        .preferredColorScheme(.dark)
}

#Preview("Light") {
    FocusScreen(blockID: PlannerStore.sample().blocks[0].id)
        .sampleEnvironment()
        .preferredColorScheme(.light)
}
