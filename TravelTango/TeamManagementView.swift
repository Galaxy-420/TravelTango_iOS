import SwiftUI

struct TeamManagementView: View {
    @EnvironmentObject var tripManager: TripManager
    @State private var showAddMember = false

    var body: some View {
        NavigationStack {
            VStack {
                Button("Add New Member") {
                    showAddMember = true
                }
                .padding()
                .buttonStyle(.borderedProminent)

                List {
                    ForEach(tripManager.currentTrip?.teamMembers ?? []) { member in
                        NavigationLink(destination: TeamMemberDetailView(member: member)) {
                            VStack(alignment: .leading) {
                                Text(member.name)
                                    .fontWeight(.semibold)
                                Text(member.joinedDate.formatted(date: .abbreviated, time: .omitted))
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Team Management")
            .sheet(isPresented: $showAddMember) {
                AddTeamMemberView()
            }
        }
    }
}
