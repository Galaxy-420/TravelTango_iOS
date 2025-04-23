import SwiftUI

struct ExpenseCardView: View {
    var title: String
    var amount: Double
    var color: Color
    var destination: AnyView

    var body: some View {
        NavigationLink(destination: destination) {
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text("\(amount, specifier: "%.2f") LKR")
                        .font(.title3.bold())
                        .foregroundColor(color)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(14)
            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
        }
    }
}
