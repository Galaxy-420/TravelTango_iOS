import SwiftUI

struct TripBudgetCollectionView: View {
    @StateObject private var viewModel = TripBudgetViewModel()
    @State private var showAddBudget = false
    @State private var selectedBudget: TripBudget?

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                // Total Budget Display
                VStack {
                    Text("Total Budget")
                        .font(.headline)
                    Text("\(viewModel.totalBudget, specifier: "%.2f") LKR")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.blue)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                .padding(.horizontal)

                // Add Budget Button
                Button(action: {
                    showAddBudget = true
                }) {
                    Text("Add Budget")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .padding(.horizontal)

                // Recent Budgets List
                var sortedBudgets: [TripBudget] {
                    viewModel.budgets.sorted(by: { $0.date > $1.date })
                }
                
                List {
                    ForEach(sortedBudgets) { budget in
                        VStack(alignment: .leading) {
                            Text(budget.budgetName)
                                .font(.headline)
                            Text("Person: \(budget.personName)")
                                .font(.subheadline)
                            Text("Amount: \(budget.amount, specifier: "%.2f") LKR")
                                .font(.subheadline)
                            Text("Date: \(budget.date.formatted(date: .abbreviated, time: .omitted))")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .padding(.vertical, 4)
                        .onTapGesture {
                            selectedBudget = budget
                        }
                    }
                    .onDelete { indexSet in
                        for index in indexSet {
                            let budgetToDelete = sortedBudgets[index]
                            if let originalIndex = viewModel.budgets.firstIndex(where: { $0.id == budgetToDelete.id }) {
                                viewModel.budgets.remove(at: originalIndex)
                            }
                        }
                    }
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("Trip Budgets")
            .sheet(isPresented: $showAddBudget) {
                AddTripBudgetView(viewModel: viewModel)
            }
            .sheet(item: $selectedBudget) { budget in
                AddTripBudgetView(viewModel: viewModel, existingBudget: budget)
            }
        }
    }
}
