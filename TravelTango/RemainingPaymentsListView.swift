import SwiftUI

struct RemainingPaymentsListView: View {
    @StateObject private var viewModel = RemainingPaymentsViewModel()
    @State private var showForm = false
    @State private var selectedPayment: RemainingPayment?

    // Reminder Alert State
    @State private var showReminder = false
    @State private var reminderMessage = ""

    var body: some View {
        VStack(spacing: 16) {
            Text("Remaining Payments")
                .font(.title.bold())
                .padding(.top)

            HStack {
                SummaryBox(title: "To Give", amount: viewModel.totalToGive, color: .yellow)
                SummaryBox(title: "To Receive", amount: viewModel.totalToReceive, color: .green)
            }
            .padding(.horizontal)

            List {
                ForEach(viewModel.payments) { payment in
                    VStack(alignment: .leading) {
                        Text("\(payment.expenseName) - LKR \(String(format: "%.2f", payment.amount))")
                            .font(.headline)
                        Text("\(payment.type.rawValue) | \(payment.personName)")
                        Text("Date: \(payment.date.formatted(date: .abbreviated, time: .omitted))")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .swipeActions {
                        Button(role: .destructive) {
                            viewModel.delete(payment)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }

                        Button {
                            selectedPayment = payment
                            showForm = true
                        } label: {
                            Label("Edit", systemImage: "pencil")
                        }
                        .tint(.orange)
                    }
                }
            }

            Button("Add New") {
                selectedPayment = nil
                showForm = true
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.horizontal)
        }
        .onAppear {
            checkForUpcomingReminders()
        }
        .alert("Reminder", isPresented: $showReminder) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(reminderMessage)
        }
        .sheet(isPresented: $showForm) {
            RemainingPaymentFormView(viewModel: viewModel, existingPayment: $selectedPayment)
        }
    }

    func checkForUpcomingReminders() {
        let today = Calendar.current.startOfDay(for: Date())

        for payment in viewModel.payments {
            let paymentDate = Calendar.current.startOfDay(for: payment.date)
            if let daysDiff = Calendar.current.dateComponents([.day], from: today, to: paymentDate).day,
               daysDiff == 4 {
                reminderMessage = "\(payment.personName) – You have to \(payment.type.rawValue.lowercased()) LKR \(String(format: "%.2f", payment.amount)) in 4 days."
                showReminder = true
                break
            }
        }
    }
}

struct SummaryBox: View {
    let title: String
    let amount: Double
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.subheadline)
            Text("LKR \(String(format: "%.2f", amount))")
                .font(.title3.bold())
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(color.opacity(0.2))
        .cornerRadius(10)
    }
}
