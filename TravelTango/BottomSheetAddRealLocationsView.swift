//
//  BottomSheetAddRealLocationsView.swift
//  TravelTango
//
//  Created by Damsara Samarakoon on 2025-04-14.
//
import SwiftUI
import MapKit

struct BottomSheetAddRealLocationsView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var selectedLocations: [SelectedLocation]

    @State private var searchText = ""
    @State private var searchResults: [MKMapItem] = []

    init(selectedLocations: Binding<[SelectedLocation]>) {
        self._selectedLocations = selectedLocations
    }

    var body: some View {
        VStack(spacing: 16) {
            // Drag Bar
            RoundedRectangle(cornerRadius: 2)
                .fill(Color.gray.opacity(0.5))
                .frame(width: 40, height: 5)
                .padding(.top, 10)

            // Title
            Text("Plan Your Trip")
                .font(.title2)
                .fontWeight(.semibold)

            // Search Bar
            TextField("Search for a place", text: $searchText)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
                .onSubmit {
                    performSearch()
                }
                .onChange(of: searchText) { newValue in
                    // Optional: live search while typing
                    performSearch()
                }

            // Search Results
            if !searchResults.isEmpty {
                List {
                    ForEach(searchResults, id: \.self) { mapItem in
                        Button(action: {
                            addSelectedLocation(mapItem)
                        }) {
                            VStack(alignment: .leading) {
                                Text(mapItem.name ?? "Unknown Place")
                                    .font(.headline)
                                if let address = mapItem.placemark.title {
                                    Text(address)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                    }
                }
                .listStyle(PlainListStyle())
            }

            Spacer()

            // Done Button
            Button(action: {
                dismiss()
            }) {
                Text("Done")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(12)
                    .padding(.horizontal)
                    .padding(.bottom, 20)
            }
        }
        .background(Color(UIColor.systemGroupedBackground))
        .cornerRadius(25)
        .ignoresSafeArea()
    }

    // MARK: - Helpers

    private func performSearch() {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        request.resultTypes = [.address, .pointOfInterest]

        let search = MKLocalSearch(request: request)
        search.start { response, error in
            guard let response = response else {
                self.searchResults = []
                return
            }
            self.searchResults = response.mapItems
        }
    }

    private func addSelectedLocation(_ mapItem: MKMapItem) {
        let location = SelectedLocation(
            name: mapItem.name ?? "Unknown Place",
            coordinate: mapItem.placemark.coordinate
        )
        selectedLocations.append(location)
        searchText = ""
        searchResults = []
    }
}

