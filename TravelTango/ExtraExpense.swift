import Foundation

struct ExtraExpense: Identifiable, Codable, Equatable {
    let id: UUID
    var date: Date
    var expenseName: String
    var personName: String
    var amount: Double
}
