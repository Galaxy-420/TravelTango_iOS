import SwiftUI

struct AddTripBudgetView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: TripBudgetViewModel

    @State private var date: Date
    @State private var budgetName: String
    @State private var personName: String
    @State private var amount: String
    @State private var selectedCategory: String

    var existingBudget: TripBudget?

    let categories = [
        "Accommodation", "Transport", "Food", "Tickets",
        "Fuel", "Entrance Fees", "Shopping", "Gifts",
        "Miscellaneous", "Entertainment", "Other"
    ]

    init(viewModel: TripBudgetViewModel, existingBudget: TripBudget? = nil) {
        self.viewModel = viewModel
        self.existingBudget = existingBudget

        if let budget = existingBudget {
            _date = State(initialValue: budget.date)
            _budgetName = State(initialValue: budget.budgetName)
            _personName = State(initialValue: budget.personName)
            _amount = State(initialValue: String(budget.amount))
            _selectedCategory = State(initialValue: budget.category)
        } else {
            _date = State(initialValue: Date())
            _budgetName = State(initialValue: "")
            _personName = State(initialValue: "")
            _amount = State(initialValue: "")
            _selectedCategory = State(initialValue: "")
        }
    }

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Budget Details")) {
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
            }
            .navigationTitle(existingBudget == nil ? "Add Trip Budget" : "Edit Trip Budget")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(action: {
                        guard let finalAmount = Double(amount) else {
                            return
                        }

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
                    }) {
                        Text("Save")
                    }
                    .disabled(budgetName.isEmpty || personName.isEmpty || amount.isEmpty || selectedCategory.isEmpty)
                }

                ToolbarItem(placement: .cancellationAction) {
                    Button(action: {
                        dismiss()
                    }) {
                        Text("Cancel")
                    }
                }
            }

        }
    }
}
