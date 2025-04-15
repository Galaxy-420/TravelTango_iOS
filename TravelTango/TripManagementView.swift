import SwiftUI

struct TripManagementView: View {
    @EnvironmentObject var tripManager: TripManager
    @Environment(\.dismiss) var dismiss

    @State private var showingNewTripView = false

    var body: some View {
        NavigationStack {
            VStack {
                // ➕ Create New Trip Button
                Button(action: {
                    showingNewTripView = true
                }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Create New Trip")
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
                .padding()

                // 📋 List of Existing Trips
                if tripManager.trips.isEmpty {
                    Text("No trips created yet.")
                        .foregroundColor(.gray)
                        .padding(.top, 40)
                } else {
                    List {
                        ForEach(tripManager.trips) { trip in
                            HStack {
                                Text(trip.name)
                                Spacer()
                                if trip.id == tripManager.currentTrip?.id {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.green)
                                }
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                tripManager.switchTrip(id: trip.id)
                                dismiss()
                            }
                        }
                        .onDelete { indexSet in
                            indexSet.forEach { index in
                                let trip = tripManager.trips[index]
                                tripManager.deleteTrip(id: trip.id)
                            }
                        }
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                // Already handled by .onDelete
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                        .swipeActions(edge: .leading) {
                            Button {
                                // Future: Navigate to edit screen
                            } label: {
                                Label("Edit", systemImage: "pencil")
                            }
                        }
                    }
                }
            }
            .navigationTitle("Manage Trips")
            .sheet(isPresented: $showingNewTripView) {
                NewTripView { name, locations in
                    tripManager.addTrip(name: name, locations: locations)
                }
            }
        }
    }
}
