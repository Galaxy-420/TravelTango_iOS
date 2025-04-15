//
//  Untitled.swift
//  TravelTango
//
//  Created by Damsara Samarakoon on 2025-04-15.
//

import SwiftUI

struct AddTripManagementView: View {
    @EnvironmentObject var tripManager: TripManager
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            List {
                ForEach(tripManager.trips) { trip in
                    HStack {
                        Text(trip.name)
                        Spacer()
                        Button("Use") {
                            tripManager.switchTrip(id: trip.id)
                            dismiss()
                        }
                        .buttonStyle(.bordered)

                        Button("Delete") {
                            tripManager.deleteTrip(id: trip.id)
                        }
                        .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("Manage Trips")
        }
    }
}
