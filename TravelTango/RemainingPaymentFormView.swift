import SwiftUI

struct RemainingPaymentFormView: View {
    @ObservedObject var viewModel: RemainingPaymentsViewModel
    @Binding var existingPayment: RemainingPayment?

    @Environment(\.dismiss) var dismiss

    @State private var date = Date()
    @State private var expenseName = ""
    @State private var personName = ""
    @State private var customPersonName = ""
    @State private var amount = ""
    @State private var paymentType: PaymentType = .sending

    let sampleTeamMembers = ["Nimal", "Kamal", "Saman", "Custom"]

    var isUsingCustomName: Bool {
        personName == "Custom"
    }

    var finalPersonName: String {
        isUsingCustomName ? customPersonName : personName
    }

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Payment Details")) {
                    DatePicker("Date", selection: $date, displayedComponents: .date)

                    TextField("Expense Name", text: $expenseName)

                    Picker("Payment Type", selection: $paymentType) {
                        ForEach(PaymentType.allCases, id: \.self) { type in
                            Text(type.rawValue.capitalized).tag(type)
                        }
                    }
                    .pickerStyle(.segmented)

                    Picker("Select Member", selection: $personName) {
                        ForEach(sampleTeamMembers, id: \.self) { member in
                            Text(member).tag(member)
                        }
                    }

                    if isUsingCustomName {
                        TextField("Custom Name", text: $customPersonName)
                    }

                    TextField("Amount (LKR)", text: $amount)
                        .keyboardType(.decimalPad)
                }
            }
            .navigationTitle(existingPayment == nil ? "Add Payment" : "Edit Payment")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let newPayment = RemainingPayment(
                            id: existingPayment?.id ?? UUID(),
                            date: date,
                            expenseName: expenseName,
                            personName: finalPersonName,
                            amount: Double(amount) ?? 0,
                            type: paymentType //
                        )

                        if existingPayment != nil {
                            viewModel.update(newPayment)
                        } else {
                            viewModel.add(newPayment)
                        }
                        dismiss()
                    }
                    .disabled(expenseName.isEmpty || finalPersonName.isEmpty || amount.isEmpty)
                }

                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                if let payment = existingPayment {
                    date = payment.date
                    expenseName = payment.expenseName
                    personName = sampleTeamMembers.contains(payment.personName) ? payment.personName : "Custom"
                    customPersonName = payment.personName
                    amount = String(format: "%.2f", payment.amount)
                    paymentType = payment.type // 
                }
            }
        }
    }
}
