import SwiftUI

struct EditProfileView: View {
    @Binding var name: String
    @Binding var email: String
    @State private var mobile = ""
    @State private var location = ""
    
    @Environment(\.dismiss) var dismiss // ✅ Allows us to close the screen

    var body: some View {
        Form {
            Section(header: Text("Personal Info")) {
                TextField("Full Name", text: $name)
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                TextField("Mobile", text: $mobile)
                    .keyboardType(.phonePad)
                TextField("Location", text: $location)
            }
        }
        .navigationTitle("Edit Profile")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    // ✅ Your save logic here
                    print("Saved profile:")
                    print("Name: \(name), Email: \(email), Mobile: \(mobile), Location: \(location)")
                    dismiss() // ✅ Closes the screen
                }
                .fontWeight(.semibold)
            }
        }
    }
}
