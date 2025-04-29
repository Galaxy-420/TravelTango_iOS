import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct AddExtraExpenseFormView: View {
    @ObservedObject var viewModel: ExtraExpensesViewModel
    @Binding var existingExpense: ExtraExpense?

    @Environment(\.dismiss) private var dismiss

    @State private var date = Date()
    @State private var expenseName = ""
    @State private var personName = ""
    @State private var amount = ""

    private let db = Firestore.firestore()

    var body: some View {
        Form {
            Section(header: Text("Extra Expense Details")) {
                DatePicker("Date", selection: $date, displayedComponents: .date)
                TextField("Expense Name", text: $expenseName)
                TextField("Person Name", text: $personName)
                TextField("Amount (LKR)", text: $amount)
                    .keyboardType(.decimalPad)
            }
        }
        .navigationTitle(existingExpense == nil ? "Add Extra Expense" : "Edit Extra Expense")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    saveExtraExpense()
                }
                .disabled(expenseName.isEmpty || personName.isEmpty || amount.isEmpty)
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
            }
        }
    }

    private func saveExtraExpense() {
        guard let loggerId = Auth.auth().currentUser?.uid else {
            print("No logged-in user ID found.")
            return
        }

        let newExpense = ExtraExpense(
            id: existingExpense?.id ?? UUID(),
            date: date,
            expenseName: expenseName,
            personName: personName,
            amount: Double(amount) ?? 0
        )

        // Update local ViewModel
        if existingExpense != nil {
            viewModel.update(newExpense)
        } else {
            viewModel.add(newExpense)
        }

        // Prepare Firestore data
        let extraExpenseData: [String: Any] = [
            "id": newExpense.id.uuidString,
            "date": Timestamp(date: date),
            "expenseName": expenseName,
            "personName": personName,
            "amount": Double(amount) ?? 0,
            "loggerId": loggerId
        ]

        db.collection("extraExpenses").document(newExpense.id.uuidString).setData(extraExpenseData) { error in
            if let error = error {
                print("Error saving extra expense to Firestore: \(error.localizedDescription)")
            } else {
                print("Extra expense successfully saved to Firestore.")
            }
        }

        dismiss()
    }
}
