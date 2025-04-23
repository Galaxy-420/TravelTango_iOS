import SwiftUI

struct OverBudgetIndicator: View {
    let overBudgetAmount: Double

    var body: some View {
        Text("Over Budget by LKR \(overBudgetAmount, specifier: "%.2f")")
            .foregroundColor(.red)
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(8)
    }
}
