import SwiftUI

struct RemainingPaymentsView: View {
    @StateObject private var viewModel = RemainingPaymentsViewModel()
    @State private var showForm = false
    @State private var selectedPayment: RemainingPayment?

    var body: some View {
        NavigationStack {
            VStack(spacing: 10) {
                // Summary Boxes
                HStack(spacing: 16) {
                    SummaryCard(title: "To Send", amount: viewModel.totalToSend, color: .yellow)
                    SummaryCard(title: "To Receive", amount: viewModel.totalToReceive, color: .green)
                }
                .padding()

                // Add New Button
                Button("➕ Add Remaining Payment") {
                    selectedPayment = nil
                    showForm = true
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.horizontal)

                // List of Payments
                if viewModel.payments.isEmpty {
                    Spacer()
                    Text("No remaining payments added yet.")
                        .foregroundColor(.gray)
                    Spacer()
                } else {
                    List {
                        ForEach(viewModel.payments) { payment in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(payment.expenseName)
                                        .font(.headline)
                                    Text("\(payment.type.rawValue.capitalized) • \(payment.personName)") // ✅ FIXED
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                                Text("LKR \(payment.amount, specifier: "%.2f")")
                                    .fontWeight(.bold)
                            }
                            .swipeActions {
                                Button {
                                    selectedPayment = payment
                                    showForm = true
                                } label: {
                                    Label("Edit", systemImage: "pencil")
                                }
                                .tint(.orange)

                                Button(role: .destructive) {
                                    viewModel.delete(payment)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Remaining Payments")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showForm) {
                RemainingPaymentFormView(viewModel: viewModel, existingPayment: $selectedPayment) // ✅ FIXED
            }
        }
    }

    struct SummaryCard: View {
        var title: String
        var amount: Double
        var color: Color

        var body: some View {
            VStack(alignment: .leading) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
                Text("LKR \(amount, specifier: "%.2f")")
                    .font(.title2.bold())
                    .foregroundColor(.white)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(color)
            .cornerRadius(12)
        }
    }
}
