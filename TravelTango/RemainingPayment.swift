import Foundation

enum PaymentType: String, CaseIterable, Identifiable, Codable {
    case sending = "Sending"
    case receiving = "Receiving"
    
    var id: String { rawValue }
}

struct RemainingPayment: Identifiable, Hashable {
    let id: UUID
    var date: Date
    var expenseName: String
    var personName: String
    var amount: Double
    var type: PaymentType

    init(id: UUID = UUID(), date: Date, expenseName: String, personName: String, amount: Double, type: PaymentType) {
        self.id = id
        self.date = date
        self.expenseName = expenseName
        self.personName = personName
        self.amount = amount
        self.type = type
    }
}
