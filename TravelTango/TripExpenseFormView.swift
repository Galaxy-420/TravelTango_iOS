//
//  TripExpenseFormView.swift
//  TravelTango
//
//  Created by Nimeshika Mandakini on 2025-04-25.
//
import SwiftUI

struct TripExpenseFormView: View {
    @ObservedObject var viewModel: TripExpensesViewModel
    @Binding var existingExpense: TripExpense?

    @Environment(\.dismiss) var dismiss

    @State private var date = Date()
    @State private var expenseName = ""
    @State private var personName = ""
    @State private var amount = ""
    @State private var category = ""

    var body: some View {
        NavigationStack {
            Form {
                DatePicker("Date", selection: $date, displayedComponents: .date)

                TextField("Expense Name", text: $expenseName)
                TextField("Person Name", text: $personName)
                TextField("Amount (LKR)", text: $amount)
                    .keyboardType(.decimalPad)
                TextField("Category", text: $category)
            }
            .navigationTitle(existingExpense == nil ? "Add Expense" : "Edit Expense")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let newExpense = TripExpense(
                            id: existingExpense?.id ?? UUID(),
                            date: date,
                            expenseName: expenseName,
                            personName: personName,
                            amount: Double(amount) ?? 0,
                            category: category
                        )

                        if existingExpense != nil {
                            viewModel.update(newExpense)
                        } else {
                            viewModel.add(newExpense)
                        }
                        dismiss()
                    }
                }

                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                if let expense = existingExpense {
                    date = expense.date
                    expenseName = expense.expenseName
                    personName = expense.personName
                    amount = String(format: "%.2f", expense.amount)
                    category = expense.category
                }
            }
        }
    }
}

