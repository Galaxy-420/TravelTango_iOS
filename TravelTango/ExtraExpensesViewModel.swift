import Foundation

class ExtraExpensesViewModel: ObservableObject {
    @Published var expenses: [ExtraExpense] = []

    func add(_ expense: ExtraExpense) {
        expenses.append(expense)
    }

    func update(_ expense: ExtraExpense) {
        if let index = expenses.firstIndex(where: { $0.id == expense.id }) {
            expenses[index] = expense
        }
    }

    func delete(_ expense: ExtraExpense) {
        expenses.removeAll { $0.id == expense.id }
    }

    var totalAmount: Double {
        expenses.reduce(0) { $0 + $1.amount }
    }
}
