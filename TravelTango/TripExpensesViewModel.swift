import Foundation

class TripExpensesViewModel: ObservableObject {
    @Published var expenses: [TripExpense] = []

    func add(_ expense: TripExpense) {
        expenses.append(expense)
    }

    func update(_ expense: TripExpense) {
        if let index = expenses.firstIndex(where: { $0.id == expense.id }) {
            expenses[index] = expense
        }
    }

    func delete(_ expense: TripExpense) {
        expenses.removeAll { $0.id == expense.id }
    }

    var totalTripExpenses: Double {
        expenses.reduce(0) { $0 + $1.amount }
    }
}
