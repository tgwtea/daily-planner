import SwiftUI

/// The Projects tab: smart lists, then projects grouped by area. Each row pushes its list or project.
/// The header "+" menu adds a project or an area. See docs/screens/projects.md.
struct ProjectsScreen: View {
    private enum NewSheet: Identifiable {
        case project
        case area

        var id: Self { self }
    }

    @Environment(PlannerStore.self) private var store
    @Environment(\.appClock) private var clock
    @Environment(\.calendar) private var calendar
    @State private var newSheet: NewSheet?

    var body: some View {
        TimelineView(.everyMinute) { _ in
            let today = clock.now()
            ScrollView {
                VStack(alignment: .leading, spacing: 28) {
                    LargeTitleHeader(title: "Projects") { addMenu }
                        // The header keeps its own margin, as on Today.
                        .padding(.horizontal, -LunaSpacing.screenMargin)
                    GroupedList {
                        ForEach(SmartList.allCases) { list in
                            NavigationLink(value: AppRoute.smartList(list)) {
                                GroupedRow(
                                    title: list.title,
                                    systemImage: list.systemImage,
                                    value: list.count(in: store, today: today, calendar: calendar).map(String.init),
                                    showsChevron: true
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    if store.projects.isEmpty {
                        ProjectsEmptyView { newSheet = .project }
                    } else {
                        ForEach(store.areas) { area in
                            let projects = store.projects(inArea: area.id)
                            if !projects.isEmpty {
                                AreaSection(area: area, projects: projects, calendar: calendar)
                            }
                        }
                        let unassigned = store.projects(inArea: nil)
                        if !unassigned.isEmpty {
                            AreaSection(area: nil, projects: unassigned, calendar: calendar)
                        }
                    }
                }
                .padding(.horizontal, LunaSpacing.screenMargin)
                .padding(.top, 14)
                .padding(.bottom, LunaTabBar.height + LunaSpacing.sectionGap)
            }
            .scrollIndicators(.hidden)
        }
        .background(Color.bgCanvas)
        .toolbar(.hidden, for: .navigationBar)
        .sheet(item: $newSheet) { sheet in
            switch sheet {
            case .project: NewProjectSheet()
            case .area: NewAreaSheet()
            }
        }
    }

    private var addMenu: some View {
        Menu {
            Button("New Project", systemImage: "folder.badge.plus") { newSheet = .project }
            Button("New Area", systemImage: "square.grid.2x2") { newSheet = .area }
        } label: {
            Image(systemName: "plus")
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(Color.textPrimary)
                .frame(width: LunaSpacing.minHitTarget, height: LunaSpacing.minHitTarget)
                .lunaGlass(in: Circle())
                .contentShape(Circle())
        }
        .accessibilityLabel("Add")
    }
}

#Preview("Dark") {
    NavigationStack { ProjectsScreen() }
        .sampleEnvironment()
        .preferredColorScheme(.dark)
}

#Preview("Light") {
    NavigationStack { ProjectsScreen() }
        .sampleEnvironment()
        .preferredColorScheme(.light)
}

#Preview("Empty") {
    NavigationStack { ProjectsScreen() }
        .environment(PlannerStore())
        .preferredColorScheme(.dark)
}
