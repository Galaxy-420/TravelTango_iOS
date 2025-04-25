//
//  AddExtraExpenseView.swift
//  TravelTango
//
//  Created by Nimeshika Mandakini on 2025-04-25.
//
import SwiftUI

struct AddExtraExpenseView: View {
    @ObservedObject var viewModel: ExtraExpensesViewModel
    @Binding var existingExpense: ExtraExpense?

    @Environment(\.dismiss) private var dismiss

    @State private var date = Date()
    @State private var expenseName = ""
    @State private var personName = ""
    @State private var amount = ""

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Extra Expense Details")) {
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                    TextField("Expense Name", text: $expenseName)
                    TextField("Person Name", text: $personName)
                    TextField("Amount (LKR)", text: $amount)
                        .keyboardType(.decimalPad)
                }
            }
            .navigationTitle(existingExpense == nil ? "Add Extra Expense" : "Edit Extra Expense")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let expense = ExtraExpense(
                            id: existingExpense?.id ?? UUID(),
                            date: date,
                            expenseName: expenseName,
                            personName: personName,
                            amount: Double(amount) ?? 0.0
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
            .onAppear {
                if let e = existingExpense {
                    date = e.date
                    expenseName = e.expenseName
                    personName = e.personName
                    amount = String(format: "%.2f", e.amount)
                }
            }
        }
    }
}

