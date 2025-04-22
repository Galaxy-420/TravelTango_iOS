//
//  TripBudgetViewModel.swift
//  TravelTango
//
//  Created by Damsara Samarakoon on 2025-04-22.
//
import Foundation
import SwiftUI

class TripBudgetViewModel: ObservableObject {
    @Published var budgets: [TripBudget] = []
    
    var totalBudget: Double {
        budgets.reduce(0) { $0 + $1.amount }
    }
    
    func add(_ budget: TripBudget) {
        budgets.append(budget)
    }
    
    func update(_ budget: TripBudget) {
        if let index = budgets.firstIndex(where: { $0.id == budget.id }) {
            budgets[index] = budget
        }
    }
    
    func delete(_ budget: TripBudget) {
        budgets.removeAll { $0.id == budget.id }
    }
}

