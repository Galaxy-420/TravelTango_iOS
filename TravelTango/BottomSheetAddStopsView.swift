import SwiftUI
import MapKit

struct BottomSheetAddStopsView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var selectedLocations: [TripLocation1]

    @State private var searchText = ""
    @State private var searchResults: [MKLocalSearchCompletion] = []
    @State private var selectedStops: [TripLocation1] = []

    @State private var searchCompleter = MKLocalSearchCompleter()
    @StateObject private var completerDelegate = SearchCompleterDelegateSimple()

    var body: some View {
        VStack(spacing: 16) {
            RoundedRectangle(cornerRadius: 2)
                .fill(Color.gray.opacity(0.5))
                .frame(width: 40, height: 5)
                .padding(.top, 10)

            Text("Plan Your Trip")
                .font(.title2)
                .fontWeight(.semibold)

            TextField("Where to?", text: $searchText)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal)
                .onChange(of: searchText) { newValue in
                    searchCompleter.queryFragment = newValue
                }

            if !searchResults.isEmpty {
                List {
                    ForEach(searchResults, id: \.self) { result in
                        Button {
                            selectPlace(result)
                        } label: {
                            VStack(alignment: .leading) {
                                Text(result.title).font(.headline)
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

            if !selectedStops.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(selectedStops.indices, id: \.self) { index in
                        Text("\(index + 1). \(selectedStops[index].name)")
                            .font(.subheadline)
                            .padding(.horizontal)
                    }
                }
                .padding(.top)
            }

            Spacer()

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
            completerDelegate.onUpdate = { results in
                self.searchResults = results
            }
            searchCompleter.delegate = completerDelegate
        }
    }

    private func selectPlace(_ completion: MKLocalSearchCompletion) {
        let request = MKLocalSearch.Request(completion: completion)
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            guard let mapItem = response?.mapItems.first else { return }

            let selected = TripLocation1(
                name: mapItem.name ?? completion.title,
                latitude: mapItem.placemark.coordinate.latitude,
                longitude: mapItem.placemark.coordinate.longitude
            )

            selectedStops.append(selected)
            searchText = ""
            searchResults = []
        }
    }
}

// MARK: - Search Delegate
class SearchCompleterDelegateSimple: NSObject, ObservableObject, MKLocalSearchCompleterDelegate {
    var onUpdate: (([MKLocalSearchCompletion]) -> Void)?

    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        onUpdate?(completer.results)
    }
}
