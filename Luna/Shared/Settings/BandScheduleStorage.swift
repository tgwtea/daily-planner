import SwiftUI

/// Reads and writes the three band starts in `@AppStorage`.
/// Today, Inbox, and Settings use it so a change in Settings moves blocks at once.
@propertyWrapper
struct BandScheduleStorage: DynamicProperty {
    @AppStorage(SettingsKey.morningStart) private var morningStart = BandSchedule.standard.morningStart
    @AppStorage(SettingsKey.afternoonStart) private var afternoonStart = BandSchedule.standard.afternoonStart
    @AppStorage(SettingsKey.nightStart) private var nightStart = BandSchedule.standard.nightStart

    var wrappedValue: BandSchedule {
        get { BandSchedule(morningStart: morningStart, afternoonStart: afternoonStart, nightStart: nightStart) }
        nonmutating set {
            morningStart = newValue.morningStart
            afternoonStart = newValue.afternoonStart
            nightStart = newValue.nightStart
        }
    }
}
