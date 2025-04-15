import SwiftUI

struct NewTripView: View {
    @Environment(\.dismiss) var dismiss
    @State private var name: String = ""
    @State private var locations: [TripLocation1] = []

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

                Button("Save Trip") {
                    onSave(name, locations)
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                .padding()
            }
            .navigationTitle("Create New Trip")
        }
    }
}
