import SwiftUI

struct ForgotPasswordRequestView: View {
    @State private var email = ""

    var isFormValid: Bool {
        return email.contains("@") && email.contains(".")
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                
                Spacer()

                // Logo
                Image(systemName: "airplane.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.travelTangoBlue)

                Text("Forgot Password")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.travelTangoBlue)

                Text("Please enter your email to reset your password")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                TextField("Enter your email", text: $email)
                    .textFieldStyle(.roundedBorder)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .padding(.horizontal)

                Spacer()

                // 🔥 Correct NavigationLink inside the Button
                NavigationLink(destination: ForgotPasswordCodeView(email: email)) {
                    Text("Next")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(isFormValid ? Color.travelTangoBlue : Color.gray)
                        .cornerRadius(12)
                        .padding(.horizontal)
                }
                .disabled(!isFormValid)

                Spacer()
            }
            .background(Color(UIColor.systemGroupedBackground))
            .ignoresSafeArea()
        }
    }
}

#Preview {
    ForgotPasswordRequestView()
}
