import SwiftUI

struct AddExpenseOptionsSheet: View {
    @Environment(\.dismiss) private var dismiss

    @State private var selectedDestination: DestinationType?

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Add New")
                    .font(.title.bold())
                    .padding(.top)

                Button {
                    selectedDestination = .tripBudgetCollection
                } label: {
                    Text("➕ Add Trip Budget Collection")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue.opacity(0.2))
                        .cornerRadius(8)
                }

                Button {
                    selectedDestination = .tripExpenses
                } label: {
                    Text("➕ Add Trip Expenses")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green.opacity(0.2))
                        .cornerRadius(8)
                }

                Button {
                    selectedDestination = .extraExpenses
                } label: {
                    Text("➕ Add Extra Expense")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.purple.opacity(0.2))
                        .cornerRadius(8)
                }

                Button {
                    selectedDestination = .remainingPayments
                } label: {
                    Text("➕ Add Remaining Payments")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange.opacity(0.2))
                        .cornerRadius(8)
                }

                Button(action: {
                    dismiss()
                }) {
                    Text("Cancel")
                        .foregroundColor(.red)
                        .bold()
                }
                .padding(.top, 30)

                Spacer()
            }
            .padding()
            .navigationTitle("Add Expense")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: DestinationType.self) { destination in
                switch destination {
                case .tripBudgetCollection:
                    TripBudgetCollectionView()
                case .tripExpenses:
                    TripExpensesListView()
                case .extraExpenses:
                    ExtraExpensesListView()
                case .remainingPayments:
                    RemainingPaymentsListView()
                }
            }
        }
    }
}

enum DestinationType: Hashable {
    case tripBudgetCollection
    case tripExpenses
    case extraExpenses
    case remainingPayments
}
