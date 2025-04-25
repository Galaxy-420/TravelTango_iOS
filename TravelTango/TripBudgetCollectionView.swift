import SwiftUI

struct TripBudgetCollectionView: View {
    @EnvironmentObject var viewModel: TripBudgetViewModel
    @State private var showForm = false
    @State private var selectedBudget: TripBudget?

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                // Animated Summary
                VStack(alignment: .leading, spacing: 6) {
                    Text("Total Collected")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text("LKR \(String(format: "%.2f", viewModel.totalBudget))")
                        .font(.title.bold())
                        .foregroundColor(.blue)
                        .animation(.easeInOut, value: viewModel.totalBudget)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(12)
                .padding(.horizontal)

                // ➕ Add Button
                Button("➕ Add New") {
                    selectedBudget = nil
                    showForm = true
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.horizontal)

                // List View
                if viewModel.budgets.isEmpty {
                    Spacer()
                    Text("No trip budgets added.")
                        .foregroundColor(.gray)
                    Spacer()
                } else {
                    List {
                        ForEach(viewModel.budgets) { budget in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(budget.budgetName)
                                    .font(.headline)
                                Text("By \(budget.personName) • \(budget.category)")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                Text("LKR \(String(format: "%.2f", budget.amount))")
                                    .font(.subheadline)
                                    .foregroundColor(.primary)
                                Text(budget.date.formatted(date: .abbreviated, time: .omitted))
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            .swipeActions {
                                Button {
                                    selectedBudget = budget
                                    showForm = true
                                } label: {
                                    Label("Edit", systemImage: "pencil")
                                }
                                .tint(.orange)

                                Button(role: .destructive) {
                                    viewModel.delete(budget)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                    }
                }

                Spacer()
            }
            .navigationTitle("Trip Budget Collection")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showForm) {
                TripBudgetFormView(viewModel: viewModel, existingBudget: $selectedBudget)
            }
        }
    }
}
