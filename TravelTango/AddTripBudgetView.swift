//
//  AddTripBudgetView.swift
//  TravelTango
//
//  Created by Damsara Samarakoon on 2025-04-22.
//
import SwiftUI

struct AddTripBudgetView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: TripBudgetViewModel

    @State private var date = Date()
    @State private var budgetName = ""
    @State private var personName = ""
    @State private var amount = ""
    @State private var selectedCategory = ""
    
    var existingBudget: TripBudget? = nil

    let categories = [
        "Accommodation", "Transport", "Food", "Tickets",
        "Fuel", "Entrance Fees", "Shopping", "Gifts",
        "Miscellaneous", "Entertainment", "Other"
    ]

    var body: some View {
        NavigationStack {
            Form {
                DatePicker("Date", selection: $date, displayedComponents: .date)

                TextField("Budget Name", text: $budgetName)
                TextField("Person Name", text: $personName)
                TextField("Amount", text: $amount)
                    .keyboardType(.decimalPad)

                Picker("Category", selection: $selectedCategory) {
                    ForEach(categories, id: \.self) { category in
                        Text(category)
                    }
                }
            }
            .navigationTitle(existingBudget == nil ? "Add Trip Budget" : "Edit Trip Budget")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let finalAmount = Double(amount) ?? 0
                        let budget = TripBudget(
                            id: existingBudget?.id ?? UUID(),
                            date: date,
                            budgetName: budgetName,
                            personName: personName,
                            amount: finalAmount,
                            category: selectedCategory
                        )

                        if existingBudget != nil {
                            viewModel.update(budget)
                        } else {
                            viewModel.add(budget)
                        }

                        dismiss()
                    }
                    .disabled(budgetName.isEmpty || personName.isEmpty || amount.isEmpty || selectedCategory.isEmpty)
                }

                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
        .onAppear {
            if let budget = existingBudget {
                date = budget.date
                budgetName = budget.budgetName
                personName = budget.personName
                amount = "\(budget.amount)"
                selectedCategory = budget.category
            }
        }
    }
}


