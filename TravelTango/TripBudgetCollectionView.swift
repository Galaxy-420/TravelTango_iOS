//
//  TripBudgetCollectionView.swift
//  TravelTango
//
//  Created by Damsara Samarakoon on 2025-04-22.
//
import SwiftUI

struct TripBudgetCollectionView: View {
    @StateObject private var viewModel = TripBudgetViewModel()
    @State private var showingAdd = false
    @State private var editingBudget: TripBudget? = nil

    var body: some View {
        VStack {
            HStack {
                Text("Total Collected: LKR \(viewModel.totalBudget, specifier: "%.2f")")
                    .font(.headline)
                    .padding(.leading)
                Spacer()
            }

            List {
                ForEach(viewModel.budgets) { budget in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(budget.personName)
                                .font(.headline)
                            Text("LKR \(budget.amount, specifier: "%.2f")")
                                .font(.subheadline)
                        }
                        Spacer()
                        Text(budget.category)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button("Edit") {
                            editingBudget = budget
                        }
                        .tint(.blue)

                        Button("Delete", role: .destructive) {
                            viewModel.delete(budget)
                        }
                    }
                }
            }

            Spacer()
        }
        .navigationTitle("Trip Budget Collection")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    showingAdd = true
                }) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(Color("DarkBlue"))
                        .font(.title2)
                }
            }
        }
        .sheet(isPresented: $showingAdd) {
            AddTripBudgetView(viewModel: viewModel)
        }
        .sheet(item: $editingBudget) { budget in
            AddTripBudgetView(viewModel: viewModel, existingBudget: budget)
        }
    }
}

