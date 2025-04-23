import SwiftUI

struct AddTripExpenseView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: TripExpensesViewModel

    @State private var expenseName: String = ""
    @State private var personName: String = ""
    @State private var amount: String = ""
    @State private var date: Date = Date()
    @State private var category: String = ""

    var existingExpense: TripExpense?

    let categories = [
        "Accommodation", "Transport", "Food", "Tickets",
        "Fuel", "Entrance Fees", "Shopping", "Gifts",
        "Miscellaneous", "Entertainment", "Other"
    ]

    var body: some View {
        NavigationStack {
            Form {
                TextField("Expense Name", text: $expenseName)
                TextField("Person Name", text: $personName)
                TextField("Amount", text: $amount)
                    .keyboardType(.decimalPad)
                DatePicker("Date", selection: $date, displayedComponents: .date)
                Picker("Category", selection: $category) {
                    ForEach(categories, id: \.self) { category in
                        Text(category)
                    }
                }
            }
            .navigationTitle(existingExpense == nil ? "Add Expense" : "Edit Expense")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let expenseAmount = Double(amount) ?? 0.0
                        let expense = TripExpense(
                            id: existingExpense?.id ?? UUID(),
                            date: date,
                            expenseName: expenseName,
                            personName: personName,
                            amount: expenseAmount,
                            category: category
                        )

                        if existingExpense != nil {
                            viewModel.updateExpense(expense)
                        } else {
                            viewModel.addExpense(expense)
                        }

                        dismiss()
                    }
                    .disabled(expenseName.isEmpty || personName.isEmpty || amount.isEmpty || category.isEmpty)
                }

                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                if let expense = existingExpense {
                    expenseName = expense.expenseName
                    personName = expense.personName
                    amount = "\(expense.amount)"
                    date = expense.date
                    category = expense.category
                }
            }
        }
    }
}
