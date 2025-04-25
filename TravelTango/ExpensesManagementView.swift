import SwiftUI

struct ExpensesManagementView: View {
    @EnvironmentObject var tripBudgetViewModel: TripBudgetViewModel
    @EnvironmentObject var tripExpensesViewModel: TripExpensesViewModel
    @EnvironmentObject var extraExpensesViewModel: ExtraExpensesViewModel
    @EnvironmentObject var remainingPaymentsViewModel: RemainingPaymentsViewModel

    @State private var showAddSheet = false
    @State private var selectedDestination: DestinationType = .tripExpenses
    @State private var navigate = false

    var totalCollected: Double {
        tripBudgetViewModel.totalBudget
    }

    var totalSpent: Double {
        tripExpensesViewModel.totalAmount + extraExpensesViewModel.totalAmount
    }

    var progress: Double {
        guard totalCollected > 0 else { return 0 }
        return min(totalSpent / totalCollected, 1.0)
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Text("Expenses Dashboard")
                    .font(.largeTitle.bold())
                    .padding(.top)

                //  Budget Summary with Progress Bar
                VStack(spacing: 8) {
                    Text("Total Budget: LKR \(String(format: "%.2f", totalCollected))")
                        .font(.headline)
                    Text("Spent: LKR \(String(format: "%.2f", totalSpent))")
                        .foregroundColor(.red)
                    ProgressView(value: progress)
                        .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
                .padding(.horizontal)

                // ➕ Add New Expense Button
                Button("➕ Add New") {
                    showAddSheet = true
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(12)
                .padding(.horizontal)

                Spacer()

                // Hidden Navigation Trigger
                NavigationLink(destination: destinationView(for: selectedDestination), isActive: $navigate) {
                    EmptyView()
                }
                .hidden()
            }
            //  Sheet to select section
            .sheet(isPresented: $showAddSheet) {
                AddExpenseOptionsSheet { selected in
                    selectedDestination = selected
                    navigate = true
                }
            }
        }
    }

    // Helper method to get the destination view
    @ViewBuilder
    private func destinationView(for destination: DestinationType) -> some View {
        switch destination {
        case .tripExpenses:
            TripExpensesListView()
                .environmentObject(tripExpensesViewModel)
                .environmentObject(tripBudgetViewModel)

        case .extraExpenses:
            ExtraExpensesListView()
                .environmentObject(extraExpensesViewModel)
                .environmentObject(tripBudgetViewModel)

        case .remainingPayments:
            RemainingPaymentsListView()
                .environmentObject(remainingPaymentsViewModel)

        case .tripBudgetCollection:
            TripBudgetCollectionView()
                .environmentObject(tripBudgetViewModel)
        }
    }
}
