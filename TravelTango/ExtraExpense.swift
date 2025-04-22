import Foundation

struct ExtraExpense: Identifiable, Hashable {
    let id: UUID
    var date: Date
    var expenseName: String
    var personName: String
    var amount: Double

    init(id: UUID = UUID(), date: Date, expenseName: String, personName: String, amount: Double) {
        self.id = id
        self.date = date
        self.expenseName = expenseName
        self.personName = personName
        self.amount = amount
    }
}
