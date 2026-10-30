import Testing
@testable import Luna

/// Smoke test. It proves that the test target links against the app module.
@Suite struct FoundationTests {
    @Test func rootViewCanBeCreated() {
        _ = ContentView()
    }
}
