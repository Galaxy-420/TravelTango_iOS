//
//  Trip.swift
//  TravelTango
//
//  Created by Damsara Samarakoon on 2025-04-15.
//
import Foundation
import MapKit

struct SelectedLocation: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let latitude: Double
    let longitude: Double

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

struct Trip: Identifiable, Equatable {
    let id: UUID
    var name: String
    var locations: [SelectedLocation]
}
