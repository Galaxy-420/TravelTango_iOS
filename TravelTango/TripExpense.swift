import Foundation

struct TripExpense: Identifiable, Hashable {
    let id: UUID
    var date: Date
    var expenseName: String
    var personName: String
    var amount: Double
    var category: String

    init(id: UUID = UUID(), date: Date, expenseName: String, personName: String, amount: Double, category: String) {
        self.id = id
        self.date = date
        self.expenseName = expenseName
        self.personName = personName
        self.amount = amount
        self.category = category
    }
}


