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
        NavigationStack {
            ZStack(alignment: .top) {
                let pins = tripManager.currentTrip?.locations ?? []

                Map(coordinateRegion: $mapRegion, annotationItems: pins) { location in
                    MapAnnotation(coordinate: location.coordinate) {
                        Circle()
                            .fill(Color.red)
                            .frame(width: 30, height: 30)
                    }
                }
                .edgesIgnoringSafeArea(.all)

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

            // ➕ Trip Manager Sheet
            .sheet(isPresented: $showingTripManagement) {
                TripManagementView()
                    .environmentObject(tripManager)
            }

            // 📍 Add Stops Bottom Sheet
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

            // 🎥 AR Camera Placeholder
            .navigationDestination(isPresented: $showingCameraPage) {
                Text("AR Camera Page (coming soon)")
            }

            // 🧭 Navigate to Trip Creation if first time
            .fullScreenCover(isPresented: $showingFirstTripScreen) {
                NewTripView { name, locations in
                    tripManager.addTrip(name: name, locations: locations)
                    showingFirstTripScreen = false
                }
            }

            // Navigation title reflects selected trip
            .navigationTitle(tripManager.currentTrip?.name ?? "Dashboard")
            .navigationBarTitleDisplayMode(.inline)

            // Auto-launch trip creator for first-time users
            .onAppear {
                if tripManager.trips.isEmpty && tripManager.currentTrip == nil {
                    showingFirstTripScreen = true
                }
            }
        }
    }
}
