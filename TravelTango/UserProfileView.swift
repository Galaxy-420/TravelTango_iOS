import SwiftUI
import PhotosUI

struct UserProfileView: View {
    @EnvironmentObject var tripManager: TripManager
    @StateObject private var userManager = UserManager.shared

    @State private var isShowingPhotoPicker = false
    @State private var selectedPhotoItem: PhotosPickerItem? = nil
    @State private var notificationsEnabled = true

    var body: some View {
        NavigationStack {
            List {
                // MARK: - Profile Section
                VStack(spacing: 12) {
                    if let image = userManager.profileImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .onTapGesture {
                                isShowingPhotoPicker = true
                            }
                    } else {
                        Circle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 100, height: 100)
                            .overlay(
                                Image(systemName: "camera")
                                    .font(.title)
                                    .foregroundColor(.gray)
                            )
                            .onTapGesture {
                                isShowingPhotoPicker = true
                            }
                    }

                    Text(userManager.name)
                        .font(.headline)
                    Text(userManager.email)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity)
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)

                // MARK: - Main Options
                Section {
                    NavigationLink(destination: EditProfileView(name: $userManager.name, email: $userManager.email)) {
                        Text("My Profile")
                    }

                    NavigationLink(destination: SettingsView()) {
                        Text("Settings")
                    }

                    Toggle("Notifications", isOn: $notificationsEnabled)

                    NavigationLink(destination: ActiveTripsView().environmentObject(tripManager)) {
                        HStack {
                            Text("Active Trips")
                            Spacer()
                            Text(tripManager.currentTrip?.name ?? "None")
                                .foregroundColor(.gray)
                        }
                    }
                }

                // MARK: - Logout
                Section {
                    Button("Log Out", role: .destructive) {
                        logout()
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .navigationTitle("Profile")
            .photosPicker(
                isPresented: $isShowingPhotoPicker,
                selection: $selectedPhotoItem,
                matching: .images
            )
            .onChange(of: selectedPhotoItem) { newItem in
                if let item = newItem {
                    loadImage(from: item)
                }
            }
            .onAppear {
                userManager.loadUserDetails()
            }
        }
    }

    private func loadImage(from item: PhotosPickerItem) {
        Task {
            if let data = try? await item.loadTransferable(type: Data.self),
               let uiImage = UIImage(data: data) {
                userManager.profileImage = uiImage
                // Optionally upload to Firebase Storage
            }
        }
    }

    private func logout() {
        userManager.logout()
        // Navigate back to LoginView here if you have navigation
        print("Logged out from Firebase")
    }
}
