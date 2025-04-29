import SwiftUI
import FirebaseFirestore
import FirebaseAuth

class TripBudgetViewModel: ObservableObject {
    @Published var budgets: [TripBudget] = []

    private let db = Firestore.firestore()

    var totalBudget: Double {
        budgets.reduce(0) { $0 + $1.amount }
    }

    init() {
        fetchBudgets()
    }

    func add(_ budget: TripBudget) {
        budgets.append(budget)
    }

    func update(_ budget: TripBudget) {
        if let index = budgets.firstIndex(where: { $0.id == budget.id }) {
            budgets[index] = budget
        }
    }

    func delete(_ budget: TripBudget) {
        if let index = budgets.firstIndex(where: { $0.id == budget.id }) {
            budgets.remove(at: index)
        }

        // Also delete from Firestore
        db.collection("tripBudgets").document(budget.id.uuidString).delete { error in
            if let error = error {
                print("Error deleting budget from Firestore: \(error.localizedDescription)")
            } else {
                print("Budget deleted from Firestore.")
            }
        }
    }

    func fetchBudgets() {
        guard let loggerId = Auth.auth().currentUser?.uid else {
            print("No logger ID found. Cannot fetch budgets.")
            return
        }

        db.collection("tripBudgets")
            .whereField("loggerId", isEqualTo: loggerId)
            .order(by: "date", descending: true)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let documents = snapshot?.documents else {
                    print("No budgets found or error: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }

                self?.budgets = documents.compactMap { doc -> TripBudget? in
                    let data = doc.data()

                    guard
                        let idString = data["id"] as? String,
                        let id = UUID(uuidString: idString),
                        let timestamp = data["date"] as? Timestamp,
                        let budgetName = data["budgetName"] as? String,
                        let personName = data["personName"] as? String,
                        let amount = data["amount"] as? Double,
                        let category = data["category"] as? String
                    else {
                        return nil
                    }

                    return TripBudget(
                        id: id,
                        date: timestamp.dateValue(),
                        budgetName: budgetName,
                        personName: personName,
                        amount: amount,
                        category: category
                    )
                }
            }
    }
}
