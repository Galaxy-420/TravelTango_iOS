import SwiftUI

struct AuthenticationView: View {
    @ObservedObject var authViewModel: AuthenticationViewModel

    var body: some View {
        VStack(spacing: 30) {
            Image(systemName: "faceid")
                .resizable()
                .frame(width: 100, height: 100)
                .foregroundColor(.blue)

            Text("Unlock with Face ID")
                .font(.title2)
                .multilineTextAlignment(.center)

            if let error = authViewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding()
            }

            Button("Authenticate") {
                authViewModel.authenticate()
            }
            .font(.headline)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(12)
            .padding(.horizontal)
        }
        .onAppear {
            authViewModel.authenticate()
        }
        .padding()
    }
}
