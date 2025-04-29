import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct NewTripView: View {
    @Environment(\.dismiss) var dismiss
    @State private var name: String = ""
    @State private var locations: [TripLocation1] = []
    @State private var isSaving = false
    @State private var errorMessage = ""

    var onSave: (String, [TripLocation1]) -> Void

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                TextField("Trip Name", text: $name)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)

                Button("Add Sample Location") {
                    let sample = TripLocation1(name: "Colombo", latitude: 6.9271, longitude: 79.8612)
                    locations.append(sample)
                }
                .buttonStyle(.bordered)
                .padding(.horizontal)

                if locations.isEmpty {
                    Text("No locations added.")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List(locations) { location in
                        Text(location.name)
                    }
                }

                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }

                Button {
                    saveTripToFirestore()
                } label: {
                    if isSaving {
                        ProgressView()
                    } else {
                        Text("Save Trip")
                    }
                }
                .buttonStyle(.borderedProminent)
                .padding()
                .disabled(name.isEmpty || isSaving)
            }
            .navigationTitle("Create New Trip")
        }
    }

    func saveTripToFirestore() {
        isSaving = true
        errorMessage = ""

        guard let user = Auth.auth().currentUser else {
            errorMessage = "User not logged in."
            isSaving = false
            return
        }

        let db = Firestore.firestore()

        // Query to check if a trip with the same name exists
        db.collection("trips")
            .whereField("userId", isEqualTo: user.uid)
            .whereField("name", isEqualTo: name)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching trips: \(error.localizedDescription)")
                    self.errorMessage = "Error fetching trips: \(error.localizedDescription)"
                    self.isSaving = false
                    return
                }

                if let document = snapshot?.documents.first {
                    self.updateTrip(document: document)
                } else {
                    self.createNewTrip(user: user)
                }
            }
    }

    func createNewTrip(user: User) {
        let db = Firestore.firestore()

        let tripData: [String: Any] = [
            "name": name,
            "userId": user.uid,
            "locations": locations.map { [
                "name": $0.name,
                "latitude": $0.latitude,
                "longitude": $0.longitude
            ]},
            "createdAt": Timestamp(date: Date())
        ]

        db.collection("trips").addDocument(data: tripData) { error in
            self.isSaving = false
            if let error = error {
                print("Error saving trip: \(error.localizedDescription)")
                self.errorMessage = "Failed to save trip: \(error.localizedDescription)"
            } else {
                print("Trip saved successfully for user \(user.uid)")
                self.onSave(self.name, self.locations)
                self.dismiss()
            }
        }
    }

    func updateTrip(document: QueryDocumentSnapshot) {
        let db = Firestore.firestore()
        var existingLocations = document.get("locations") as? [[String: Any]] ?? []
        
        // Add new locations
        for location in locations {
            let locationData: [String: Any] = [
                "name": location.name,
                "latitude": location.latitude,
                "longitude": location.longitude
            ]
            existingLocations.append(locationData)
        }

        // Update the trip document with the new locations
        document.reference.updateData([
            "locations": existingLocations,
            "userId": document.get("userId") ?? ""
        ]) { error in
            self.isSaving = false
            if let error = error {
                print("Error updating trip: \(error.localizedDescription)")
                self.errorMessage = "Failed to update trip: \(error.localizedDescription)"
            } else {
                print("Trip updated successfully")
                self.onSave(self.name, self.locations)
                self.dismiss()
            }
        }
    }

}
