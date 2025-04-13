import SwiftUI

struct DashboardView: View {
    var body: some View {
        VStack {
            Text("Welcome to TravelTango Dashboard!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .ignoresSafeArea()
    }
}

#Preview {
    DashboardView()
}
