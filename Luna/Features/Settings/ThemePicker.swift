import SwiftUI

struct ThemePicker: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage(SettingsKey.theme) private var theme = AppTheme.defaultValue

    var body: some View {
        ScrollView {
            GroupedList {
                ForEach(AppTheme.allCases, id: \.self) { option in
                    Button {
                        theme = option
                        dismiss()
                    } label: {
                        GroupedRow(title: option.displayName) {
                            if option == theme {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundStyle(Color.textPrimary)
                                    .accessibilityHidden(true)
                            }
                        }
                    }
                    .accessibilityAddTraits(option == theme ? .isSelected : [])
                }
            }
            .buttonStyle(.plain)
            .padding(.horizontal, LunaSpacing.screenMargin)
            .padding(.vertical, LunaSpacing.sectionGap)
        }
        .background(Color.bgCanvas)
        .navigationTitle("Theme")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview("Dark") {
    NavigationStack { ThemePicker() }
        .preferredColorScheme(.dark)
}

#Preview("Light") {
    NavigationStack { ThemePicker() }
        .preferredColorScheme(.light)
}
