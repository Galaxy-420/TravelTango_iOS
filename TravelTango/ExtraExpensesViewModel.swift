import Foundation
import FirebaseFirestore
import FirebaseAuth

class ExtraExpensesViewModel: ObservableObject {
    @Published var expenses: [ExtraExpense] = []

    private let db = Firestore.firestore()

    var totalAmount: Double {
        expenses.reduce(0) { $0 + $1.amount }
    }

    init() {
        fetchExtraExpenses()
    }

    func add(_ expense: ExtraExpense) {
        expenses.append(expense)
    }

    func update(_ expense: ExtraExpense) {
        if let index = expenses.firstIndex(where: { $0.id == expense.id }) {
            expenses[index] = expense
        }
    }

    func delete(_ expense: ExtraExpense) {
        expenses.removeAll { $0.id == expense.id }

        // Delete from Firestore
        db.collection("extraExpenses").document(expense.id.uuidString).delete { error in
            if let error = error {
                print("Error deleting extra expense from Firestore: \(error.localizedDescription)")
            } else {
                print("Extra expense deleted from Firestore.")
            }
        }
    }

    func fetchExtraExpenses() {
        guard let loggerId = Auth.auth().currentUser?.uid else {
            print("No logger ID found. Cannot fetch extra expenses.")
            return
        }

        db.collection("extraExpenses")
            .whereField("loggerId", isEqualTo: loggerId)
            .order(by: "date", descending: true)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let documents = snapshot?.documents else {
                    print("No extra expenses found or error: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }

                self?.expenses = documents.compactMap { doc -> ExtraExpense? in
                    let data = doc.data()

                    guard
                        let idString = data["id"] as? String,
                        let id = UUID(uuidString: idString),
                        let timestamp = data["date"] as? Timestamp,
                        let expenseName = data["expenseName"] as? String,
                        let personName = data["personName"] as? String,
                        let amount = data["amount"] as? Double
                    else {
                        return nil
                    }

                    return ExtraExpense(
                        id: id,
                        date: timestamp.dateValue(),
                        expenseName: expenseName,
                        personName: personName,
                        amount: amount
                    )
                }
            }
    }
}
