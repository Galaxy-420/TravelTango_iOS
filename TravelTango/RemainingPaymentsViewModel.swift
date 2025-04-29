import Foundation
import FirebaseFirestore
import FirebaseAuth

class RemainingPaymentsViewModel: ObservableObject {
    @Published var payments: [RemainingPayment] = []

    private let db = Firestore.firestore()

    var totalToSend: Double {
        payments.filter { $0.type == .sending }.reduce(0) { $0 + $1.amount }
    }

    var totalToReceive: Double {
        payments.filter { $0.type == .receiving }.reduce(0) { $0 + $1.amount }
    }

    var sendProgress: Double {
        let total = totalToSend + totalToReceive
        return total > 0 ? totalToSend / total : 0
    }

    var receiveProgress: Double {
        let total = totalToSend + totalToReceive
        return total > 0 ? totalToReceive / total : 0
    }

    init() {
        fetchRemainingPayments()
    }

    func add(_ payment: RemainingPayment) {
        payments.append(payment)
    }

    func update(_ payment: RemainingPayment) {
        if let index = payments.firstIndex(where: { $0.id == payment.id }) {
            payments[index] = payment
        }
    }

    func delete(_ payment: RemainingPayment) {
        payments.removeAll { $0.id == payment.id }

        // Delete from Firestore
        db.collection("remainingPayments").document(payment.id.uuidString).delete { error in
            if let error = error {
                print("Error deleting remaining payment from Firestore: \(error.localizedDescription)")
            } else {
                print("Remaining payment deleted from Firestore.")
            }
        }
    }

    func fetchRemainingPayments() {
        guard let loggerId = Auth.auth().currentUser?.uid else {
            print("No logger ID found. Cannot fetch remaining payments.")
            return
        }

        db.collection("remainingPayments")
            .whereField("loggerId", isEqualTo: loggerId)
            .order(by: "date", descending: true)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let documents = snapshot?.documents else {
                    print("No remaining payments found or error: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }

                self?.payments = documents.compactMap { doc -> RemainingPayment? in
                    let data = doc.data()

                    guard
                        let idString = data["id"] as? String,
                        let id = UUID(uuidString: idString),
                        let timestamp = data["date"] as? Timestamp,
                        let expenseName = data["expenseName"] as? String,
                        let personName = data["personName"] as? String,
                        let amount = data["amount"] as? Double,
                        let typeRaw = data["type"] as? String,
                        let type = PaymentType(rawValue: typeRaw)
                    else {
                        return nil
                    }

                    return RemainingPayment(
                        id: id,
                        date: timestamp.dateValue(),
                        expenseName: expenseName,
                        personName: personName,
                        amount: amount,
                        type: type
                    )
                }
            }
    }
}
