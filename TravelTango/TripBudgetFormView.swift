import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct TripBudgetFormView: View {
    @ObservedObject var viewModel: TripBudgetViewModel
    @Binding var existingBudget: TripBudget?

    @Environment(\.dismiss) private var dismiss

    @State private var date = Date()
    @State private var budgetName = ""
    @State private var personName = ""
    @State private var amount = ""
    @State private var category = ""

    private let db = Firestore.firestore()

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

    private func saveBudget() {
        guard let loggerId = Auth.auth().currentUser?.uid else {
            print("No logged-in user ID found.")
            return
        }

        let newBudget = TripBudget(
            id: existingBudget?.id ?? UUID(),
            date: date,
            budgetName: budgetName,
            personName: personName,
            amount: Double(amount) ?? 0,
            category: category
        )

        // Update the local view model
        if existingBudget != nil {
            viewModel.update(newBudget)
        } else {
            viewModel.add(newBudget)
        }

        // Prepare Firestore data
        let budgetData: [String: Any] = [
            "id": newBudget.id.uuidString,
            "date": Timestamp(date: date),
            "budgetName": budgetName,
            "personName": personName,
            "amount": Double(amount) ?? 0,
            "category": category,
            "loggerId": loggerId
        ]

        db.collection("tripBudgets").document(newBudget.id.uuidString).setData(budgetData) { error in
            if let error = error {
                print("Error saving budget to Firestore: \(error.localizedDescription)")
            } else {
                print("Budget successfully saved to Firestore.")
            }
        }

        dismiss()
    }
}
