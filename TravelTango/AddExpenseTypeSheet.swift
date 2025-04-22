import SwiftUI

struct AddExpenseTypeSheet: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 16) {
            Text("Select Expense Type")
                .font(.headline)
                .padding(.top)

            Group {
                NavigationLink("Trip Budget Collection", destination: TripBudgetCollectionView())
                NavigationLink("Trip Expenses", destination: TripExpensesView())
                NavigationLink("Extra Expenses", destination: ExtraExpensesView())
                NavigationLink("Remaining Payments", destination: RemainingPaymentsView())
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color("DarkBlue"))
            .cornerRadius(10)

            Button("Cancel") {
                dismiss()
            }
            .foregroundColor(.red)
            .padding(.top)

            Spacer()
        }
        .padding()
    }
}
