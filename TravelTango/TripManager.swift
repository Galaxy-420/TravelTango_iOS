import Foundation
import SwiftUI

class TripManager: ObservableObject {
    @Published var trips: [Trip] = []
    @Published var currentTrip: Trip?

    // ✅ Add a new trip
    func addTrip(name: String, locations: [TripLocation1] = []) {
        let trip = Trip(name: name, locations: locations)
        trips.append(trip)
        currentTrip = trip
    }

    // ✅ Update existing trip (name or locations)
    func updateTrip(id: UUID, name: String, locations: [TripLocation1]) {
        if let index = trips.firstIndex(where: { $0.id == id }) {
            trips[index].name = name
            trips[index].locations = locations

            if currentTrip?.id == id {
                currentTrip = trips[index]
            }
        }
    }

    // ✅ Delete trip and reset current if needed
    func deleteTrip(id: UUID) {
        trips.removeAll { $0.id == id }
        if currentTrip?.id == id {
            currentTrip = trips.first
        }
    }

    // ✅ Switch active trip
    func switchTrip(id: UUID) {
        currentTrip = trips.first(where: { $0.id == id })
    }

    // ✅ Add team member to current trip
    func addTeamMember(name: String, email: String, phone: String? = nil) {
        guard let id = currentTrip?.id else { return }
        if let index = trips.firstIndex(where: { $0.id == id }) {
            let member = TeamMember(name: name, email: email, phone: phone)
            trips[index].teamMembers.append(member)
            currentTrip = trips[index] // Refresh currentTrip
        }
    }
}
