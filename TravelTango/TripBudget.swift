import Foundation

struct TripBudget: Identifiable, Hashable {
    let id = UUID()
    var date: Date
    var budgetName: String
    var personName: String
    var amount: Double
    var category: String
}
