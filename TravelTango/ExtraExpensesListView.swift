//
//  ExtraExpensesListView.swift
//  TravelTango
//
//  Created by Nimeshika Mandakini on 2025-04-25.
//
import SwiftUI

struct ExtraExpensesListView: View {
    @StateObject private var viewModel = ExtraExpensesViewModel()
    @State private var showForm = false
    @State private var selectedExpense: ExtraExpense?

    var body: some View {
        VStack(spacing: 16) {
            Text("Extra Expenses")
                .font(.title.bold())
                .padding(.top)

            HStack {
                Text("Total Extra Expenses:")
                    .font(.headline)
                Spacer()
                Text("LKR \(String(format: "%.2f", viewModel.totalAmount))")
                    .font(.title3.bold())
                    .foregroundColor(.red)
            }
            .padding()
            .background(Color.red.opacity(0.1))
            .cornerRadius(10)
            .padding(.horizontal)

            List {
                ForEach(viewModel.expenses) { expense in
                    VStack(alignment: .leading, spacing: 4) {
                        Text("\(expense.expenseName) - LKR \(expense.amount, specifier: "%.2f")")
                            .font(.headline)
                        Text("By \(expense.personName)")
                        Text("Date: \(expense.date.formatted(date: .abbreviated, time: .omitted))")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .swipeActions {
                        Button(role: .destructive) {
                            viewModel.delete(expense)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }

                        Button {
                            selectedExpense = expense
                            showForm = true
                        } label: {
                            Label("Edit", systemImage: "pencil")
                        }
                        .tint(.orange)
                    }
                }
            }

            Button("Add New") {
                selectedExpense = nil
                showForm = true
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.horizontal)
        }
        .sheet(isPresented: $showForm) {
            ExtraExpenseFormView(viewModel: viewModel, existingExpense: $selectedExpense)
        }
    }
}

