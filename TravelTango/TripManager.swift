import Foundation
import SwiftUI

class TripManager: ObservableObject {
    @Published var trips: [Trip] = []
    @Published var currentTrip: Trip?

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
}
