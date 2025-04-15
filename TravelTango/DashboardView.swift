import SwiftUI
import MapKit

struct DashboardView: View {
    @EnvironmentObject var tripManager: TripManager

    @State private var mapRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 7.8731, longitude: 80.7718),
        span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
    )

    @State private var showingNewTripPage = false
    @State private var showingCameraPage = false

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                let pins = tripManager.currentTrip?.locations ?? []

                Map(coordinateRegion: $mapRegion, annotationItems: pins) { location in
                    MapAnnotation(coordinate: location.coordinate) {
                        VStack {
                            Circle()
                                .fill(Color.red)
                                .frame(width: 30, height: 30)
                            Text(location.name)
                                .font(.caption)
                                .foregroundColor(.black)
                        }
                    }
                }
                .edgesIgnoringSafeArea(.all)

                VStack {
                    Button(action: {
                        showingNewTripPage = true
                    }) {
                        HStack {
                            Image(systemName: "plus")
                            Text("Create New Trip")
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 3)
                    }
                    .padding()

                    Spacer()
                }

                VStack {
                    HStack {
                        Spacer()
                        Button(action: {
                            showingCameraPage = true
                        }) {
                            Image(systemName: "camera.viewfinder")
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(radius: 3)
                        }
                        .padding()
                    }
                    Spacer()
                }
            }
            .sheet(isPresented: $showingNewTripPage) {
                NewTripView { name, locations in
                    tripManager.addTrip(name: name, locations: locations)
                }
            }
            .navigationTitle(tripManager.currentTrip?.name ?? "Dashboard")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
