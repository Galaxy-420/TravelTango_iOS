import Foundation

enum PaymentType: String, CaseIterable, Identifiable, Codable {
    case sending = "Sending"
    case receiving = "Receiving"

    var id: String { self.rawValue }
}

struct RemainingPayment: Identifiable, Hashable {
    let id: UUID
    var date: Date
    var expenseName: String
    var personName: String
    var amount: Double
    var type: PaymentType
}
