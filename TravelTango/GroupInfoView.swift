//
//  GroupInfoView.swift
//  TravelTango
//
//  Created by Damsara Samarakoon on 2025-04-17.
//
import SwiftUI
import PhotosUI

struct GroupInfoView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var tripManager: TripManager

    @State var group: ChatGroup
    @State private var newName: String
    @State private var photoItem: PhotosPickerItem?
    @State private var groupImage: UIImage?

    init(group: ChatGroup) {
        self._group = State(initialValue: group)
        self._newName = State(initialValue: group.name)
    }

    var body: some View {
        Form {
            // 📸 Group Image
            Section(header: Text("Group Picture")) {
                PhotosPicker(selection: $photoItem, matching: .images, photoLibrary: .shared()) {
                    if let groupImage {
                        Image(uiImage: groupImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                    } else {
                        Circle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 100, height: 100)
                            .overlay(Image(systemName: "camera")
                                .font(.title)
                                .foregroundColor(.gray))
                    }
                }
                .onChange(of: photoItem) { newItem in
                    Task {
                        if let data = try? await newItem?.loadTransferable(type: Data.self),
                           let image = UIImage(data: data) {
                            groupImage = image
                        }
                    }
                }
            }

            // ✏️ Rename Group
            Section(header: Text("Group Name")) {
                TextField("Group Name", text: $newName)
            }

            // 👥 Members
            Section(header: Text("Members")) {
                let allMembers = tripManager.getTeamMembers(by: group.memberIDs)
                ForEach(allMembers) { member in
                    HStack {
                        Image(systemName: "person.fill")
                        Text(member.name)
                    }
                }
            }

            // ✅ Save Button
            Section {
                Button("Save Changes") {
                    updateGroup()
                    dismiss()
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding()
                .background(Color(red: 9/255, green: 29/255, blue: 72/255))
                .cornerRadius(12)
            }
        }
        .navigationTitle("Group Info")
    }

    private func updateGroup() {
        // Simplified logic for now
        group.name = newName
        tripManager.updateGroup(group)
    }
}

