//
//  RemainingPaymentsView.swift
//  TravelTango
//
//  Created by Damsara Samarakoon on 2025-04-22.
//
import SwiftUI

struct RemainingPaymentsView: View {
    @StateObject private var viewModel = RemainingPaymentsViewModel()
    @State private var showingAdd = false
    @State private var editingPayment: RemainingPayment? = nil

    var body: some View {
        VStack {
            HStack {
                Text("Total Remaining: LKR \(viewModel.totalRemaining, specifier: "%.2f")")
                    .font(.headline)
                    .padding()
                Spacer()
            }

            List {
                ForEach(viewModel.payments) { payment in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(payment.personName)
                                .font(.headline)
                            Text(payment.description)
                                .font(.subheadline)
                        }
                        Spacer()
                        Text("LKR \(payment.amount, specifier: "%.2f")")
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button("Edit") {
                            editingPayment = payment
                        }
                        .tint(.blue)

                        Button("Delete", role: .destructive) {
                            viewModel.delete(payment)
                        }
                    }
                }
            }
        }
        .navigationTitle("Remaining Payments")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    showingAdd = true
                }) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(Color("DarkBlue"))
                        .font(.title2)
                }
            }
        }
        .sheet(isPresented: $showingAdd) {
            AddRemainingPaymentView(viewModel: viewModel)
        }
        .sheet(item: $editingPayment) { payment in
            AddRemainingPaymentView(viewModel: viewModel, existingPayment: payment)
        }
    }
}

