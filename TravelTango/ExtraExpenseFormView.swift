import SwiftUI

struct ExtraExpenseFormView: View {
    @ObservedObject var viewModel: ExtraExpensesViewModel
    @Binding var existingExpense: ExtraExpense?

    @Environment(\.dismiss) var dismiss

    @State private var date = Date()
    @State private var expenseName = ""
    @State private var personName = ""
    @State private var amount: String = ""

    var body: some View {
        NavigationStack {
            Form {
                DatePicker("Date", selection: $date, displayedComponents: .date)
                TextField("Expense Name", text: $expenseName)
                TextField("Person Name", text: $personName)
                TextField("Amount (LKR)", text: $amount)
                    .keyboardType(.decimalPad)
            }
            .navigationTitle(existingExpense == nil ? "Add Extra Expense" : "Edit Extra Expense")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let expense = ExtraExpense(
                            id: existingExpense?.id ?? UUID(),
                            date: date,
                            expenseName: expenseName,
                            personName: personName,
                            amount: Double(amount) ?? 0
                        )

                        if existingExpense != nil {
                            viewModel.update(expense)
                        } else {
                            viewModel.add(expense)
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
                }
            }
        }
    }
}
