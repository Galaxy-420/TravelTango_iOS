import SwiftUI

struct ActiveTripsView: View {
    @EnvironmentObject var tripManager: TripManager

    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Your Trips")) {
                    ForEach(tripManager.trips) { trip in
                        HStack {
                            Text(trip.name)
                                .fontWeight(tripManager.currentTrip?.id == trip.id ? .bold : .regular)

                            Spacer()

                            // ✅ Acts like a toggle to switch active trip
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
                                print("Edit tapped for trip: \(trip.name)")
                                // You can later show an edit screen here
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
