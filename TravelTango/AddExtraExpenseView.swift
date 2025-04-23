import SwiftUI

struct AddExtraExpenseView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: ExtraExpensesViewModel

    @State private var date: Date
    @State private var expenseName: String
    @State private var personName: String
    @State private var amount: String

    var existingExpense: ExtraExpense?

    init(viewModel: ExtraExpensesViewModel, existingExpense: ExtraExpense? = nil) {
        self.viewModel = viewModel
        self.existingExpense = existingExpense

        if let expense = existingExpense {
            _date = State(initialValue: expense.date)
            _expenseName = State(initialValue: expense.expenseName)
            _personName = State(initialValue: expense.personName)
            _amount = State(initialValue: String(expense.amount))
        } else {
            _date = State(initialValue: Date())
            _expenseName = State(initialValue: "")
            _personName = State(initialValue: "")
            _amount = State(initialValue: "")
        }
    }

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Extra Expense Details")) {
                    DatePicker("Date", selection: $date, displayedComponents: .date)

                    TextField("Expense Name", text: $expenseName)
                    TextField("Person Name", text: $personName)
                    TextField("Amount", text: $amount)
                        .keyboardType(.decimalPad)
                }
            }
            .navigationTitle(existingExpense == nil ? "Add Extra Expense" : "Edit Extra Expense")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(action: {
                        guard let finalAmount = Double(amount) else { return }

                        let newExpense = ExtraExpense(
                            id: existingExpense?.id ?? UUID(),
                            date: date,
                            expenseName: expenseName,
                            personName: personName,
                            amount: finalAmount
                        )

                        if existingExpense != nil {
                            viewModel.update(newExpense)
                        } else {
                            viewModel.add(newExpense)
                        }

                        dismiss()
                    }) {
                        Text("Save")
                    }
                    .disabled(expenseName.isEmpty || personName.isEmpty || amount.isEmpty)
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
