import SwiftUI

struct AddTripExpenseFormView: View {
    @ObservedObject var viewModel: TripExpensesViewModel
    @Binding var existingExpense: TripExpense?

    @Environment(\.dismiss) private var dismiss

    @State private var date = Date()
    @State private var expenseName = ""
    @State private var personName = ""
    @State private var amount = ""
    @State private var category = ""

    let categories = ["Accommodation", "Transport", "Food", "Tickets", "Fuel", "Shopping", "Gifts", "Entertainment", "Other"]

    var body: some View {
        Form {
            Section(header: Text("Expense Details")) {
                DatePicker("Date", selection: $date, displayedComponents: .date)
                TextField("Expense Name", text: $expenseName)
                TextField("Person Name", text: $personName)
                TextField("Amount (LKR)", text: $amount)
                    .keyboardType(.decimalPad)
                Picker("Category", selection: $category) {
                    ForEach(categories, id: \.self) {
                        Text($0)
                    }
                }
            }
        }
        .navigationTitle(existingExpense == nil ? "Add Expense" : "Edit Expense")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    let newExpense = TripExpense(
                        id: existingExpense?.id ?? UUID(),
                        date: date,
                        expenseName: expenseName,
                        personName: personName,
                        amount: Double(amount) ?? 0,
                        category: category
                    )

                    if existingExpense != nil {
                        viewModel.update(newExpense)
                    } else {
                        viewModel.add(newExpense)
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
            if let e = existingExpense {
                date = e.date
                expenseName = e.expenseName
                personName = e.personName
                amount = String(format: "%.2f", e.amount)
                category = e.category
            }
        }
    }
}
