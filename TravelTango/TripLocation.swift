//
//  TripLocation.swift
//  TravelTango
//
//  Created by Damsara Samarakoon on 2025-04-14.
//

import Foundation
import MapKit

struct TripLocation: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
    let title: String
    let vrImageName: String // NEW
}

