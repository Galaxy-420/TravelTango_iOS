import SwiftUI

struct AddExpenseTypeSheet: View {
    var onSelect: (ExpenseType) -> Void

    var body: some View {
        VStack(spacing: 16) {
            Text("Select Expense Type")
                .font(.headline)
                .padding(.top)

            VStack(spacing: 12) {
                Button("Trip Budget Collection") {
                    onSelect(.tripBudget)
                }
                .modifier(ExpenseButtonStyle())

                Button("Trip Expenses") {
                    onSelect(.tripExpense)
                }
                .modifier(ExpenseButtonStyle())

                Button("Extra Expenses") {
                    onSelect(.extraExpense)
                }
                .modifier(ExpenseButtonStyle())

                Button("Remaining Payments") {
                    onSelect(.remainingPayment)
                }
                .modifier(ExpenseButtonStyle())
            }

            Button("Cancel") {
                onSelect(.tripBudget) // fallback or no-op
            }
            .foregroundColor(.red)
            .padding(.top)

            Spacer()
        }
        .padding()
    }
}

struct ExpenseButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color("DarkBlue"))
            .cornerRadius(10)
    }
}
