import SwiftUI
import PhotosUI

struct UserProfileView: View {
    @State private var name = "John Doe"
    @State private var email = "johndoe@email.com"
    @State private var profileImage: UIImage? = nil
    @State private var isShowingPhotoPicker = false
    @State private var showEditProfile = false
    @State private var showSettings = false
    @State private var showActiveTrips = false
    @State private var notificationsEnabled = true

    var body: some View {
        NavigationStack {
            List {
                // MARK: - Profile Section
                VStack(spacing: 12) {
                    if let image = profileImage {
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

                    Text(name)
                        .font(.headline)
                    Text(email)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity)
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)

                // MARK: - Main Options
                Section {
                    NavigationLink(destination: EditProfileView(name: $name, email: $email)) {
                        Text("My Profile")
                    }

                    NavigationLink(destination: SettingsView()) {
                        Text("Settings")
                    }

                    Toggle("Notifications", isOn: $notificationsEnabled)

                    NavigationLink(destination: ActiveTripsView()) {
                        HStack {
                            Text("Active Trips")
                            Spacer()
                            Text("Kandy Trip") // you can bind to tripManager.currentTrip?.name
                                .foregroundColor(.gray)
                        }
                    }
                }

                // MARK: - Logout
                Section {
                    Button("Log Out", role: .destructive) {
                        exit(0) // Force closes the app (can replace with proper logout later)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .navigationTitle("Profile")
            .photosPicker(
                isPresented: $isShowingPhotoPicker,
                selection: .constant(nil),
                matching: .images,
                photoLibrary: .shared()
            )
        }
    }
}
