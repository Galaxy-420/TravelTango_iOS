import Foundation

struct TeamMember: Identifiable, Equatable {
    let id: UUID
    var name: String
    var email: String
    var phone: String?
    var joinedDate: Date

    // 🔐 New property to control expense access
    var hasExpenseAccess: Bool = false

    init(id: UUID = UUID(), name: String, email: String, phone: String? = nil, joinedDate: Date = Date(), hasExpenseAccess: Bool = false) {
        self.id = id
        self.name = name
        self.email = email
        self.phone = phone
        self.joinedDate = joinedDate
        self.hasExpenseAccess = hasExpenseAccess
    }

    static func == (lhs: TeamMember, rhs: TeamMember) -> Bool {
        return lhs.id == rhs.id
    }
}
