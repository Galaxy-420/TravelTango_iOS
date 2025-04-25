import SwiftUI

struct AddTripExpenseView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: TripExpensesViewModel

    @Binding var existingExpense: TripExpense?

    @State private var expenseName: String = ""
    @State private var personName: String = ""
    @State private var amount: String = ""
    @State private var date: Date = Date()
    @State private var category: String = "Miscellaneous"  // ✅ default value

    let categories = [
        "Accommodation", "Transport", "Food", "Tickets",
        "Fuel", "Entrance Fees", "Shopping", "Gifts",
        "Miscellaneous", "Entertainment", "Other"
    ]

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Expense Details")) {
                    TextField("Expense Name", text: $expenseName)
                    TextField("Person Name", text: $personName)
                    TextField("Amount (LKR)", text: $amount)
                        .keyboardType(.decimalPad)
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                    Picker("Category", selection: $category) {
                        ForEach(categories, id: \.self) { category in
                            Text(category)
                        }
                    }
                }
            }
            .navigationTitle(existingExpense == nil ? "Add Expense" : "Edit Expense")
            .navigationBarTitleDisplayMode(.inline)
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
                            viewModel.update(expense)   // ✅ your method is likely named `update`
                        } else {
                            viewModel.add(expense)      // ✅ your method is likely named `add`
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
                    amount = String(format: "%.2f", expense.amount)
                    date = expense.date
                    category = expense.category
                }
            }
        }
    }
}

