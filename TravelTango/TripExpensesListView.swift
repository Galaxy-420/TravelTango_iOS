import SwiftUI

struct TripExpensesListView: View {
    @EnvironmentObject var viewModel: TripExpensesViewModel
    @EnvironmentObject var tripBudgetViewModel: TripBudgetViewModel

    @State private var navigateToForm = false
    @State private var selectedExpense: TripExpense?

    var progress: Double {
        let spent = viewModel.totalAmount
        let collected = tripBudgetViewModel.totalBudget
        guard collected > 0 else { return 0 }
        return min(spent / collected, 1.0)
    }

    var body: some View {
        VStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 6) {
                Text("Spent from Trip Budget")
                    .font(.caption)
                    .foregroundColor(.gray)
                Text("LKR \(String(format: "%.2f", viewModel.totalAmount)) of LKR \(String(format: "%.2f", tripBudgetViewModel.totalBudget))")
                    .font(.title3.bold())
                    .foregroundColor(.red)
                ProgressView(value: progress)
                    .progressViewStyle(LinearProgressViewStyle(tint: .red))
                    .animation(.easeInOut, value: progress)
            }
            .padding()
            .background(Color.red.opacity(0.1))
            .cornerRadius(12)
            .padding(.horizontal)

            Button("➕ Add New") {
                selectedExpense = nil
                navigateToForm = true
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.red)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.horizontal)

            if viewModel.expenses.isEmpty {
                Spacer()
                Text("No trip expenses added yet.")
                    .foregroundColor(.gray)
                Spacer()
            } else {
                List {
                    ForEach(viewModel.expenses) { expense in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(expense.expenseName)
                                .font(.headline)
                            Text("By \(expense.personName) • \(expense.category)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Text("LKR \(String(format: "%.2f", expense.amount))")
                            Text(expense.date.formatted(date: .abbreviated, time: .omitted))
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .swipeActions {
                            Button {
                                selectedExpense = expense
                                navigateToForm = true
                            } label: {
                                Label("Edit", systemImage: "pencil")
                            }
                            .tint(.orange)

                            Button(role: .destructive) {
                                viewModel.delete(expense)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                }
            }

            Spacer()
        }
        .navigationTitle("Trip Expenses")
        .navigationBarTitleDisplayMode(.inline)
        .background(
            NavigationLink(
                destination: AddTripExpenseFormView(viewModel: viewModel, existingExpense: $selectedExpense),
                isActive: $navigateToForm
            ) {
                EmptyView()
            }.hidden()
        )
    }
}
