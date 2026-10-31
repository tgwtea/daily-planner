import SwiftUI

/// The Projects tab: smart lists, then projects grouped by area. Display only. See docs/screens/projects.md.
struct ProjectsScreen: View {
    @Environment(PlannerStore.self) private var store
    @Environment(\.appClock) private var clock
    @Environment(\.calendar) private var calendar

    var body: some View {
        TimelineView(.everyMinute) { _ in
            let today = clock.now()
            ScrollView {
                VStack(alignment: .leading, spacing: 28) {
                    LargeTitleHeader(title: "Projects")
                        // The header keeps its own margin, as on Today.
                        .padding(.horizontal, -LunaSpacing.screenMargin)
                    GroupedList {
                        ForEach(SmartList.allCases) { list in
                            GroupedRow(
                                title: list.title,
                                systemImage: list.systemImage,
                                value: list.count(in: store, today: today, calendar: calendar).map(String.init),
                                showsChevron: true
                            )
                        }
                    }
                    if store.projects.isEmpty {
                        ProjectsEmptyView()
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
