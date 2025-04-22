import SwiftUI

// ✅ Make your enum Equatable
enum ExpenseType: String, Identifiable, CaseIterable, Equatable {
    var id: String { rawValue }

    case tripBudget
    case tripExpense
    case extraExpense
    case remainingPayment
}

struct ExpensesManagementView: View {
    @State private var showingAddSheet = false
    @State private var selectedExpenseType: ExpenseType?

    var body: some View {
        NavigationStack {
            VStack {
                // ADD NEW BUTTON
                Button(action: {
                    showingAddSheet.toggle()
                }) {
                    Text("Add New")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color("DarkBlue"))
                        .cornerRadius(12)
                        .padding(.horizontal)
                }

                // LIST (Static for now, replace with your dynamic content)
                List {
                    Section(header: Text("Recent Entries")) {
                        NavigationLink(destination: TripBudgetCollectionView()) {
                            HStack {
                                Text("Mandakini")
                                Spacer()
                                Text("LKR 3000")
                            }
                        }
                    }
                }

                // Navigation Triggers (invisible, but triggered via enum selection)
                NavigationLink(destination: TripBudgetCollectionView(), tag: .tripBudget, selection: $selectedExpenseType) { EmptyView() }
                NavigationLink(destination: TripExpensesView(), tag: .tripExpense, selection: $selectedExpenseType) { EmptyView() }
                NavigationLink(destination: ExtraExpensesView(), tag: .extraExpense, selection: $selectedExpenseType) { EmptyView() }
                NavigationLink(destination: RemainingPaymentsView(), tag: .remainingPayment, selection: $selectedExpenseType) { EmptyView() }
            }
            .navigationTitle("Expenses Management")
            .sheet(isPresented: $showingAddSheet) {
                AddExpenseTypeSheet { selected in
                    selectedExpenseType = selected
                    showingAddSheet = false
                }
            }
        }
    }
}
