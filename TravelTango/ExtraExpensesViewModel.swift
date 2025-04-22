//
//  ExtraExpensesViewModel.swift
//  TravelTango
//
//  Created by Damsara Samarakoon on 2025-04-22.
//
import Foundation
import SwiftUI

class ExtraExpensesViewModel: ObservableObject {
    @Published var extraExpenses: [ExtraExpense] = []

    var totalExtra: Double {
        extraExpenses.reduce(0) { $0 + $1.amount }
    }

    func add(_ expense: ExtraExpense) {
        extraExpenses.append(expense)
    }

    func update(_ expense: ExtraExpense) {
        if let index = extraExpenses.firstIndex(where: { $0.id == expense.id }) {
            extraExpenses[index] = expense
        }
    }

    func delete(_ expense: ExtraExpense) {
        extraExpenses.removeAll { $0.id == expense.id }
    }
}


