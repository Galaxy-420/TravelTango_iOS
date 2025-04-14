import SwiftUI

struct NewTripView: View {
    var body: some View {
        VStack {
            Spacer()
            Text("New Trip Page (Empty)")
                .font(.title)
                .foregroundColor(.gray)
            Spacer()
        }
        .background(Color.white)
        .ignoresSafeArea()
    }
}

#Preview {
    NewTripView()
}
