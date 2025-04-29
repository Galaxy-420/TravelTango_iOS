import SwiftUI
import FirebaseFirestore
import FirebaseAuth

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

    private let db = Firestore.firestore()

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
                    savePayment()
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

    private func savePayment() {
        guard let loggerId = Auth.auth().currentUser?.uid else {
            print("No logged-in user ID found.")
            return
        }

        let payment = RemainingPayment(
            id: existingPayment?.id ?? UUID(),
            date: date,
            expenseName: expenseName,
            personName: personName,
            amount: Double(amount) ?? 0,
            type: type
        )

        // Update the local view model
        if existingPayment != nil {
            viewModel.update(payment)
        } else {
            viewModel.add(payment)
        }

        // Prepare Firestore data
        let paymentData: [String: Any] = [
            "id": payment.id.uuidString,
            "date": Timestamp(date: date),
            "expenseName": expenseName,
            "personName": personName,
            "amount": Double(amount) ?? 0,
            "type": payment.type.rawValue,
            "loggerId": loggerId
        ]

        db.collection("remainingPayments").document(payment.id.uuidString).setData(paymentData) { error in
            if let error = error {
                print("Error saving payment to Firestore: \(error.localizedDescription)")
            } else {
                print("Payment successfully saved to Firestore.")
            }
        }

        dismiss()
    }
}
