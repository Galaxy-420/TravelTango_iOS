//
//  AddRemainingPaymentFormView.swift
//  TravelTango
//
//  Created by Nimeshika Mandakini on 2025-04-25.
//
import SwiftUI

struct AddRemainingPaymentFormView: View {
    @ObservedObject var viewModel: RemainingPaymentsViewModel
    @Binding var existingPayment: RemainingPayment?

    @Environment(\.dismiss) private var dismiss

    @State private var date = Date()
    @State private var expenseName = ""
    @State private var personName = ""
    @State private var amount = ""
    @State private var type: PaymentType = .sending

    let teamMembers = ["Nimal", "Kamal", "Saman", "Custom"]

    var body: some View {
        Form {
            DatePicker("Date", selection: $date, displayedComponents: .date)
            TextField("Expense Name", text: $expenseName)

            Picker("Payment Type", selection: $type) {
                ForEach(PaymentType.allCases) { value in
                    Text(value.rawValue).tag(value)
                }
            }
            .pickerStyle(.segmented)

            Picker("Select Person", selection: $personName) {
                ForEach(teamMembers, id: \.self) { member in
                    Text(member)
                }
            }

            if personName == "Custom" {
                TextField("Custom Name", text: $personName)
            }

            TextField("Amount (LKR)", text: $amount)
                .keyboardType(.decimalPad)
        }
        .navigationTitle(existingPayment == nil ? "Add Payment" : "Edit Payment")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    let payment = RemainingPayment(
                        id: existingPayment?.id ?? UUID(),
                        date: date,
                        expenseName: expenseName,
                        personName: personName,
                        amount: Double(amount) ?? 0,
                        type: type
                    )

                    if existingPayment != nil {
                        viewModel.update(payment)
                    } else {
                        viewModel.add(payment)
                    }

                    dismiss()
                }
                .disabled(expenseName.isEmpty || personName.isEmpty || amount.isEmpty)
            }

            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
            }
        }
        .onAppear {
            if let p = existingPayment {
                date = p.date
                expenseName = p.expenseName
                personName = p.personName
                amount = String(format: "%.2f", p.amount)
                type = p.type
            }
        }
    }
}

