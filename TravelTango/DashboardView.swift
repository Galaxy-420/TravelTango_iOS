import SwiftUI
import MapKit
import GoogleMaps

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
    @State private var showingVRView = false
    @State private var selectedVRLocation: TripLocation1? = nil
    @State private var isLoadingVR = true

    var body: some View {
        ZStack(alignment: .top) {
            let pins = tripManager.currentTrip?.locations ?? []

            Map(coordinateRegion: $mapRegion, annotationItems: pins) { location in
                MapAnnotation(coordinate: location.coordinate) {
                    Button(action: {
                        selectedVRLocation = location
                        showingVRView = true
                        isLoadingVR = true // Reset loading state
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
        .sheet(isPresented: $showingAddStopsSheet, onDismiss: {
            // Save updates after dismissing Add Stops
            if let currentTrip = tripManager.currentTrip {
                tripManager.updateTrip(
                    id: currentTrip.id,
                    name: currentTrip.name,
                    locations: currentTrip.locations
                )
            }
        }) {
            if let currentTrip = tripManager.currentTrip {
                BottomSheetAddStopsView(selectedLocations:
                    Binding(
                        get: { currentTrip.locations },
                        set: { newLocations in
                            if let index = tripManager.trips.firstIndex(where: { $0.id == currentTrip.id }) {
                                tripManager.trips[index].locations = newLocations
                                tripManager.currentTrip = tripManager.trips[index]
                            }
                        }
                    )
                )
            } else {
                Text("Please create or select a trip first.")
                    .padding()
            }
        }

        // Camera View Fullscreen
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

        // VR View when tapping red pin
        .sheet(isPresented: $showingVRView) {
            ZStack {
                if let location = selectedVRLocation {
                    GooglePanoramaView(coordinate: CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude))
                }

                if isLoadingVR {
                    VStack {
                        ProgressView()
                        Text("Loading 360° View...")
                            .foregroundColor(.gray)
                            .padding(.top, 8)
                    }
                }
            }
            .onAppear {
                isLoadingVR = false
            }
        }

        // Navigation bar config
        .navigationTitle(tripManager.currentTrip?.name ?? "Dashboard")
        .navigationBarTitleDisplayMode(.inline)

        // Handle first time opening if no trips
        .onAppear {
            if tripManager.trips.isEmpty && tripManager.currentTrip == nil {
                showingFirstTripScreen = true
            }
        }
    }
}

struct GooglePanoramaView: UIViewRepresentable {
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
