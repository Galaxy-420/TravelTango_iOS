import Foundation

struct Reminder: Identifiable, Hashable {
    let id: UUID
    var title: String
    var description: String
    var date: Date

    // ✅ Allows you to pass a custom ID or let it auto-generate
    init(id: UUID = UUID(), title: String, description: String, date: Date) {
        self.id = id
        self.title = title
        self.description = description
        self.date = date
    }
}
