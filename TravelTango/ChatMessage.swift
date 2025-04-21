import Foundation

struct ChatMessage: Identifiable, Hashable {
    let id: UUID
    var senderID: UUID
    var content: String
    var timestamp: Date
    var type: MessageType

    init(
        id: UUID = UUID(),
        senderID: UUID,
        content: String,
        type: MessageType = .text,
        timestamp: Date = Date()
    ) {
        self.id = id
        self.senderID = senderID
        self.content = content
        self.timestamp = timestamp
        self.type = type
    }
}

enum MessageType: String, Codable {
    case text
    case image
    case document
    case location
    case contact
    case audio
}
