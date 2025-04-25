import SwiftUI

struct TripExpensesListView: View {
    @StateObject private var viewModel = TripExpensesViewModel()
    @State private var showForm = false
    @State private var selectedExpense: TripExpense?

    var body: some View {
        VStack(spacing: 16) {
            Text("Trip Expenses")
                .font(.title.bold())
                .padding()

            Text("Total Spent: LKR \(String(format: "%.2f", viewModel.totalTripExpenses))")
                .font(.headline)
                .foregroundColor(.red)

            List {
                ForEach(viewModel.expenses) { expense in
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Expense: \(expense.expenseName)")
                            .font(.headline)
                        Text("By \(expense.personName) | \(expense.category)")
                        Text("Amount: LKR \(String(format: "%.2f", expense.amount))")
                        Text("Date: \(expense.date.formatted(date: .abbreviated, time: .omitted))")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical, 4)
                    .swipeActions {
                        Button(role: .destructive) {
                            viewModel.delete(expense)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }

                        Button {
                            selectedExpense = expense
                            showForm = true
                        } label: {
                            Label("Edit", systemImage: "pencil")
                        }
                        .tint(.orange)
                    }
                }
            }

            Button("Add New") {
                selectedExpense = nil
                showForm = true
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.horizontal)
        }
        .sheet(isPresented: $showForm) {
            TripExpenseFormView(viewModel: viewModel, existingExpense: $selectedExpense)
        }
    }
}
