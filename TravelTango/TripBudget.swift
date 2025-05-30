import Foundation

struct TripBudget: Identifiable, Hashable {
    let id: UUID
    var date: Date
    var budgetName: String
    var personName: String
    var amount: Double
    var category: String

    init(id: UUID = UUID(), date: Date, budgetName: String, personName: String, amount: Double, category: String) {
        self.id = id
        self.date = date
        self.budgetName = budgetName
        self.personName = personName
        self.amount = amount
        self.category = category
    }
}
