//
//  TripManagementView.swift
//  TravelTango
//
//  Created by Damsara Samarakoon on 2025-04-15.
//
import SwiftUI

struct TripManagementView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var tripManager: TripManager
    @State private var showingNewTripSheet = false

    var body: some View {
        NavigationStack {
            VStack {
                Button(action: {
                    showingNewTripSheet = true
                }) {
                    Label("Create New Trip", systemImage: "plus")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding()
                }

                List {
                    ForEach(tripManager.trips) { trip in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(trip.name)
                                    .font(.headline)
                            }
                            Spacer()
                            Button("Edit") {
                                // You can show NewTripView pre-filled
                            }
                            .foregroundColor(.orange)

                            Button("Delete") {
                                tripManager.deleteTrip(id: trip.id)
                            }
                            .foregroundColor(.red)
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            tripManager.switchTrip(id: trip.id)
                            dismiss()
                        }
                    }
                }
            }
            .navigationTitle("Manage Trips")
            .sheet(isPresented: $showingNewTripSheet) {
                NewTripView() // Reuse your trip creation screen
            }
        }
    }
}

