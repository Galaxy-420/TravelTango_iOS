//
//  TripExpensesView.swift
//  TravelTango
//
//  Created by Damsara Samarakoon on 2025-04-22.
//
import SwiftUI

struct TripExpensesView: View {
    @StateObject private var viewModel = TripExpensesViewModel()
    @State private var showingAdd = false
    @State private var editingExpense: TripExpense? = nil

    var body: some View {
        VStack {
            HStack {
                Text("Used: LKR \(viewModel.totalExpenses, specifier: "%.2f") / \(viewModel.collectedBudget, specifier: "%.2f")")
                    .font(.headline)
                    .padding()
                Spacer()
            }

            List {
                ForEach(viewModel.expenses) { expense in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(expense.expenseName)
                                .font(.headline)
                            Text("By \(expense.personName)")
                                .font(.subheadline)
                        }
                        Spacer()
                        Text("LKR \(expense.amount, specifier: "%.2f")")
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button("Edit") {
                            editingExpense = expense
                        }
                        .tint(.blue)

                        Button("Delete", role: .destructive) {
                            viewModel.delete(expense)
                        }
                    }
                }
            }
        }
        .navigationTitle("Trip Expenses")
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
            AddTripExpenseView(viewModel: viewModel)
        }
        .sheet(item: $editingExpense) { expense in
            AddTripExpenseView(viewModel: viewModel, existingExpense: expense)
        }
    }
}

