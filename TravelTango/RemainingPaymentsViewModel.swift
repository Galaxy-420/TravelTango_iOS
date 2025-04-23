//
//  RemainingPaymentsViewModel.swift
//  TravelTango
//
//  Created by Damsara Samarakoon on 2025-04-22.
//
import Foundation
import SwiftUI

class RemainingPaymentsViewModel: ObservableObject {
    static let shared = RemainingPaymentsViewModel()
    
    @Published var payments: [RemainingPayment] = []
    

    var totalRemaining: Double {
        payments.reduce(0) { $0 + $1.amount }
    }

    func add(_ payment: RemainingPayment) {
        payments.append(payment)
    }

    func update(_ payment: RemainingPayment) {
        if let index = payments.firstIndex(where: { $0.id == payment.id }) {
            payments[index] = payment
        }
    }

    func delete(_ payment: RemainingPayment) {
        payments.removeAll { $0.id == payment.id }
    }
}

