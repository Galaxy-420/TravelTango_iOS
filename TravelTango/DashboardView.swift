import SwiftUI
import MapKit

struct DashboardView: View {
    @EnvironmentObject var tripManager: TripManager

    @State private var mapRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 7.8731, longitude: 80.7718),
        span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
    )

    @State private var showingAddStopsSheet = false
    @State private var showingTripManagement = false
    @State private var showingCameraPage = false
    @State private var showingFirstTripScreen = false

    var body: some View {
        ZStack(alignment: .top) {
            let pins = tripManager.currentTrip?.locations ?? []

            Map(coordinateRegion: $mapRegion, annotationItems: pins) { location in
                MapAnnotation(coordinate: location.coordinate) {
                    Button(action: {
                        tripManager.selectedLocation = location // now TripLocation1
                        showingCameraPage = true
                    }) {
                        Circle()
                            .fill(Color.red)
                            .frame(width: 30, height: 30)
                    }
                }
            }
            .edgesIgnoringSafeArea(.bottom)

            VStack {
                Button(action: {
                    showingAddStopsSheet = true
                }) {
                    HStack {
                        Image(systemName: "magnifyingglass")
                        Text("Search Location")
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
                    VStack(spacing: 12) {
                        Button(action: {
                            showingCameraPage = true
                        }) {
                            Image(systemName: "camera.viewfinder")
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(radius: 3)
                        }

                        Button(action: {
                            showingTripManagement = true
                        }) {
                            Image(systemName: "plus")
                                .padding()
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(radius: 3)
                        }
                    }
                    .padding()
                }
                Spacer()
            }
        }

        // Trip Management Sheet
        .sheet(isPresented: $showingTripManagement) {
            TripManagementView()
                .environmentObject(tripManager)
        }

        // Add Stops Sheet
        .sheet(isPresented: $showingAddStopsSheet) {
            if let currentTrip = tripManager.currentTrip {
                BottomSheetAddStopsView(selectedLocations:
                    Binding(
                        get: { currentTrip.locations },
                        set: { newLocations in
                            tripManager.updateTrip(
                                id: currentTrip.id,
                                name: currentTrip.name,
                                locations: newLocations
                            )
                        }
                    )
                )
            } else {
                Text("Please create or select a trip first.")
                    .padding()
            }
        }

        // Camera View
        // Camera View Sheet or Fullscreen
        .fullScreenCover(isPresented: $showingCameraPage) {
            CameraARView()
        }

        // First-Time Trip Creation
        .fullScreenCover(isPresented: $showingFirstTripScreen) {
            NewTripView { name, locations in
                tripManager.addTrip(name: name, locations: locations)
                showingFirstTripScreen = false
            }
        }

        // Navigation bar config
        .navigationTitle(tripManager.currentTrip?.name ?? "Dashboard")
        .navigationBarTitleDisplayMode(.inline)

        .onAppear {
            if tripManager.trips.isEmpty && tripManager.currentTrip == nil {
                showingFirstTripScreen = true
            }
        }
    }
}
