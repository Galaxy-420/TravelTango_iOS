import SwiftUI

struct ExpensesManagementView: View {
    @State private var showingAddSheet = false

    var body: some View {
        NavigationStack {
            VStack {
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

                List {
                    // Placeholder for items
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
            }
            .navigationTitle("Expenses Management")
            .sheet(isPresented: $showingAddSheet) {
                AddExpenseTypeSheet()
            }
        }
    }
}

struct AddExpenseTypeSheet: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 16) {
            Text("Select Expense Type")
                .font(.headline)
                .padding(.top)

            Group {
                NavigationLink("Trip Budget Collection", destination: TripBudgetCollectionView())
                NavigationLink("Trip Expenses", destination: TripExpensesView())
                NavigationLink("Extra Expenses", destination: ExtraExpensesView())
                NavigationLink("Remaining Payments", destination: RemainingPaymentsView())
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color("DarkBlue"))
            .cornerRadius(10)

            Button("Cancel") {
                dismiss()
            }
            .foregroundColor(.red)
            .padding(.top)

            Spacer()
        }
        .padding()
    }
}
