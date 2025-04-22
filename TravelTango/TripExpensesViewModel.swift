//
//  TripExpensesViewModel.swift
//  TravelTango
//
//  Created by Damsara Samarakoon on 2025-04-22.
//
import Foundation
import SwiftUI

class TripExpensesViewModel: ObservableObject {
    @Published var expenses: [TripExpense] = []
    var collectedBudget: Double = 1000.0 // You can link this to your TripBudgetViewModel later

    var totalExpenses: Double {
        expenses.reduce(0) { $0 + $1.amount }
    }

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
}

