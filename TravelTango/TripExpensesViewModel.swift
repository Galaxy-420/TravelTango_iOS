import Foundation

class TripExpensesViewModel: ObservableObject {
    static let shared = TripExpensesViewModel()
    @Published var expenses: [TripExpense] = []

    // Example collected budget; replace with actual data source
    var collectedBudget: Double = 10000.0

    var totalExpenses: Double {
        expenses.reduce(0) { $0 + $1.amount }
    }

    func addExpense(_ expense: TripExpense) {
        expenses.append(expense)
    }

    func updateExpense(_ expense: TripExpense) {
        if let index = expenses.firstIndex(where: { $0.id == expense.id }) {
            expenses[index] = expense
        }
    }

    func deleteExpense(_ expense: TripExpense) {
        expenses.removeAll { $0.id == expense.id }
    }
}
