import Foundation

struct ExtraExpense: Identifiable, Hashable {
    let id: UUID
    var date: Date
    var expenseName: String
    var personName: String
    var amount: Double
}
