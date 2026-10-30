import SwiftUI

/// Temporary root view for the foundation build.
/// Replace it with the tab shell described in docs/screens/README.md.
struct ContentView: View {
    var body: some View {
        VStack(spacing: 8) {
            Text("Luna")
                .font(.largeTitle.bold())
            Text("Foundation build")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
