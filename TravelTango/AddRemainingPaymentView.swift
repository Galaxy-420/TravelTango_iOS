//
//  AddRemainingPaymentView.swift
//  TravelTango
//
//  Created by Damsara Samarakoon on 2025-04-22.
//
import SwiftUI

struct AddRemainingPaymentView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: RemainingPaymentsViewModel

    @State private var date = Date()
    @State private var personName = ""
    @State private var amount = ""
    @State private var description = ""

    var existingPayment: RemainingPayment? = nil

    var body: some View {
        NavigationStack {
            Form {
                DatePicker("Date", selection: $date, displayedComponents: .date)

                TextField("Person Name", text: $personName)
                TextField("Amount", text: $amount)
                    .keyboardType(.decimalPad)
                TextField("Description", text: $description)
            }
            .navigationTitle(existingPayment == nil ? "Add Payment" : "Edit Payment")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let finalAmount = Double(amount) ?? 0
                        let payment = RemainingPayment(
                            id: existingPayment?.id ?? UUID(),
                            date: date,
                            personName: personName,
                            amount: finalAmount,
                            description: description
                        )

                        if existingPayment != nil {
                            viewModel.update(payment)
                        } else {
                            viewModel.add(payment)
                        }

                        dismiss()
                    }
                    .disabled(personName.isEmpty || amount.isEmpty || description.isEmpty)
                }

                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
        .onAppear {
            if let payment = existingPayment {
                date = payment.date
                personName = payment.personName
                amount = "\(payment.amount)"
                description = payment.description
            }
        }
    }
}

