import SwiftUI

struct SignUpView: View {
    @State private var fullName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var isPasswordVisible = false
    @State private var isConfirmPasswordVisible = false

    var isFormValid: Bool {
        return !fullName.isEmpty && !email.isEmpty && !password.isEmpty && (password == confirmPassword)
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
                Text("Create Account")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.travelTangoBlue)

                // Card Form
                VStack(spacing: 15) {
                    TextField("Full Name", text: $fullName)
                        .textFieldStyle(.roundedBorder)
                        .autocapitalization(.words)

                    TextField("Email Address", text: $email)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)

                    HStack {
                        if isPasswordVisible {
                            TextField("Create Password", text: $password)
                        } else {
                            SecureField("Create Password", text: $password)
                        }
                        Button(action: { isPasswordVisible.toggle() }) {
                            Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                                .foregroundColor(.gray)
                        }
                    }
                    .textFieldStyle(.roundedBorder)

                    HStack {
                        if isConfirmPasswordVisible {
                            TextField("Confirm Password", text: $confirmPassword)
                        } else {
                            SecureField("Confirm Password", text: $confirmPassword)
                        }
                        Button(action: { isConfirmPasswordVisible.toggle() }) {
                            Image(systemName: isConfirmPasswordVisible ? "eye.slash" : "eye")
                                .foregroundColor(.gray)
                        }
                    }
                    .textFieldStyle(.roundedBorder)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(16)
                .shadow(color: .gray.opacity(0.2), radius: 10)
                .padding(.horizontal)

                // Sign Up Button
                Button(action: {
                    print("Sign Up button tapped!")
                }) {
                    Text("Sign Up")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(isFormValid ? Color.travelTangoBlue : Color.gray)
                        .cornerRadius(12)
                        .padding(.horizontal)
                }
                .disabled(!isFormValid)

                // Social Signup Buttons
                VStack(spacing: 10) {
                    SocialLoginButton(imageName: "globe", text: "Sign Up with Google", backgroundColor: .white, foregroundColor: .black)
                    SocialLoginButton(imageName: "applelogo", text: "Sign Up with Apple", backgroundColor: .black, foregroundColor: .white)
                }

                // Already have an account
                HStack {
                    Text("Already have an account?")
                    NavigationLink(destination: SignInView()) {
                        Text("Sign In")
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

struct SocialLoginButton: View {
    var imageName: String
    var text: String
    var backgroundColor: Color
    var foregroundColor: Color

    var body: some View {
        Button(action: {
            print("\(text) tapped")
        }) {
            HStack {
                Image(systemName: imageName)
                Text(text)
                    .fontWeight(.semibold)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(backgroundColor)
            .foregroundColor(foregroundColor)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )
            .padding(.horizontal)
        }
    }
}

#Preview {
    SignUpView()
}
