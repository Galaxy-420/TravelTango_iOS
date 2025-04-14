import SwiftUI
import MapKit

struct DashboardView: View {
    @State private var tripName: String = ""
    @State private var showingTripNamePopup: Bool = true
    @State private var mapRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 7.8731, longitude: 80.7718),
        span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
    )
    @State private var selectedLocations: [SelectedLocation] = [] // This stores pins
    @State private var showingAddStopsSheet = false
    @State private var showingNewTripPage = false
    @State private var showingCameraPage = false

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                
                // MAP showing pins
                Map(coordinateRegion: $mapRegion, annotationItems: selectedLocations, annotationContent: { location in
                    MapAnnotation(coordinate: location.coordinate) {
                        VStack {
                            Circle()
                                .fill(Color.red)
                                .frame(width: 30, height: 30)
                                .overlay(
                                    Text("\(selectedLocations.firstIndex(of: location)! + 1)")
                                        .font(.caption)
                                        .foregroundColor(.white)
                                )
                        }
                    }
                })
                .edgesIgnoringSafeArea(.all)

                VStack {
                    // Search Bar Button
                    Button(action: {
                        showingAddStopsSheet = true // ✅ Open bottom sheet when tapped
                    }) {
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                            Text("Search for a location")
                                .foregroundColor(.gray)
                            Spacer()
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 3)
                    }
                    .padding()

                    Spacer()
                }

                // Top Right Buttons (Camera + Plus)
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
                                showingNewTripPage = true
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

            // ✅ BOTTOM SHEET properly linked to Search Bar
            .sheet(isPresented: $showingAddStopsSheet) {
                NavigationStack {
                    BottomSheetAddRealLocationsView(selectedLocations: $selectedLocations)
                        .presentationDetents([.medium, .large])
                        .presentationDragIndicator(.visible)
                }
            }

            // Dummy Pages for other buttons
            .sheet(isPresented: $showingNewTripPage) {
                NewTripView()
            }
            .sheet(isPresented: $showingCameraPage) {
                CameraView()
            }

            .alert("Name Your Trip", isPresented: $showingTripNamePopup) {
                TextField("Trip Name", text: $tripName)
                Button("OK", action: {})
            } message: {
                Text("Please enter a name for your trip to start planning!")
            }
            .navigationTitle(tripName.isEmpty ? "Dashboard" : tripName)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    DashboardView()
}
