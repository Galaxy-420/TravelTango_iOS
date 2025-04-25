import SwiftUI

struct TripBudgetCollectionView: View {
    @StateObject private var viewModel = TripBudgetViewModel()
    @State private var showForm = false
    @State private var selectedBudget: TripBudget?

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Text("Trip Budget Collection")
                    .font(.title.bold())
                    .padding()

                Text("Total Collected: LKR \(String(format: "%.2f", viewModel.totalBudget))")
                    .font(.headline)
                    .foregroundColor(.blue)

                List {
                    ForEach(viewModel.budgets) { budget in
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Budget: \(budget.budgetName)")
                                .font(.headline)
                            Text("By \(budget.personName) | \(budget.category)")
                            Text("Amount: LKR \(String(format: "%.2f", budget.amount))")
                            Text("Date: \(budget.date.formatted(date: .abbreviated, time: .omitted))")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .swipeActions {
                            Button(role: .destructive) {
                                viewModel.delete(budget)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }

                            Button {
                                selectedBudget = budget
                                showForm = true
                            } label: {
                                Label("Edit", systemImage: "pencil")
                            }
                            .tint(.orange)
                        }
                    }
                }

                Button("Add New") {
                    selectedBudget = nil
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
                TripBudgetFormView(viewModel: viewModel, existingBudget: $selectedBudget)
            }
        }
    }
}
