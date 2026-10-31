import Foundation
import Testing
@testable import Luna

@Suite struct ProjectProgressTests {
    private let calendar = TestCalendar.utc
    private let day = TestCalendar.date(2026, 10, 29, 9)
    private let projectID = UUID()

    private func block(kind: Block.Kind = .task, done: Bool = false, steps: [Step] = [], projectID: UUID?) -> Block {
        Block(kind: kind, title: "Block", start: day, durationMinutes: 30, steps: steps, done: done, projectID: projectID)
    }

    @Test func countsBlocksTasksAndInboxItems() {
        let store = PlannerStore(
            blocks: [
                block(done: true, projectID: projectID),
                block(projectID: projectID),
                block(kind: .routine, steps: [Step(title: "A", done: true)], projectID: projectID),
                block(kind: .event, projectID: projectID),
                block(done: true, projectID: UUID()),
            ],
            anytimeTasks: [
                AnytimeTask(title: "Done", icon: "circle", color: .sage, done: true, projectID: projectID),
                AnytimeTask(title: "Open", icon: "circle", color: .sage, projectID: projectID),
            ],
            inboxItems: [InboxItem(title: "Inbox", durationMinutes: 15, icon: "circle", color: .rose, projectID: projectID)],
            somedayItems: [InboxItem(title: "Someday", durationMinutes: 15, icon: "circle", color: .rose, projectID: projectID)]
        )
        let progress = ProjectProgress(projectID: projectID, in: store)
        #expect(progress == ProjectProgress(done: 3, open: 4))
        #expect(progress.percent == 43)
    }

    @Test func noItemsGivesZero() {
        let progress = ProjectProgress(projectID: projectID, in: PlannerStore())
        #expect(progress.fraction == 0)
        #expect(progress.percent == 0)
    }

    @Test func percentRounds() {
        #expect(ProjectProgress(done: 7, open: 5).percent == 58)
        #expect(ProjectProgress(done: 5, open: 2).percent == 71)
        #expect(ProjectProgress(done: 1, open: 3).fraction == 0.25)
    }

    @Test func timingText() {
        var calendar = calendar
        calendar.locale = Locale(identifier: "en_US")
        #expect(Project.Timing.noDate.text(calendar: calendar) == "No date")
        #expect(Project.Timing.ongoing.text(calendar: calendar) == "Ongoing")
        #expect(Project.Timing.due(TestCalendar.date(2026, 11, 14)).text(calendar: calendar) == "Due Nov 14")
        #expect(Project.Timing.span(TestCalendar.date(2026, 12, 18), TestCalendar.date(2026, 12, 27)).text(calendar: calendar) == "Dec 18\u{2009}–\u{2009}27")
        #expect(Project.Timing.span(TestCalendar.date(2026, 11, 28), TestCalendar.date(2026, 12, 3)).text(calendar: calendar) == "Nov 28\u{2009}–\u{2009}Dec 3")
    }

    @Test func timingTextFollowsLocale() {
        var calendar = calendar
        calendar.locale = Locale(identifier: "en_GB")
        #expect(Project.Timing.due(TestCalendar.date(2026, 11, 14)).text(calendar: calendar) == "Due 14 Nov")
        #expect(Project.Timing.span(TestCalendar.date(2026, 12, 18), TestCalendar.date(2026, 12, 27)).text(calendar: calendar) == "18\u{2009}–\u{2009}27 Dec")
    }

    @Test func projectsInAreaKeepStoreOrder() {
        let area = Area(name: "Work", icon: "briefcase")
        let a = Project(name: "A", color: .slate, areaID: area.id)
        let b = Project(name: "B", color: .sage)
        let c = Project(name: "C", color: .sand, areaID: area.id)
        let store = PlannerStore(areas: [area], projects: [a, b, c])
        #expect(store.projects(inArea: area.id).map(\.name) == ["A", "C"])
        #expect(store.projects(inArea: nil).map(\.name) == ["B"])
    }
}
