import SwiftUI

enum ExpenseType: String, Identifiable, CaseIterable {
    case tripBudget, tripExpense, extraExpense, remainingPayment

    var id: String { rawValue }

    var title: String {
        switch self {
        case .tripBudget: return "Trip Budget Collection"
        case .tripExpense: return "Trip Expenses"
        case .extraExpense: return "Extra Expenses"
        case .remainingPayment: return "Remaining Payments"
        }
    }
}

struct ExpensesManagementView: View {
    @ObservedObject private var tripBudgetVM = TripBudgetViewModel.shared
    @ObservedObject private var tripExpenseVM = TripExpensesViewModel.shared
    @ObservedObject private var extraExpenseVM = ExtraExpensesViewModel.shared
    @ObservedObject private var remainingPaymentVM = RemainingPaymentsViewModel.shared

    @State private var showExpenseSheet = false
    @State private var selectedExpense: ExpenseType?

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Expense Management")
                    .font(.title2.bold())
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.top, 10)

                Button(action: {
                    showExpenseSheet = true
                }) {
                    Text("➕ Add New Expense")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.darkBlue)
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 4)
                }
                .padding(.horizontal)
                .padding(.bottom, 10)

                VStack(spacing: 16) {
                    if tripBudgetVM.totalBudget > 0 {
                        ExpenseCardView(
                            title: "Trip Budget Collection",
                            amount: tripBudgetVM.totalBudget,
                            color: .blue,
                            destination: AnyView(TripBudgetCollectionView())
                        )
                    }

                    if tripExpenseVM.totalExpenses > 0 {
                        ExpenseCardView(
                            title: "Trip Expenses",
                            amount: tripExpenseVM.totalExpenses,
                            color: .orange,
                            destination: AnyView(TripExpensesView())
                        )
                    }

                    if extraExpenseVM.totalAmount > 0 {
                        ExpenseCardView(
                            title: "Extra Expenses",
                            amount: extraExpenseVM.totalAmount,
                            color: .red,
                            destination: AnyView(ExtraExpensesView())
                        )
                    }

                    if remainingPaymentVM.totalRemaining > 0 {
                        ExpenseCardView(
                            title: "Remaining Payments",
                            amount: remainingPaymentVM.totalRemaining,
                            color: .green,
                            destination: AnyView(RemainingPaymentsView())
                        )
                    }
                }
                .padding(.horizontal)

                Spacer()
            }
            .padding()
            .background(Color(.systemGroupedBackground).ignoresSafeArea())
            .confirmationDialog("Select Expense Type", isPresented: $showExpenseSheet, titleVisibility: .visible) {
                ForEach(ExpenseType.allCases, id: \.self) { type in
                    Button(type.title) {
                        selectedExpense = type
                    }
                }
                Button("Cancel", role: .cancel) { }
            }
            .navigationDestination(item: $selectedExpense) { type in
                destinationView(for: type)
            }
        }
    }

    @ViewBuilder
    func destinationView(for type: ExpenseType) -> some View {
        switch type {
        case .tripBudget:
            TripBudgetCollectionView()
        case .tripExpense:
            TripExpensesView()
        case .extraExpense:
            ExtraExpensesView()
        case .remainingPayment:
            RemainingPaymentsView()
        }
    }
}
