import SwiftUI

struct ExtraExpensesView: View {
    @StateObject private var viewModel = ExtraExpensesViewModel()
    @State private var showForm = false
    @State private var selectedExpense: ExtraExpense?

    var body: some View {
        NavigationStack {
            VStack {
                // Top Box Summary
                HStack {
                    VStack(alignment: .leading) {
                        Text("Total Extra Spent")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.8))
                        Text("LKR \(viewModel.totalAmount, specifier: "%.2f")")
                            .font(.title.bold())
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color.red)
                    .cornerRadius(12)
                    .shadow(radius: 4)

                    Spacer()
                }
                .padding([.horizontal, .top])

                // Add New Button
                Button(action: {
                    selectedExpense = nil
                    showForm = true
                }) {
                    Text("➕ Add New")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.horizontal)

                // List
                if viewModel.expenses.isEmpty {
                    Spacer()
                    Text("No extra expenses added yet.")
                        .foregroundColor(.gray)
                        .padding()
                    Spacer()
                } else {
                    List {
                        ForEach(viewModel.expenses) { expense in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(expense.expenseName)
                                        .font(.headline)
                                    Text("By \(expense.personName)")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                                Text("LKR \(expense.amount, specifier: "%.2f")")
                                    .fontWeight(.bold)
                            }
                            .swipeActions(edge: .trailing) {
                                Button {
                                    selectedExpense = expense
                                    showForm = true
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
            }
            .navigationTitle("Extra Expenses")
            .sheet(isPresented: $showForm) {
                ExtraExpenseFormView(viewModel: viewModel, existingExpense: $selectedExpense)
            }
        }
    }
}
