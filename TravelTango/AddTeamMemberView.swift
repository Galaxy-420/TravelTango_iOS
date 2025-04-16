import SwiftUI

struct AddTeamMemberView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var tripManager: TripManager

    @State private var name = ""
    @State private var email = ""

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Enter Details")) {
                    TextField("Enter new member's name", text: $name)
                        .textInputAutocapitalization(.words)

                    TextField("Enter new member's email", text: $email)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                }

                Section {
                    Button(action: {
                        tripManager.addTeamMember(name: name, email: email)
                        dismiss()
                    }) {
                        Text("Send Link to Join")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .foregroundColor(.white)
                            .background(Color(red: 9/255, green: 29/255, blue: 72/255)) // Dark Blue Theme
                            .cornerRadius(12)
                    }
                    .disabled(name.isEmpty || email.isEmpty)
                    .listRowBackground(Color.clear)
                }
            }
            .navigationTitle("Add Member")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") {
                        dismiss()
                    }
                }
            }
        }
    }
}
