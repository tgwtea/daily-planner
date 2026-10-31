import SwiftUI

/// Capture a block or an Inbox task in one line of plain language. See docs/screens/quick-add.md.
/// Return or "Add" saves. An empty title closes the sheet and saves nothing.
struct QuickAddSheet: View {
    /// The tools that open a panel below the tool row.
    enum Panel: Hashable {
        case date, time, duration, checklist
    }

    private enum Field: Hashable {
        case text, step
    }

    var prefill: QuickAddPrefill = .none

    @Environment(PlannerStore.self) private var store
    @Environment(AppRouter.self) private var router
    @Environment(\.dismiss) private var dismiss
    @Environment(\.appClock) private var clock
    @Environment(\.calendar) private var calendar
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @BandScheduleStorage private var schedule
    /// The color and icon carry over to the next Quick add.
    @AppStorage(SettingsKey.quickAddColor) private var color: BlockColor = .rose
    @AppStorage(SettingsKey.quickAddIcon) private var icon = "phone"

    @State private var draft = QuickAddDraft()
    @State private var panel: Panel?
    @State private var newStep = ""
    @State private var contentHeight: CGFloat = 200
    @FocusState private var focus: Field?
    @ScaledMetric(relativeTo: .title3) private var fieldSize: CGFloat = 19

    private var context: QuickAddContext {
        QuickAddContext(now: clock.now(), calendar: calendar, schedule: schedule)
    }

    /// The draft with the remembered color and icon.
    private var current: QuickAddDraft {
        var current = draft
        current.color = color
        current.icon = icon
        return current
    }

