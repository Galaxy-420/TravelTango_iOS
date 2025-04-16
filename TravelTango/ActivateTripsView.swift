import SwiftUI

struct ActiveTripsView: View {
    @EnvironmentObject var tripManager: TripManager

    var body: some View {
        List {
            ForEach(tripManager.trips) { trip in
                HStack {
                    Text(trip.name)
                    Spacer()

                    // ✅ Looks like a toggle, acts like a toggle
                    Button(action: {
                        if tripManager.currentTrip?.id != trip.id {
                            tripManager.switchTrip(id: trip.id)
                        }
                    }) {
                        Image(systemName: tripManager.currentTrip?.id == trip.id ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(tripManager.currentTrip?.id == trip.id ? .blue : .gray)
                    }
                    .buttonStyle(.plain)
                }
                .swipeActions {
                    Button(role: .destructive) {
                        tripManager.deleteTrip(id: trip.id)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }

                    Button {
                        // TODO: Navigate to edit screen
                        print("Edit tapped for trip: \(trip.name)")
                    } label: {
                        Label("Edit", systemImage: "pencil")
                    }
                }
            }
        }
        .navigationTitle("Active Trips")
    }
}
