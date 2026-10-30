import SwiftUI

/// The empty Quick add sheet. Checkpoint 1c.1 builds it. See docs/screens/quick-add.md.
struct QuickAddSheet: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Color.bgCanvas
                .ignoresSafeArea()
                .navigationTitle("Quick add")
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
    QuickAddSheet().preferredColorScheme(.dark)
}

#Preview("Light") {
    QuickAddSheet().preferredColorScheme(.light)
}
