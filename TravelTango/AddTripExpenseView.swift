//
//  AddTripExpenseView.swift
//  TravelTango
//
//  Created by Damsara Samarakoon on 2025-04-22.
//
import SwiftUI

struct AddTripExpenseView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: TripExpensesViewModel

    @State private var date = Date()
    @State private var expenseName = ""
    @State private var personName = ""
    @State private var amount = ""
    @State private var selectedCategory = ""
    
    var existingExpense: TripExpense? = nil

    let categories = [
        "Food", "Transport", "Accommodation", "Activity",
        "Tickets", "Fuel", "Shopping", "Medical",
        "Miscellaneous", "Other"
    ]

    var body: some View {
        NavigationStack {
            Form {
                DatePicker("Date", selection: $date, displayedComponents: .date)

                TextField("Expense Name", text: $expenseName)
                TextField("Person Name", text: $personName)
                TextField("Amount", text: $amount)
                    .keyboardType(.decimalPad)

                Picker("Category", selection: $selectedCategory) {
                    ForEach(categories, id: \.self) { category in
                        Text(category)
                    }
                }
            }
            .navigationTitle(existingExpense == nil ? "Add Trip Expense" : "Edit Trip Expense")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let finalAmount = Double(amount) ?? 0
                        let expense = TripExpense(
                            id: existingExpense?.id ?? UUID(),
                            date: date,
                            expenseName: expenseName,
                            personName: personName,
                            amount: finalAmount,
                            category: selectedCategory
                        )

                        if existingExpense != nil {
                            viewModel.update(expense)
                        } else {
                            viewModel.add(expense)
                        }

                        dismiss()
                    }
                    .disabled(expenseName.isEmpty || personName.isEmpty || amount.isEmpty || selectedCategory.isEmpty)
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
                selectedCategory = expense.category
            }
        }
    }
}

