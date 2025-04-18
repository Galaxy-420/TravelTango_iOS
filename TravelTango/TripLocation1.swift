import Foundation
import MapKit

struct TripLocation1: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let latitude: Double
    let longitude: Double

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    static func == (lhs: TripLocation1, rhs: TripLocation1) -> Bool {
        lhs.id == rhs.id
    }
}
