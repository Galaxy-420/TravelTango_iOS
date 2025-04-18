import SwiftUI

struct GroupChatView: View {
    @EnvironmentObject var tripManager: TripManager
    @State private var showCreateGroup = false

    var body: some View {
        NavigationStack {
            VStack {
                // ➕ Create New Group Button
                Button(action: {
                    showCreateGroup = true
                }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Create New Group")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(red: 9/255, green: 29/255, blue: 72/255)) // TravelTango Blue
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .padding(.horizontal)
                }
                .padding(.top)

                // 📃 Group List
                if let groups = tripManager.currentTrip?.chatGroups, !groups.isEmpty {
                    List {
                        ForEach(groups) { group in
                            NavigationLink(destination: GroupChatRoomView(group: group)) {
                                HStack(spacing: 16) {
                                    Circle()
                                        .fill(Color.blue.opacity(0.8))
                                        .frame(width: 44, height: 44)
                                        .overlay(
                                            Text(String(group.name.prefix(1)).uppercased())
                                                .font(.headline)
                                                .foregroundColor(.white)
                                        )

                                    VStack(alignment: .leading) {
                                        Text(group.name)
                                            .fontWeight(.medium)
                                        Text("Tap to open chat")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                }
                                .padding(.vertical, 8)
                            }
                        }
                    }
                    .listStyle(.plain)
                } else {
                    Spacer()
                    Text("No groups created yet.")
                        .foregroundColor(.gray)
                        .padding()
                    Spacer()
                }
            }
            .navigationTitle("Team Chat")
            .sheet(isPresented: $showCreateGroup) {
                CreateGroupView()
                    .environmentObject(tripManager)
            }
        }
    }
}
