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
                        let newBudget = TripBudget(
                            id: existingBudget?.id ?? UUID(),
                            date: date,
                            budgetName: budgetName,
                            personName: personName,
                            amount: Double(amount) ?? 0,
                            category: category
                        )

                        if existingBudget != nil {
                            viewModel.update(newBudget)
                        } else {
                            viewModel.add(newBudget)
                        }

                        dismiss()
                    }
                    .disabled(budgetName.isEmpty || personName.isEmpty || amount.isEmpty || category.isEmpty)
                }

                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                if let b = existingBudget {
                    date = b.date
                    budgetName = b.budgetName
                    personName = b.personName
                    amount = String(format: "%.2f", b.amount)
                    category = b.category
                }
            }
        }
    }
}
