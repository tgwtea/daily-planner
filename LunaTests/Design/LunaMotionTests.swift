import SwiftUI
import Testing
@testable import Luna

@Suite struct LunaMotionTests {
    @Test func reduceMotionRemovesAnimation() {
        #expect(LunaMotion.animation(LunaMotion.selectionSpring, reduceMotion: true) == nil)
    }

    @Test func animationStaysWithoutReduceMotion() {
        #expect(LunaMotion.animation(LunaMotion.selectionSpring, reduceMotion: false) == LunaMotion.selectionSpring)
    }
}
