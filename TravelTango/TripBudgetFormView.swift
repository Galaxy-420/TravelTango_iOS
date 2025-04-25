//
//  TripBudgetFormView.swift
//  TravelTango
//
//  Created by Nimeshika Mandakini on 2025-04-25.
//
//
//  TripBudgetFormView.swift
//  TravelTango
//
//  Created by Nimeshika Mandakini on 2025-04-25.
//

import SwiftUI

struct TripBudgetFormView: View {
    @ObservedObject var viewModel: TripBudgetViewModel
    @Binding var existingBudget: TripBudget?

    @Environment(\.dismiss) private var dismiss

    @State private var date = Date()
    @State private var budgetName = ""
    @State private var personName = ""
    @State private var amount = ""
    @State private var category = ""

    @State private var showAlert = false
    @State private var alertMessage = ""

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Budget Details")) {
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                    TextField("Budget Name", text: $budgetName)
                    TextField("Person Name", text: $personName)
                    TextField("Amount (LKR)", text: $amount)
                        .keyboardType(.decimalPad)
                    TextField("Category", text: $category)
                }
            }
            .navigationTitle(existingBudget == nil ? "Add Budget" : "Edit Budget")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveBudget()
                    }
                }

                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .onAppear(perform: loadExistingData)
            .alert("Invalid Amount", isPresented: $showAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(alertMessage)
            }
        }
    }

    private func loadExistingData() {
        if let budget = existingBudget {
            date = budget.date
            budgetName = budget.budgetName
            personName = budget.personName
            amount = String(format: "%.2f", budget.amount)
            category = budget.category
        }
    }

    private func saveBudget() {
        guard let amountValue = Double(amount), amountValue >= 0 else {
            alertMessage = "Please enter a valid non-negative amount."
            showAlert = true
            return
        }

        let newBudget = TripBudget(
            id: existingBudget?.id ?? UUID(),
            date: date,
            budgetName: budgetName,
            personName: personName,
            amount: amountValue,
            category: category
        )

        if existingBudget != nil {
            viewModel.update(newBudget)
        } else {
            viewModel.add(newBudget)
        }

        dismiss()
    }
}


