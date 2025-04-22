import Foundation
import SwiftUI

class TripManager: ObservableObject {
    @Published var trips: [Trip] = []
    @Published var currentTrip: Trip?
    @Published var selectedLocation: TripLocation1? = nil

    // MARK: - Trip Management

    func addTrip(name: String, locations: [TripLocation1] = []) {
        let trip = Trip(name: name, locations: locations)
        trips.append(trip)
        currentTrip = trip
    }

    func updateTrip(id: UUID, name: String, locations: [TripLocation1]) {
        if let index = trips.firstIndex(where: { $0.id == id }) {
            trips[index].name = name
            trips[index].locations = locations

            if currentTrip?.id == id {
                currentTrip = trips[index]
            }
        }
    }

    func deleteTrip(id: UUID) {
        trips.removeAll { $0.id == id }
        if currentTrip?.id == id {
            currentTrip = trips.first
        }
    }

    func switchTrip(id: UUID) {
        currentTrip = trips.first(where: { $0.id == id })
    }

    // MARK: - Team Members

    func addTeamMember(name: String, email: String, phone: String? = nil) {
        guard let id = currentTrip?.id else { return }
        if let index = trips.firstIndex(where: { $0.id == id }) {
            let member = TeamMember(name: name, email: email, phone: phone)
            trips[index].teamMembers.append(member)
            currentTrip = trips[index]
        }
    }

    func getTeamMembers(by ids: [UUID]) -> [TeamMember] {
        currentTrip?.teamMembers.filter { ids.contains($0.id) } ?? []
    }

    // MARK: - Chat Groups

    func addChatGroup(_ group: ChatGroup) {
        guard let currentTripID = currentTrip?.id,
              let index = trips.firstIndex(where: { $0.id == currentTripID }) else { return }

        trips[index].chatGroups.append(group)
        currentTrip = trips[index]
    }

    func updateGroup(_ updated: ChatGroup) {
        guard let currentTripID = currentTrip?.id,
              let tripIndex = trips.firstIndex(where: { $0.id == currentTripID }),
              let groupIndex = trips[tripIndex].chatGroups.firstIndex(where: { $0.id == updated.id }) else { return }

        trips[tripIndex].chatGroups[groupIndex] = updated
        currentTrip = trips[tripIndex]
    }
}
