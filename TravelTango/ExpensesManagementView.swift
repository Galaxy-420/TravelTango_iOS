import SwiftUI

struct ExpensesManagementView: View {
    @State private var showAddSheet = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Text("Expense Dashboard")
                    .font(.largeTitle.bold())
                    .padding(.top)

                Button(action: {
                    showAddSheet = true
                }) {
                    Text("Add New Expense")
                        .font(.title3)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .padding(.horizontal)

                ExpenseSummaryBox(title: "Trip Budget Collection", amount: 5000)
                ExpenseSummaryBox(title: "Trip Expenses", amount: 3200)
                ExpenseSummaryBox(title: "Extra Expenses", amount: 800)
                ExpenseSummaryBox(title: "Remaining Payments", amount: 1000)

                Spacer()
            }
            .sheet(isPresented: $showAddSheet) {
                AddExpenseOptionsSheet()
            }
        }
    }
}

struct ExpenseSummaryBox: View {
    let title: String
    let amount: Double

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                Text("LKR \(String(format: "%.2f", amount))")
                    .font(.title3.bold())
            }
            Spacer()
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
        .padding(.horizontal)
    }
}
