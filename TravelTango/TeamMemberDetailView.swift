import SwiftUI

struct TeamMemberDetailView: View {
    let member: TeamMember
    @Environment(\.dismiss) var dismiss

    @State private var showEditSheet = false

    var body: some View {
        Form {
            // 🔹 Member Info Section
            Section(header: Text("Member Info")) {
                Text("Name: \(member.name)")
                Text("Email: \(member.email)")
                Text("Joined: \(member.joinedDate.formatted(date: .abbreviated, time: .omitted))")

                if let phone = member.phone {
                    Text("Phone: \(phone)")
                }
            }

            // 🔹 Actions Section
            Section(header: Text("Actions")) {
                Button(role: .destructive) {
                    // TODO: Handle deletion via tripManager
                    print("Delete \(member.name)")
                    dismiss()
                } label: {
                    Label("Delete Member", systemImage: "trash")
                }

                Button {
                    showEditSheet = true
                } label: {
                    Label("Edit Member", systemImage: "pencil")
                }
            }
        }
        .navigationTitle("Member Details")
        .sheet(isPresented: $showEditSheet) {
            // TODO: Create EditTeamMemberView if needed
            Text("Edit view coming soon")
                .presentationDetents([.medium])
        }
    }
}
