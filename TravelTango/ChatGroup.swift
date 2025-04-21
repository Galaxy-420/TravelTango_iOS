import Foundation

struct ChatGroup: Identifiable, Equatable, Hashable {
    let id: UUID
    var name: String
    var imageName: String?      // Optional group image name (e.g., file name or SF Symbol)
    var memberIDs: [UUID]       // List of TeamMember IDs
    var messages: [ChatMessage] // Chat history

    // Custom initializer with defaults
    init(
        id: UUID = UUID(),
        name: String,
        memberIDs: [UUID],
        messages: [ChatMessage] = [],
        imageName: String? = nil
    ) {
        self.id = id
        self.name = name
        self.memberIDs = memberIDs
        self.messages = messages
        self.imageName = imageName
    }

    // Equatable (compare by ID)
    static func == (lhs: ChatGroup, rhs: ChatGroup) -> Bool {
        lhs.id == rhs.id
    }

    // Hashable (to support things like Set, Dictionary, ForEach with diffing)
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
