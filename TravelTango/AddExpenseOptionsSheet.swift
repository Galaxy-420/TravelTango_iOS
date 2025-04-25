import SwiftUI

struct AddExpenseOptionsSheet: View {
    @Environment(\.dismiss) private var dismiss
    var onSelect: (DestinationType) -> Void

    var body: some View {
        VStack(spacing: 20) {
            Text("Add New")
                .font(.title.bold())
                .padding(.top)

            // ✅ Trip Budget Collection
            Button {
                onSelect(.tripBudgetCollection)
                dismiss()
            } label: {
                Text("➕ Add Trip Budget Collection")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue.opacity(0.2))
                    .cornerRadius(8)
            }

            // ✅ Trip Expenses
            Button {
                onSelect(.tripExpenses)
                dismiss()
            } label: {
                Text("➕ Add Trip Expenses")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.red.opacity(0.2))
                    .cornerRadius(8)
            }

            // ✅ Extra Expenses
            Button {
                onSelect(.extraExpenses)
                dismiss()
            } label: {
                Text("➕ Add Extra Expense")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.purple.opacity(0.2))
                    .cornerRadius(8)
            }

            // ✅ Remaining Payments
            Button {
                onSelect(.remainingPayments)
                dismiss()
            } label: {
                Text("➕ Add Remaining Payments")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green.opacity(0.2))
                    .cornerRadius(8)
            }

            Button("Cancel") {
                dismiss()
            }
            .foregroundColor(.red)
            .padding(.top, 10)

            Spacer()
        }
        .padding()
    }
}
