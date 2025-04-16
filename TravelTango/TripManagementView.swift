import SwiftUI

struct TripManagementView: View {
    @EnvironmentObject var tripManager: TripManager
    @Environment(\.dismiss) var dismiss

    @State private var showingNewTripView = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                // ➕ Create New Trip Button
                Button(action: {
                    showingNewTripView = true
                }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Create New Trip")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
                .padding(.horizontal)
                .padding(.top)

                // 📋 Trip List
                if tripManager.trips.isEmpty {
                    Spacer()
                    Text("No trips created yet.")
                        .foregroundColor(.gray)
                        .padding(.top, 40)
                    Spacer()
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
                        .swipeActions(edge: .leading) {
                            Button {
                                // TODO: Navigate to edit trip view
                                print("Edit trip")
                            } label: {
                                Label("Edit", systemImage: "pencil")
                            }
                            .tint(.blue)
                        }
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                // Handled by .onDelete
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                }

                Spacer()
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
