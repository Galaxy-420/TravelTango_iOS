import SwiftUI

struct RemainingPaymentsListView: View {
    @EnvironmentObject var viewModel: RemainingPaymentsViewModel

    @State private var navigateToForm = false
    @State private var selectedPayment: RemainingPayment?

    var body: some View {
        VStack(spacing: 16) {
            // Amount To Send
            VStack(alignment: .leading, spacing: 6) {
                Text("Amount to Give Others")
                    .font(.caption)
                    .foregroundColor(.gray)
                Text("LKR \(String(format: "%.2f", viewModel.totalToSend))")
                    .font(.title3.bold())
                    .foregroundColor(.yellow)
                ProgressView(value: viewModel.sendProgress)
                    .progressViewStyle(LinearProgressViewStyle(tint: .yellow))
                    .animation(.easeInOut, value: viewModel.totalToSend)
            }
            .padding()
            .background(Color.yellow.opacity(0.1))
            .cornerRadius(12)
            .padding(.horizontal)

            //  Amount To Receive
            VStack(alignment: .leading, spacing: 6) {
                Text("Amount to Receive")
                    .font(.caption)
                    .foregroundColor(.gray)
                Text("LKR \(String(format: "%.2f", viewModel.totalToReceive))")
                    .font(.title3.bold())
                    .foregroundColor(.green)
                ProgressView(value: viewModel.receiveProgress)
                    .progressViewStyle(LinearProgressViewStyle(tint: .green))
                    .animation(.easeInOut, value: viewModel.totalToReceive)
            }
            .padding()
            .background(Color.green.opacity(0.1))
            .cornerRadius(12)
            .padding(.horizontal)

            //  Add New
            Button("➕ Add New") {
                selectedPayment = nil
                navigateToForm = true
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.horizontal)

            // List
            if viewModel.payments.isEmpty {
                Spacer()
                Text("No payments added yet.")
                    .foregroundColor(.gray)
                Spacer()
            } else {
                List {
                    ForEach(viewModel.payments) { payment in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(payment.expenseName)
                                .font(.headline)
                            Text("\(payment.type.rawValue) - \(payment.personName)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Text("LKR \(String(format: "%.2f", payment.amount))")
                            Text(payment.date.formatted(date: .abbreviated, time: .omitted))
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .swipeActions {
                            Button {
                                selectedPayment = payment
                                navigateToForm = true
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

            Spacer()
        }
        .navigationTitle("Remaining Payments")
        .navigationBarTitleDisplayMode(.inline)
        .background(
            NavigationLink(
                destination: AddRemainingPaymentFormView(viewModel: viewModel, existingPayment: $selectedPayment),
                isActive: $navigateToForm
            ) {
                EmptyView()
            }
            .hidden()
        )
    }
}
