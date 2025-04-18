//
//  CreateGroupView.swift
//  TravelTango
//
//  Created by Damsara Samarakoon on 2025-04-17.
//
import SwiftUI

struct CreateGroupView: View {
    @EnvironmentObject var tripManager: TripManager
    @Environment(\.dismiss) var dismiss

    @State private var selectedMemberIDs: Set<UUID> = []
    @State private var searchText = ""
    @State private var showNamingPage = false

    var filteredMembers: [TeamMember] {
        if searchText.isEmpty {
            return tripManager.currentTrip?.teamMembers ?? []
        } else {
            return (tripManager.currentTrip?.teamMembers ?? []).filter {
                $0.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    var body: some View {
        NavigationStack {
            VStack {
                // 🔍 Search Bar
                TextField("Search members...", text: $searchText)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)

                // 👥 Member List
                List {
                    ForEach(filteredMembers) { member in
                        HStack {
                            Text(member.name)
                            Spacer()
                            Button(action: {
                                toggleSelection(for: member)
                            }) {
                                Image(systemName: selectedMemberIDs.contains(member.id) ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(selectedMemberIDs.contains(member.id) ? .blue : .gray)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            toggleSelection(for: member)
                        }
                    }
                }

                // ➡️ Next Button
                Button(action: {
                    showNamingPage = true
                }) {
                    Text("Next")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(red: 9/255, green: 29/255, blue: 72/255))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .padding(.horizontal)
                        .padding(.bottom)
                }
                .disabled(selectedMemberIDs.isEmpty)
            }
            .navigationTitle("Add Members")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .navigationDestination(isPresented: $showNamingPage) {
                GroupNamingView(selectedMemberIDs: Array(selectedMemberIDs))
            }
        }
    }

    private func toggleSelection(for member: TeamMember) {
        if selectedMemberIDs.contains(member.id) {
            selectedMemberIDs.remove(member.id)
        } else {
            selectedMemberIDs.insert(member.id)
        }
    }
}