    private var isBlock: Bool { current.destination(context).isBlock }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            inputRow
            QuickAddChipRow(chips: current.chips(context), onTap: tapChip)
            toolRow
            if let panel {
                panelView(panel)
                    .transition(.opacity)
            }
        }
        .padding(.horizontal, LunaSpacing.screenMargin)
        .padding(.top, 20)
        .padding(.bottom, 14)
        .onGeometryChange(for: CGFloat.self) { $0.size.height } action: { contentHeight = $0 }
        .frame(maxHeight: .infinity, alignment: .top)
        .animation(LunaMotion.animation(.easeInOut(duration: LunaMotion.fast), reduceMotion: reduceMotion), value: panel)
        .presentationDetents([.height(contentHeight)])
        .presentationCornerRadius(LunaRadius.sheet)
        .onAppear {
            draft.prefill = prefill
            focus = .text
        }
        .onChange(of: isBlock) { _, isBlock in
            // Repeat and Checklist apply to a block only (decided 2026-10-31).
            if !isBlock, panel == .checklist { panel = nil }
        }
    }

    // MARK: Input

    private var inputRow: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 18)
                .fill(color.color)
                .frame(width: 36, height: 48)
                .overlay {
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(BlockColor.ink)
                }
                .animation(LunaMotion.animation(.easeInOut(duration: LunaMotion.normal), reduceMotion: reduceMotion), value: color)
                .accessibilityHidden(true)
            TextField("Gym tomorrow 7am 45m", text: $draft.text)
                .font(.system(size: fieldSize, weight: .medium))
                .foregroundStyle(Color.textPrimary)
                .focused($focus, equals: .text)
                .submitLabel(.done)
                .onSubmit(save)
                .accessibilityLabel("New block")
        }
    }

    // MARK: Tools

    private var toolRow: some View {
        HStack(spacing: 4) {
            panelButton(.date, systemImage: "calendar", label: "Date")
            panelButton(.time, systemImage: "clock", label: "Time")
            panelButton(.duration, systemImage: "timer", label: "Duration")
            Button {
                icon = BlockIcons.next(after: icon)
            } label: {
                ToolIcon(systemImage: "square.on.circle", isActive: false)
            }
            .buttonStyle(PressScaleButtonStyle(scale: LunaMotion.PressScale.iconButton))
            .accessibilityLabel("Icon")
            .accessibilityValue(BlockIcons.name(of: icon))
            Menu {
                Picker("Repeat", selection: $draft.repeatRule) {
                    ForEach(RepeatRule.allCases) { rule in
                        Text(rule.displayName).tag(rule)
                    }
                }
            } label: {
                ToolIcon(systemImage: "repeat", isActive: isBlock && draft.repeatRule != .never)
            }
            .disabled(!isBlock)
            .accessibilityLabel("Repeat")
            .accessibilityValue(draft.repeatRule.displayName)
            panelButton(.checklist, systemImage: "checklist", label: "Checklist")
                .disabled(!isBlock)
            Spacer(minLength: 0)
            Button(action: save) {
                Image(systemName: "arrow.up")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(Color.actionPrimaryForeground)
                    .frame(width: 40, height: 40)
                    .background(Color.actionPrimaryBackground, in: Circle())
                    .frame(width: LunaSpacing.minHitTarget, height: LunaSpacing.minHitTarget)
                    .contentShape(Circle())
            }
            .buttonStyle(PressScaleButtonStyle(scale: LunaMotion.PressScale.checkMark))
            .accessibilityLabel("Add")
        }
    }

    private func panelButton(_ tool: Panel, systemImage: String, label: String) -> some View {
        Button {
            panel = panel == tool ? nil : tool
        } label: {
            ToolIcon(systemImage: systemImage, isActive: panel == tool)
        }
        .buttonStyle(PressScaleButtonStyle(scale: LunaMotion.PressScale.iconButton))
        .accessibilityLabel(label)
        .accessibilityAddTraits(panel == tool ? .isSelected : [])
    }

    private func tapChip(_ kind: QuickAddChip.Kind) {
        switch kind {
        case .day: panel = .date
        case .time, .band, .destination: panel = .time
        case .duration: panel = .duration
        case .checklist: panel = .checklist
        case .repeatRule:
            let rules = RepeatRule.allCases
            draft.repeatRule = rules[(rules.firstIndex(of: draft.repeatRule)! + 1) % rules.count]
        case .color: color = color.next
        }
    }

    // MARK: Panels

    @ViewBuilder
    private func panelView(_ panel: Panel) -> some View {
        switch panel {
        case .date:
            DatePicker("Date", selection: dayBinding, displayedComponents: .date)
                .datePickerStyle(.compact)
                .lunaTextStyle(.label)
        case .time:
            DatePicker("Time", selection: timeBinding, displayedComponents: .hourAndMinute)
                .datePickerStyle(.compact)
                .lunaTextStyle(.label)
        case .duration:
            durationChoices
        case .checklist:
            checklist
        }
    }

    private var dayBinding: Binding<Date> {
        Binding(
            get: { current.day(context) ?? calendar.startOfDay(for: context.now) },
            set: { draft.setDay($0, context) }
        )
    }

    /// The time on the shown day. Without a time, it starts at the next quarter hour.
    private var timeBinding: Binding<Date> {
        Binding(
            get: {
                let context = context
                let day = current.day(context) ?? calendar.startOfDay(for: context.now)
                let minute = current.minute(context)
                    ?? SlotSearch.roundedUp(Timeline.minuteOfDay(context.now, calendar: calendar))
                return calendar.date(byAdding: .minute, value: minute, to: day) ?? day
            },
            set: { draft.setTime(minute: Timeline.minuteOfDay($0, calendar: calendar), context) }
        )
    }

    private var durationChoices: some View {
        let selected = current.parsed(context).durationMinutes
        return ScrollView(.horizontal) {
            HStack(spacing: 6) {
                ForEach(QuickAddDraft.durationChoices, id: \.self) { minutes in
                    let isSelected = minutes == selected
                    Button {
                        draft.setDuration(minutes, context)
                    } label: {
                        Text(DurationFormat.string(minutes: minutes))
                            .lunaTextStyle(.label)
                            .monospacedDigit()
                            .foregroundStyle(isSelected ? Color.textInverse : Color.textPrimary)
                            .padding(.horizontal, 12)
                            .frame(minHeight: 30)
                            .background(isSelected ? Color.textPrimary : Color.surfaceHover, in: Capsule())
                            .frame(minHeight: LunaSpacing.minHitTarget)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(PressScaleButtonStyle(scale: LunaMotion.PressScale.standard))
                    .accessibilityAddTraits(isSelected ? .isSelected : [])
                }
            }
        }
        .scrollIndicators(.hidden)
    }

    private var checklist: some View {
        VStack(alignment: .leading, spacing: 4) {
            ForEach(draft.steps.indices, id: \.self) { index in
                HStack(spacing: 8) {
                    Image(systemName: "circle")
                        .font(.system(size: 16))
                        .foregroundStyle(Color.borderStrong)
                        .accessibilityHidden(true)
                    Text(draft.steps[index])
                        .lunaTextStyle(.body)
                        .foregroundStyle(Color.textPrimary)
                    Spacer(minLength: 0)
                    Button("Remove step", systemImage: "minus.circle") {
                        draft.steps.remove(at: index)
                    }
                    .labelStyle(.iconOnly)
                    .foregroundStyle(Color.iconSecondary)
                    .frame(width: LunaSpacing.minHitTarget, height: LunaSpacing.minHitTarget)
                    .accessibilityLabel("Remove \(draft.steps[index])")
                }
            }
            HStack(spacing: 8) {
                Image(systemName: "plus")
                    .font(.system(size: 16))
                    .foregroundStyle(Color.iconSecondary)
                    .accessibilityHidden(true)
                TextField("Add a step", text: $newStep)
                    .lunaTextStyle(.body)
                    .focused($focus, equals: .step)
                    .submitLabel(.next)
                    .onSubmit(addStep)
            }
            .frame(minHeight: LunaSpacing.minHitTarget)
        }
    }

    private func addStep() {
        let title = newStep.trimmingCharacters(in: .whitespacesAndNewlines)
        if !title.isEmpty { draft.steps.append(title) }
        newStep = ""
        focus = .step
    }

    // MARK: Save

    private func save() {
        var item = current
        // A step that the user typed but did not submit still counts.
        if !newStep.trimmingCharacters(in: .whitespaces).isEmpty { item.steps.append(newStep) }
        let context = context
        if case .block(_, let start) = store.addQuickAdd(item, context: context) {
            router.showToday(on: start, now: context.now, calendar: calendar)
        }
        dismiss()
    }
}

/// A 40 pt round tool button face with a 44 pt hit area.
private struct ToolIcon: View {
    var systemImage: String
    var isActive: Bool

    @Environment(\.isEnabled) private var isEnabled

    var body: some View {
        Image(systemName: systemImage)
            .font(.system(size: 20))
            .foregroundStyle(isActive ? Color.textPrimary : Color.iconSecondary)
            .opacity(isEnabled ? 1 : 0.4)
            .frame(width: 40, height: 40)
            .background(isActive ? Color.glassItemHover : .clear, in: Circle())
            .frame(width: LunaSpacing.minHitTarget, height: LunaSpacing.minHitTarget)
            .contentShape(Circle())
    }
}

#Preview("Dark") {
    QuickAddSheetPreview().preferredColorScheme(.dark)
}

#Preview("Light") {
    QuickAddSheetPreview().preferredColorScheme(.light)
}

private struct QuickAddSheetPreview: View {
    var body: some View {
        Color.bgCanvas
            .ignoresSafeArea()
            .sheet(isPresented: .constant(true)) {
                QuickAddSheet()
            }
            .environment(AppRouter())
            .sampleEnvironment()
    }
}
