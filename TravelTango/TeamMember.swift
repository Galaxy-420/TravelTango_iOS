import Foundation

struct TeamMember: Identifiable, Equatable {
    let id: UUID
    var name: String
    var email: String
    var phone: String?
    var joinedDate: Date

    // Default initializer
    init(id: UUID = UUID(), name: String, email: String, phone: String? = nil, joinedDate: Date = Date()) {
        self.id = id
        self.name = name
        self.email = email
        self.phone = phone
        self.joinedDate = joinedDate
    }

    // Equatable by ID
    static func == (lhs: TeamMember, rhs: TeamMember) -> Bool {
        return lhs.id == rhs.id
    }
}
