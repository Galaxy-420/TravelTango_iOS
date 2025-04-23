import SwiftUI

struct SignInView: View {
    @Binding var isSignedIn: Bool

    @State private var email = ""
    @State private var password = ""
    @State private var isPasswordVisible = false

    @State private var showToast = false
    @State private var toastMessage = ""
    @State private var isSuccess = false

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
                        Group {
                            if isPasswordVisible {
                                TextField("Password", text: $password)
                            } else {
                                SecureField("Password", text: $password)
                            }
                        }
                        Button(action: { isPasswordVisible.toggle() }) {
                            Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                                .foregroundColor(.gray)
                        }
                    }
                    .textFieldStyle(.roundedBorder)

                    HStack {
                        Spacer()
                        NavigationLink(destination: ForgotPasswordRequestView()) {
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
                Button(action: signIn) {
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

                // Social Sign-in Buttons
                VStack(spacing: 10) {
                    SocialLoginButton(imageName: "globe", text: "Sign In with Google", backgroundColor: .white, foregroundColor: .black)
                    SocialLoginButton(imageName: "applelogo", text: "Sign In with Apple", backgroundColor: .black, foregroundColor: .white)
                }

                // Sign Up Prompt
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
            .padding(.top)
            .background(Color(UIColor.systemGroupedBackground))
            .ignoresSafeArea()
            .overlay(
                Group {
                    if showToast {
                        VStack {
                            Spacer()
                            Text(toastMessage)
                                .padding()
                                .background(isSuccess ? Color.green.opacity(0.9) : Color.red.opacity(0.9))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .padding(.bottom, 50)
                                .transition(.move(edge: .bottom).combined(with: .opacity))
                        }
                    }
                }
            )
        }
    }

    func signIn() {
        // Always allow sign-in with valid input
        if isFormValid {
            isSignedIn = true
            showSuccess("Signed in successfully!")
        } else {
            showError("Please fill in all fields.")
        }
    }

    func showError(_ message: String) {
        DispatchQueue.main.async {
            toastMessage = message
            isSuccess = false
            showToast = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    showToast = false
                }
            }
        }
    }

    func showSuccess(_ message: String) {
        DispatchQueue.main.async {
            toastMessage = message
            isSuccess = true
            showToast = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    showToast = false
                }
            }
        }
    }
}
