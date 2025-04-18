import Foundation

struct Trip: Identifiable, Equatable {
    let id: UUID
    var name: String
    var locations: [TripLocation1]
    var teamMembers: [TeamMember]
    var chatGroups: [ChatGroup]

    // Default initializer
    init(
        id: UUID = UUID(),
        name: String,
        locations: [TripLocation1] = [],
        teamMembers: [TeamMember] = [],
        chatGroups: [ChatGroup] = []
    ) {
        self.id = id
        self.name = name
        self.locations = locations
        self.teamMembers = teamMembers
        self.chatGroups = chatGroups
    }

    // Equatable by ID
    static func == (lhs: Trip, rhs: Trip) -> Bool {
        return lhs.id == rhs.id
    }
}
