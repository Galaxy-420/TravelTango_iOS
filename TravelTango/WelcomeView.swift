import SwiftUI

struct WelcomeView: View {
    var body: some View {
        VStack {
            Spacer()

            Image(systemName: "airplane.circle.fill") // TEMP: Same logo icon
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
                .foregroundColor(Color(red: 9/255, green: 29/255, blue: 72/255)) // Dark Blue Logo

            Text("TravelTango")
                .font(.system(size: 30, weight: .bold))
                .foregroundColor(Color(red: 9/255, green: 29/255, blue: 72/255))
                .padding(.top, 10)

            Spacer()

            Button(action: {
                print("Get Started Tapped!")
                // Navigate to Dashboard later
            }) {
                Text("Get Started")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(red: 9/255, green: 29/255, blue: 72/255))
                    .cornerRadius(12)
                    .padding(.horizontal, 40)
            }

            Spacer().frame(height: 50)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .ignoresSafeArea()
    }
}

#Preview {
    WelcomeView()
}
