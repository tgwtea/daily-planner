import Foundation
import SwiftUI
import Testing
@testable import Luna

@Suite struct BlockPillAppearanceTests {
    private let start = Date(timeIntervalSinceReferenceDate: 0)

    private func block(kind: Block.Kind = .task, done: Bool = false) -> Block {
        Block(kind: kind, title: "Deep work", start: start, durationMinutes: 60,
              icon: kind == .event ? nil : "laptopcomputer", color: kind == .event ? nil : .slate, done: done)
    }

    @Test func plannedBeforeStart() {
        #expect(BlockPill.Appearance(block: block(), now: start.addingTimeInterval(-60)) == .planned(.slate))
    }

    @Test func activeProgressIsFractionOfDuration() {
        #expect(BlockPill.Appearance(block: block(), now: start.addingTimeInterval(15 * 60)) == .active(.slate, progress: 0.25))
    }

    @Test func endTimeIsNotActive() {
        #expect(BlockPill.Appearance(block: block(), now: start.addingTimeInterval(60 * 60)) == .planned(.slate))
    }

    @Test func doneWinsOverActive() {
        #expect(BlockPill.Appearance(block: block(done: true), now: start.addingTimeInterval(15 * 60)) == .done(.slate))
    }

    @Test func eventIsPastAtItsEnd() {
        #expect(BlockPill.Appearance(block: block(kind: .event), now: start.addingTimeInterval(30 * 60)) == .event(isPast: false))
        #expect(BlockPill.Appearance(block: block(kind: .event), now: start.addingTimeInterval(60 * 60)) == .event(isPast: true))
    }
}

@Suite struct ComponentRuleTests {
    @Test func ringProgressIsClamped() {
        #expect(ProgressRing<EmptyView>.clamped(-0.5) == 0)
        #expect(ProgressRing<EmptyView>.clamped(0.4) == 0.4)
        #expect(ProgressRing<EmptyView>.clamped(1.5) == 1)
        #expect(ProgressRing<EmptyView>.clamped(.nan) == 0)
    }

    @Test func chipLabelNamesTheCount() {
        #expect(ChipButton.accessibilityLabel(title: "Morning", count: 4) == "Morning, 4 items")
        #expect(ChipButton.accessibilityLabel(title: "Night", count: 1) == "Night, 1 item")
        #expect(ChipButton.accessibilityLabel(title: "Plan", count: nil) == "Plan")
    }

    @Test func pressScaleOnlyWhilePressedWithoutReduceMotion() {
        let scale = LunaMotion.PressScale.pill
        #expect(PressScaleButtonStyle.effectiveScale(scale, isPressed: true, reduceMotion: false) == scale)
        #expect(PressScaleButtonStyle.effectiveScale(scale, isPressed: true, reduceMotion: true) == 1)
        #expect(PressScaleButtonStyle.effectiveScale(scale, isPressed: false, reduceMotion: false) == 1)
    }
}
