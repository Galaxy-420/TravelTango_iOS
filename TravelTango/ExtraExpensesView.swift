import SwiftUI

struct ExtraExpensesView: View {
    @StateObject private var viewModel = ExtraExpensesViewModel()
    @State private var showAddExpense = false
    @State private var selectedExpense: ExtraExpense?

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                // Total Extra Expenses
                VStack {
                    Text("Total Extra Expenses")
                        .font(.headline)
                    Text("\(viewModel.totalAmount, specifier: "%.2f") LKR")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.red)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .padding(.horizontal)

                // Add Expense Button
                Button(action: {
                    showAddExpense = true
                }) {
                    Text("Add Extra Expense")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
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
                            Text("Person: \(expense.personName)")
                                .font(.subheadline)
                            Text("Amount: \(expense.amount, specifier: "%.2f") LKR")
                                .font(.subheadline)
                            Text("Date: \(expense.date.formatted(date: .abbreviated, time: .omitted))")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .padding(.vertical, 4)
                        .onTapGesture {
                            selectedExpense = expense
                        }
                    }
                    .onDelete { indexSet in
                        for index in indexSet {
                            let sorted = viewModel.expenses.sorted(by: { $0.date > $1.date })
                            let toDelete = sorted[index]
                            viewModel.delete(toDelete)
                        }
                    }
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("Extra Expenses")
            .sheet(isPresented: $showAddExpense) {
                AddExtraExpenseView(viewModel: viewModel)
            }
            .sheet(item: $selectedExpense) { expense in
                AddExtraExpenseView(viewModel: viewModel, existingExpense: expense)
            }
        }
    }
}
