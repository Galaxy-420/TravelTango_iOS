import SwiftUI
import FirebaseFirestore
import FirebaseAuth

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

    private let db = Firestore.firestore()

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
                    saveExpense()
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

    private func saveExpense() {
        guard let loggerId = Auth.auth().currentUser?.uid else {
            print("No logged-in user ID found.")
            return
        }

        let newExpense = TripExpense(
            id: existingExpense?.id ?? UUID(),
            date: date,
            expenseName: expenseName,
            personName: personName,
            amount: Double(amount) ?? 0,
            category: category
        )

        // Update local view model
        if existingExpense != nil {
            viewModel.update(newExpense)
        } else {
            viewModel.add(newExpense)
        }

        // Prepare Firestore data
        let expenseData: [String: Any] = [
            "id": newExpense.id.uuidString,
            "date": Timestamp(date: date),
            "expenseName": expenseName,
            "personName": personName,
            "amount": Double(amount) ?? 0,
            "category": category,
            "loggerId": loggerId
        ]

        db.collection("tripExpenses").document(newExpense.id.uuidString).setData(expenseData) { error in
            if let error = error {
                print("Error saving expense to Firestore: \(error.localizedDescription)")
            } else {
                print("Expense successfully saved to Firestore.")
            }
        }

        dismiss()
    }
}
