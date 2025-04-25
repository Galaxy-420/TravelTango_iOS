//
//  DestinationType.swift
//  TravelTango
//
//  Created by Nimeshika Mandakini on 2025-04-25.
//

import Foundation

/// Enum for routing between expense sections
enum DestinationType: String, Hashable, Identifiable {
    case tripBudgetCollection
    case tripExpenses
    case extraExpenses
    case remainingPayments

    var id: String { self.rawValue }
}
