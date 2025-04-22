//
//  AccessControlView.swift
//  TravelTango
//
//  Created by Damsara Samarakoon on 2025-04-22.
//
import SwiftUI

struct AccessControlView: View {
    @StateObject private var viewModel = AccessControlViewModel()

    var body: some View {
        Form {
            Section(header: Text("Permission Mode")) {
                Toggle("Allow All Members to Manage Expenses", isOn: $viewModel.allowAll)
                    .toggleStyle(SwitchToggleStyle(tint: Color("DarkBlue")))
            }

            if !viewModel.allowAll {
                Section(header: Text("Select Members With Access")) {
                    ForEach(viewModel.members) { member in
                        HStack {
                            Text(member.name)
                            Spacer()
                            if member.hasExpenseAccess {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            viewModel.toggleAccess(for: member)
                        }
                    }
                }
            }
        }
        .navigationTitle("Expense Access Control")
    }
}

