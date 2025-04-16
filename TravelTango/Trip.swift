import Foundation

// ✅ Trip model — represents an entire journey like "Kandy Trip"
struct Trip: Identifiable, Equatable {
    let id: UUID
    var name: String
    var locations: [TripLocation1]
    var teamMembers: [TeamMember] = [] // ✅ New: Each trip has its own team

    // Default initializer
    init(id: UUID = UUID(), name: String, locations: [TripLocation1] = [], teamMembers: [TeamMember] = []) {
        self.id = id
        self.name = name
        self.locations = locations
        self.teamMembers = teamMembers
    }

    // Equatable conformance (compare by ID only)
    static func == (lhs: Trip, rhs: Trip) -> Bool {
        return lhs.id == rhs.id
    }
}
