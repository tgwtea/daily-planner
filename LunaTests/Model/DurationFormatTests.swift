import Foundation
import Testing
@testable import Luna

@Suite struct DurationFormatTests {
    @Test(arguments: zip(
        [5, 15, 60, 90, 120, 135],
        ["5 min", "15 min", "1 h", "1 h 30 min", "2 h", "2 h 15 min"]
    ))
    func formatsMinutes(minutes: Int, text: String) {
        #expect(DurationFormat.string(minutes: minutes) == text)
    }
}
