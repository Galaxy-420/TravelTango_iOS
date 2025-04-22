//
//  ExtraExpensesView.swift
//  TravelTango
//
//  Created by Damsara Samarakoon on 2025-04-22.
//
import SwiftUI

struct ExtraExpensesView: View {
    @StateObject private var viewModel = ExtraExpensesViewModel()
    @State private var showingAdd = false
    @State private var editingExpense: ExtraExpense? = nil

    var body: some View {
        VStack {
            HStack {
                Text("Total Extra: LKR \(viewModel.totalExtra, specifier: "%.2f")")
                    .font(.headline)
                    .padding()
                Spacer()
            }

            List {
                ForEach(viewModel.extraExpenses) { expense in
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
        .navigationTitle("Extra Expenses")
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
            AddExtraExpenseView(viewModel: viewModel)
        }
        .sheet(item: $editingExpense) { expense in
            AddExtraExpenseView(viewModel: viewModel, existingExpense: expense)
        }
    }
}

