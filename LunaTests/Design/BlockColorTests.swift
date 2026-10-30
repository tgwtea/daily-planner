import Testing
@testable import Luna

@Suite struct BlockColorTests {
    @Test func casesAreInDocumentedOrder() {
        #expect(BlockColor.allCases == [.rose, .slate, .sage, .sand, .plum])
    }

    @Test func displayNamesMatchDesignReference() {
        #expect(BlockColor.allCases.map(\.displayName) == ["Rose", "Slate", "Sage", "Sand", "Plum"])
    }
}
