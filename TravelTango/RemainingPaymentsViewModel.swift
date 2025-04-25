import Foundation

class RemainingPaymentsViewModel: ObservableObject {
    @Published var payments: [RemainingPayment] = []

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
    }
}
