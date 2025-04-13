import SwiftUI

struct SignInView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isPasswordVisible = false

    var isFormValid: Bool {
        return !email.isEmpty && !password.isEmpty
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
                    .padding(.bottom, 10)

                // Title
                Text("Sign In")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.travelTangoBlue)

                VStack(spacing: 15) {
                    TextField("Email Address", text: $email)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)

                    HStack {
                        if isPasswordVisible {
                            TextField("Password", text: $password)
                        } else {
                            SecureField("Password", text: $password)
                        }
                        Button(action: { isPasswordVisible.toggle() }) {
                            Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                                .foregroundColor(.gray)
                        }
                    }
                    .textFieldStyle(.roundedBorder)

                    HStack {
                        Spacer()
                        NavigationLink(destination: ForgotPasswordView()) {
                            Text("Forgot Password?")
                                .font(.subheadline)
                                .foregroundColor(.blue)
                        }
                        .padding(.trailing, 30)
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(16)
                .shadow(color: .gray.opacity(0.2), radius: 10)
                .padding(.horizontal)

                // Sign In Button
                Button(action: {
                    print("Sign In button tapped!")
                }) {
                    Text("Sign In")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(isFormValid ? Color.travelTangoBlue : Color.gray)
                        .cornerRadius(12)
                        .padding(.horizontal)
                }
                .disabled(!isFormValid)

                // Social Signin Buttons
                VStack(spacing: 10) {
                    SocialLoginButton(imageName: "globe", text: "Sign In with Google", backgroundColor: .white, foregroundColor: .black)
                    SocialLoginButton(imageName: "applelogo", text: "Sign In with Apple", backgroundColor: .black, foregroundColor: .white)
                }

                // Don't have an account
                HStack {
                    Text("Don't have an account?")
                    NavigationLink(destination: SignUpView()) {
                        Text("Sign Up")
                            .fontWeight(.bold)
                            .foregroundColor(.travelTangoBlue)
                    }
                }
                .font(.subheadline)
                .padding(.top, 10)

                Spacer()
            }
            .background(Color(UIColor.systemGroupedBackground))
            .ignoresSafeArea()
        }
    }
}

#Preview {
    SignInView()
}
