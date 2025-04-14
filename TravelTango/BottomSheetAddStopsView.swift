import SwiftUI
import MapKit

struct BottomSheetAddStopsView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var selectedLocations: [SelectedLocation]

    init(selectedLocations: Binding<[SelectedLocation]>) {
        self._selectedLocations = selectedLocations
    }

    @State private var searchText = ""
    @State private var searchResults: [MKLocalSearchCompletion] = []

    private var searchCompleter = MKLocalSearchCompleter()
    @State private var selectedStops: [SelectedLocation] = []

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
            TextField("Where to?", text: $searchText)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
                .onChange(of: searchText) { newValue in
                    searchCompleter.queryFragment = newValue
                }

            // Search Results
            if !searchResults.isEmpty {
                List {
                    ForEach(searchResults, id: \.self) { result in
                        Button(action: {
                            selectPlace(result)
                        }) {
                            VStack(alignment: .leading) {
                                Text(result.title)
                                    .font(.headline)
                                if !result.subtitle.isEmpty {
                                    Text(result.subtitle)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                    }
                }
                .listStyle(PlainListStyle())
            }

            // Selected Locations
            if !selectedStops.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(selectedStops.indices, id: \.self) { index in
                        HStack {
                            Text("\(index + 1). \(selectedStops[index].name)")
                                .font(.subheadline)
                            Spacer()
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.top, 10)
            }

            Spacer()

            // Done Button
            Button(action: {
                selectedLocations.append(contentsOf: selectedStops)
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
        .onAppear {
            configureCompleter()
        }
    }

    // MARK: - Helpers

    private func configureCompleter() {
        searchCompleter.delegate = SearchCompleterDelegateSimple(update: { results in
            self.searchResults = results
        })
    }

    private func selectPlace(_ completion: MKLocalSearchCompletion) {
        let request = MKLocalSearch.Request(completion: completion)
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            guard let mapItem = response?.mapItems.first else { return }

            let location = SelectedLocation(
                name: mapItem.name ?? completion.title,
                coordinate: mapItem.placemark.coordinate
            )

            selectedStops.append(location)
            searchText = ""
            searchResults = []
        }
    }
}

// MARK: - Simplified SearchCompleterDelegate
class SearchCompleterDelegateSimple: NSObject, MKLocalSearchCompleterDelegate {
    var update: ([MKLocalSearchCompletion]) -> Void

    init(update: @escaping ([MKLocalSearchCompletion]) -> Void) {
        self.update = update
    }

    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        update(completer.results)
    }
}

#Preview {
    NavigationStack {
        BottomSheetAddStopsView(selectedLocations: .constant([]))
    }
}
