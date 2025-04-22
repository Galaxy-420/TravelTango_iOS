//
//  AddExtraExpenseView.swift
//  TravelTango
//
//  Created by Damsara Samarakoon on 2025-04-22.
//
import SwiftUI

struct AddExtraExpenseView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: ExtraExpensesViewModel

    @State private var date = Date()
    @State private var expenseName = ""
    @State private var personName = ""
    @State private var amount = ""

    var existingExpense: ExtraExpense? = nil

    var body: some View {
        NavigationStack {
            Form {
                DatePicker("Date", selection: $date, displayedComponents: .date)

                TextField("Expense Name", text: $expenseName)
                TextField("Person Name", text: $personName)
                TextField("Amount", text: $amount)
                    .keyboardType(.decimalPad)
            }
            .navigationTitle(existingExpense == nil ? "Add Extra Expense" : "Edit Extra Expense")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let finalAmount = Double(amount) ?? 0
                        let expense = ExtraExpense(
                            id: existingExpense?.id ?? UUID(),
                            date: date,
                            expenseName: expenseName,
                            personName: personName,
                            amount: finalAmount
                        )

                        if existingExpense != nil {
                            viewModel.update(expense)
                        } else {
                            viewModel.add(expense)
                        }

                        dismiss()
                    }
                    .disabled(expenseName.isEmpty || personName.isEmpty || amount.isEmpty)
                }

                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
        .onAppear {
            if let expense = existingExpense {
                date = expense.date
                expenseName = expense.expenseName
                personName = expense.personName
                amount = "\(expense.amount)"
            }
        }
    }
}

