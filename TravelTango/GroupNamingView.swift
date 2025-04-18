//
//  GroupNamingView.swift
//  TravelTango
//
//  Created by Damsara Samarakoon on 2025-04-17.
//
import SwiftUI
import PhotosUI

struct GroupNamingView: View {
    @EnvironmentObject var tripManager: TripManager
    @Environment(\.dismiss) var dismiss

    let selectedMemberIDs: [UUID]

    @State private var groupName = ""
    @State private var groupImage: UIImage? = nil
    @State private var photoItem: PhotosPickerItem? = nil

    var body: some View {
        VStack(spacing: 20) {
            // 📸 Group Image Picker
            PhotosPicker(selection: $photoItem, matching: .images, photoLibrary: .shared()) {
                if let image = groupImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                } else {
                    Circle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 100, height: 100)
                        .overlay(
                            Image(systemName: "camera")
                                .font(.title)
                                .foregroundColor(.gray)
                        )
                }
            }
            .onChange(of: photoItem) { newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self),
                       let uiImage = UIImage(data: data) {
                        groupImage = uiImage
                    }
                }
            }

            // 📝 Group Name Field
            TextField("Enter group name", text: $groupName)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)

            // ✅ Create Group Button
            Button("Create Group") {
                createGroup()
                dismiss()
            }
            .disabled(groupName.trimmingCharacters(in: .whitespaces).isEmpty)
            .font(.headline)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color(red: 9/255, green: 29/255, blue: 72/255))
            .foregroundColor(.white)
            .cornerRadius(12)
            .padding(.horizontal)

            Spacer()
        }
        .padding()
        .navigationTitle("Group Info")
    }

    private func createGroup() {
        let newGroup = ChatGroup(
            name: groupName,
            memberIDs: selectedMemberIDs,
            messages: [],
            imageName: nil // you can save image to file system later
        )
        tripManager.addChatGroup(newGroup)
    }
}


