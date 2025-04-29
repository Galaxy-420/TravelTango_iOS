import Foundation
import FirebaseFirestore
import FirebaseAuth

class TripExpensesViewModel: ObservableObject {
    @Published var expenses: [TripExpense] = []

    private let db = Firestore.firestore()

    var totalAmount: Double {
        expenses.reduce(0) { $0 + $1.amount }
    }

    init() {
        fetchExpenses()
    }

    func add(_ expense: TripExpense) {
        expenses.append(expense)
    }

    func update(_ expense: TripExpense) {
        if let index = expenses.firstIndex(where: { $0.id == expense.id }) {
            expenses[index] = expense
        }
    }

    func delete(_ expense: TripExpense) {
        expenses.removeAll { $0.id == expense.id }

        // Delete from Firestore as well
        db.collection("tripExpenses").document(expense.id.uuidString).delete { error in
            if let error = error {
                print("Error deleting expense from Firestore: \(error.localizedDescription)")
            } else {
                print("Expense deleted from Firestore.")
            }
        }
    }

    func fetchExpenses() {
        guard let loggerId = Auth.auth().currentUser?.uid else {
            print("No logger ID found. Cannot fetch expenses.")
            return
        }

        db.collection("tripExpenses")
            .whereField("loggerId", isEqualTo: loggerId)
            .order(by: "date", descending: true)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let documents = snapshot?.documents else {
                    print("No expenses found or error: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }

                self?.expenses = documents.compactMap { doc -> TripExpense? in
                    let data = doc.data()

                    guard
                        let idString = data["id"] as? String,
                        let id = UUID(uuidString: idString),
                        let timestamp = data["date"] as? Timestamp,
                        let expenseName = data["expenseName"] as? String,
                        let personName = data["personName"] as? String,
                        let amount = data["amount"] as? Double,
                        let category = data["category"] as? String
                    else {
                        return nil
                    }

                    return TripExpense(
                        id: id,
                        date: timestamp.dateValue(),
                        expenseName: expenseName,
                        personName: personName,
                        amount: amount,
                        category: category
                    )
                }
            }
    }
}
