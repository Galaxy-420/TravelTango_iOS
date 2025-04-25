//
//  ModelSearchView.swift
//  TravelTango
//
//  Created by Nimeshika Mandakini on 2025-04-25.
//
import SwiftUI

struct ModelSearchView: View {
    @Binding var models: [ARCampingModel]
    @Environment(\.dismiss) var dismiss
    @State private var newName: String = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Add Custom 3D Object")) {
                    TextField("Object name", text: $newName)
                    Button("Add") {
                        let newModel = ARCampingModel(
                            name: newName,
                            imageName: "cube.fill",
                            modelName: newName.replacingOccurrences(of: " ", with: "_").lowercased()
                        )
                        models.append(newModel)
                        dismiss()
                    }.disabled(newName.isEmpty)
                }
            }
            .navigationTitle("Search Models")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }
}

