import Foundation
import Testing
@testable import Luna

@Suite struct ProjectItemsTests {
    private let projectID = UUID()
    private let today = TestCalendar.date(2026, 10, 29, 10)

    private func block(_ hour: Int, day: Int = 29, done: Bool = false, completedAt: Date? = nil, project: UUID? = nil) -> Block {
        var block = TestCalendar.task(start: TestCalendar.date(2026, 10, day, hour), minutes: 30)
        block.done = done
        block.completedAt = completedAt
        block.projectID = project ?? projectID
        return block
    }

    private func task(day: Date? = nil, done: Bool = false, completedAt: Date? = nil) -> AnytimeTask {
        AnytimeTask(title: "Task", icon: "circle", color: .sage, done: done, completedAt: completedAt, day: day, projectID: projectID)
    }

    private func inboxItem(project: UUID?) -> InboxItem {
        InboxItem(title: "Item", durationMinutes: 15, icon: "circle", color: .sand, projectID: project)
    }

    @Test func scheduledHasOpenDatedItemsInDateOrder() {
        let late = block(15)
        let early = block(9, day: 30)
        let dated = task(day: TestCalendar.date(2026, 10, 30))
        let store = PlannerStore(blocks: [early, late, block(8, done: true)], anytimeTasks: [dated, task()])
        let items = ProjectItems(projectID: projectID, in: store)
        #expect(items.scheduled.map(\.id) == [late.id, dated.id, early.id])
    }

    @Test func anytimeHasUndatedTasksThenInboxThenSomeday() {
        let undated = task()
        let inbox = inboxItem(project: projectID)
        let someday = inboxItem(project: projectID)
        let store = PlannerStore(
            anytimeTasks: [task(done: true), undated],
            inboxItems: [inbox, inboxItem(project: nil)],
            somedayItems: [someday, inboxItem(project: UUID())]
        )
        let items = ProjectItems(projectID: projectID, in: store)
        #expect(items.anytime == [.anytimeTask(undated), .inbox(inbox), .someday(someday)])
    }

    @Test func doneIsNewestFirst() {
        let older = block(8, done: true, completedAt: TestCalendar.date(2026, 10, 28, 9))
        let newer = task(done: true, completedAt: today)
        let store = PlannerStore(blocks: [older], anytimeTasks: [newer])
        let items = ProjectItems(projectID: projectID, in: store)
        #expect(items.done.map(\.id) == [newer.id, older.id])
    }

    @Test func eventsAndOtherProjectsDoNotShow() {
        var event = Block(kind: .event, title: "Standup", start: today, durationMinutes: 15)
        event.projectID = projectID
        let store = PlannerStore(blocks: [event, block(9, project: UUID())])
        let items = ProjectItems(projectID: projectID, in: store)
        #expect(items.scheduled.isEmpty && items.anytime.isEmpty && items.done.isEmpty)
    }

    @Test func groupsMatchProgressCounts() {
        let store = PlannerStore.sample()
        for project in store.projects {
            let items = ProjectItems(projectID: project.id, in: store)
            let progress = ProjectProgress(projectID: project.id, in: store)
            #expect(items.scheduled.count + items.anytime.count == progress.open)
            #expect(items.done.count == progress.done)
        }
    }
}
