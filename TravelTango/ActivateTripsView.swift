import SwiftUI

struct ActiveTripsView: View {
    @EnvironmentObject var tripManager: TripManager

    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Your Trips")) {
                    ForEach(tripManager.trips, id: \.id) { trip in
                        HStack {
                            Text(trip.name)
                                .fontWeight(tripManager.currentTrip?.id == trip.id ? .bold : .regular)

                            Spacer()

                            Button {
                                tripManager.switchTrip(id: trip.id)
                            } label: {
                                Image(systemName: tripManager.currentTrip?.id == trip.id ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(tripManager.currentTrip?.id == trip.id ? .blue : .gray)
                            }
                            .buttonStyle(.plain)
                        }
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                tripManager.deleteTrip(id: trip.id)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }

                            Button {
                                // Implement Edit functionality here
                                print("Edit tapped for trip: \(trip.name)")
                            } label: {
                                Label("Edit", systemImage: "pencil")
                            }
                        }
                    }
                }
            }
            .navigationTitle("Active Trips")
        }
    }
}
