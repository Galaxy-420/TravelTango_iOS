import SwiftUI

struct TripExpensesView: View {
    @StateObject private var viewModel = TripExpensesViewModel()
    @State private var showingAddExpense = false
    @State private var editingExpense: TripExpense?

    var body: some View {
        VStack(spacing: 16) {
            // Budget Overview
            VStack(alignment: .leading, spacing: 8) {
                Text("Budget Overview")
                    .font(.headline)
                ProgressView(value: viewModel.totalExpenses, total: viewModel.collectedBudget)
                    .accentColor(.blue)
                HStack {
                    Text("Spent: LKR \(viewModel.totalExpenses, specifier: "%.2f")")
                    Spacer()
                    Text("Total: LKR \(viewModel.collectedBudget, specifier: "%.2f")")
                }
                .font(.subheadline)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .padding(.horizontal)

            // Add Expense Button
            Button(action: {
                showingAddExpense = true
            }) {
                Text("Add New Expense")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding(.horizontal)

            // Expense List
            List {
                ForEach(viewModel.expenses.sorted(by: { $0.date > $1.date })) { expense in
                    VStack(alignment: .leading) {
                        Text(expense.expenseName)
                            .font(.headline)
                        Text("By: \(expense.personName)")
                            .font(.subheadline)
                        Text("Amount: LKR \(expense.amount, specifier: "%.2f")")
                            .font(.subheadline)
                        Text("Date: \(expense.date.formatted(date: .abbreviated, time: .omitted))")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical, 4)
                    .onTapGesture {
                        editingExpense = expense
                    }
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        let expense = viewModel.expenses.sorted(by: { $0.date > $1.date })[index]
                        viewModel.deleteExpense(expense)
                    }
                }
            }
            .listStyle(PlainListStyle())
        }
        .navigationTitle("Trip Expenses")
        .sheet(isPresented: $showingAddExpense) {
            AddTripExpenseView(viewModel: viewModel)
        }
        .sheet(item: $editingExpense) { expense in
            AddTripExpenseView(viewModel: viewModel, existingExpense: expense)
        }
    }
}
