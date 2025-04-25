import SwiftUI

struct ExtraExpensesListView: View {
    @EnvironmentObject var viewModel: ExtraExpensesViewModel
    @EnvironmentObject var tripBudgetViewModel: TripBudgetViewModel

    @State private var navigateToForm = false
    @State private var selectedExpense: ExtraExpense?

    var progress: Double {
        let totalExtra = viewModel.totalAmount
        let totalBudget = tripBudgetViewModel.totalBudget
        guard totalBudget > 0 else { return 0 }
        return min(totalExtra / totalBudget, 1.0)
    }

    var body: some View {
        VStack(spacing: 16) {
            // Animated header
            VStack(alignment: .leading, spacing: 6) {
                Text("Extra Expenses over Trip Budget")
                    .font(.caption)
                    .foregroundColor(.gray)
                Text("LKR \(String(format: "%.2f", viewModel.totalAmount)) of LKR \(String(format: "%.2f", tripBudgetViewModel.totalBudget))")
                    .font(.title3.bold())
                    .foregroundColor(.purple)
                ProgressView(value: progress)
                    .progressViewStyle(LinearProgressViewStyle(tint: .purple))
                    .animation(.easeInOut, value: progress)
            }
            .padding()
            .background(Color.purple.opacity(0.1))
            .cornerRadius(12)
            .padding(.horizontal)

            // Add Button
            Button("➕ Add New") {
                selectedExpense = nil
                navigateToForm = true
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.purple)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.horizontal)

            // List
            if viewModel.expenses.isEmpty {
                Spacer()
                Text("No extra expenses added yet.")
                    .foregroundColor(.gray)
                Spacer()
            } else {
                List {
                    ForEach(viewModel.expenses) { expense in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(expense.expenseName)
                                .font(.headline)
                            Text("By \(expense.personName)")
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
        .navigationTitle("Extra Expenses")
        .navigationBarTitleDisplayMode(.inline)
        .background(
            NavigationLink(
                destination: AddExtraExpenseFormView(viewModel: viewModel, existingExpense: $selectedExpense),
                isActive: $navigateToForm
            ) {
                EmptyView()
            }.hidden()
        )
    }
}
