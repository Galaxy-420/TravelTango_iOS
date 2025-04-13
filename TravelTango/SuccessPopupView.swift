import SwiftUI

struct SuccessPopupView: View {
    @Environment(\.dismiss) var dismiss
    @State private var goToSignIn = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {

                Spacer()

                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.green)

                Text("Your password has been successfully updated!")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .padding()

                Button(action: {
                    goToSignIn = true
                }) {
                    Text("Done")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.travelTangoBlue)
                        .cornerRadius(12)
                        .padding(.horizontal)
                }
                .padding(.top, 20)

                Spacer()
            }
            .background(Color(UIColor.systemGroupedBackground))
            .ignoresSafeArea()
            .navigationDestination(isPresented: $goToSignIn) {
                SignInView()
            }
        }
    }
}

#Preview {
    SuccessPopupView()
}
