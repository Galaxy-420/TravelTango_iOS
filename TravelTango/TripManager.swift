import Foundation
import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseAuth

class TripManager: ObservableObject {
    @Published var trips: [Trip] = []
    @Published var currentTrip: Trip?
    @Published var selectedLocation: TripLocation1? = nil
    private var db = Firestore.firestore()

    init() {
        loadTrips()
    }

    func loadTrips() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("No authenticated user.")
            return
        }

        db.collection("users").document(userId).collection("trips")
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching trips: \(error)")
                    return
                }

                DispatchQueue.main.async {
                    self.trips = snapshot?.documents.compactMap { doc -> Trip? in
                        let data = doc.data()
                        guard let name = data["name"] as? String else { return nil }

                        return Trip(id: doc.documentID, name: name, locations: []) // Only load name & ID
                    } ?? []

                    if self.trips.isEmpty {
                        self.currentTrip = nil
                    } else if let currentID = self.currentTrip?.id,
                              !self.trips.contains(where: { $0.id == currentID }) {
                        self.currentTrip = self.trips.first
                    }
                }
            }
    }

    func addTrip(name: String, locations: [TripLocation1] = []) {
        let trip = Trip(name: name, locations: locations)
        trips.append(trip)
        currentTrip = trip

        let tripData: [String: Any] = [
            "name": trip.name,
            "locations": trip.locations.map { [
                "name": $0.name,
                "latitude": $0.latitude,
                "longitude": $0.longitude
            ] },
            "teamMembers": [],
            "chatGroups": []
        ]

        guard let userId = Auth.auth().currentUser?.uid else { return }

        db.collection("users").document(userId).collection("trips").document(trip.id).setData(tripData) { error in
            if let error = error {
                print("Error adding trip: \(error)")
            }
        }
    }

    func updateTrip(id: String, name: String, locations: [TripLocation1]) {
        if let index = trips.firstIndex(where: { $0.id == id }) {
            trips[index].name = name
            trips[index].locations = locations

            if currentTrip?.id == id {
                currentTrip = trips[index]
            }

            let tripData: [String: Any] = [
                "name": trips[index].name,
                "locations": trips[index].locations.map { [
                    "name": $0.name,
                    "latitude": $0.latitude,
                    "longitude": $0.longitude
                ] },
                "teamMembers": trips[index].teamMembers.map { [
                    "name": $0.name,
                    "email": $0.email,
                    "phone": $0.phone ?? ""
                ] },
                "chatGroups": trips[index].chatGroups.map { [
                    "id": $0.id,
                    "name": $0.name
                ] }
            ]

            guard let userId = Auth.auth().currentUser?.uid else { return }

            db.collection("users").document(userId).collection("trips").document(id).setData(tripData) { error in
                if let error = error {
                    print("Error updating trip: \(error)")
                }
            }
        }
    }

    func deleteTrip(id: String) {
        trips.removeAll { $0.id == id }
        if currentTrip?.id == id {
            currentTrip = trips.first
        }

        guard let userId = Auth.auth().currentUser?.uid else { return }

        db.collection("users").document(userId).collection("trips").document(id).delete { error in
            if let error = error {
                print("Error deleting trip: \(error)")
            }
        }
    }
    // Save current trip ID to Firestore
    func saveCurrentTripToFirestore() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        guard let currentTripId = currentTrip?.id else { return }
        
        db.collection("users").document(userId).updateData([
            "currentTripID": currentTripId
        ]) { error in
            if let error = error {
                print("Error saving current trip ID: \(error.localizedDescription)")
            } else {
                print("Current trip ID saved successfully")
            }
        }
    }

    // Load current trip ID from Firestore and set it
    func loadCurrentTripFromFirestore() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        db.collection("users").document(userId).getDocument { document, error in
            if let error = error {
                print("Error fetching current trip ID: \(error.localizedDescription)")
                return
            }
            
            if let document = document, document.exists {
                if let currentTripID = document.data()?["currentTripID"] as? String {
                    DispatchQueue.main.async {
                        self.currentTrip = self.trips.first(where: { $0.id == currentTripID })
                    }
                }
            }
        }
    }
    
    func switchTrip(id: String) {
        currentTrip = trips.first(where: { $0.id == id })
        saveCurrentTripToFirestore() // ✅ Add this!
    }


    func addTeamMember(name: String, email: String, phone: String? = nil) {
        guard let id = currentTrip?.id else { return }
        if let index = trips.firstIndex(where: { $0.id == id }) {
            let member = TeamMember(name: name, email: email, phone: phone)
            trips[index].teamMembers.append(member)
            currentTrip = trips[index]

            updateTrip(id: id, name: trips[index].name, locations: trips[index].locations)
        }
    }

    func getTeamMembers(by ids: [UUID]) -> [TeamMember] {
        currentTrip?.teamMembers.filter { ids.contains($0.id) } ?? []
    }

    func addChatGroup(_ group: ChatGroup) {
        guard let currentTripID = currentTrip?.id,
              let index = trips.firstIndex(where: { $0.id == currentTripID }) else { return }

        trips[index].chatGroups.append(group)
        currentTrip = trips[index]

        updateTrip(id: currentTripID, name: trips[index].name, locations: trips[index].locations)
    }

    func updateGroup(_ updated: ChatGroup) {
        guard let currentTripID = currentTrip?.id,
              let tripIndex = trips.firstIndex(where: { $0.id == currentTripID }),
              let groupIndex = trips[tripIndex].chatGroups.firstIndex(where: { $0.id == updated.id }) else { return }

        trips[tripIndex].chatGroups[groupIndex] = updated
        currentTrip = trips[tripIndex]

        updateTrip(id: currentTripID, name: trips[tripIndex].name, locations: trips[tripIndex].locations)
    }
}
