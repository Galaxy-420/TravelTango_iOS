import SwiftUI
import GoogleMaps

struct PanoramaView: UIViewRepresentable {
    let coordinate: CLLocationCoordinate2D

    func makeUIView(context: Context) -> GMSPanoramaView {
        let panoramaView = GMSPanoramaView(frame: .zero)
        panoramaView.moveNearCoordinate(coordinate)
        return panoramaView
    }

    func updateUIView(_ uiView: GMSPanoramaView, context: Context) {
        uiView.moveNearCoordinate(coordinate)
    }
}
