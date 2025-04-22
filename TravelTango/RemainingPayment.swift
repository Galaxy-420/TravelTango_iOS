import Foundation

struct RemainingPayment: Identifiable, Hashable {
    let id: UUID
    var date: Date
    var personName: String
    var amount: Double
    var description: String

    init(id: UUID = UUID(), date: Date, personName: String, amount: Double, description: String) {
        self.id = id
        self.date = date
        self.personName = personName
        self.amount = amount
        self.description = description
    }
}
