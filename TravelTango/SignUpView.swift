import SwiftUI

struct SignUpView: View {
    @State private var fullName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var isPasswordVisible = false
    @State private var isConfirmPasswordVisible = false

    @State private var showToast = false
    @State private var toastMessage = ""
    @State private var isSuccess = false
    @State private var navigateToSignIn = false // 👈 Navigation flag

    var isFormValid: Bool {
        !fullName.isEmpty &&
        !email.isEmpty &&
        !password.isEmpty &&
        password == confirmPassword
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Spacer()

                Image(systemName: "airplane.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.travelTangoBlue)
                    .padding(.bottom, 10)

                Text("Create Account")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.travelTangoBlue)

                VStack(spacing: 15) {
                    TextField("Full Name", text: $fullName)
                        .textFieldStyle(.roundedBorder)
                        .autocapitalization(.words)

                    TextField("Email Address", text: $email)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)

                    HStack {
                        Group {
                            if isPasswordVisible {
                                TextField("Create Password", text: $password)
                            } else {
                                SecureField("Create Password", text: $password)
                            }
                        }
                        Button(action: { isPasswordVisible.toggle() }) {
                            Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                                .foregroundColor(.gray)
                        }
                    }
                    .textFieldStyle(.roundedBorder)

                    HStack {
                        Group {
                            if isConfirmPasswordVisible {
                                TextField("Confirm Password", text: $confirmPassword)
                            } else {
                                SecureField("Confirm Password", text: $confirmPassword)
                            }
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

                Button(action: register) {
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

                VStack(spacing: 10) {
                    SocialLoginButton(imageName: "globe", text: "Sign Up with Google", backgroundColor: .white, foregroundColor: .black)
                    SocialLoginButton(imageName: "applelogo", text: "Sign Up with Apple", backgroundColor: .black, foregroundColor: .white)
                }

                HStack {
                    Text("Already have an account?")
                    NavigationLink(destination: SignInView(isSignedIn: .constant(false))) {
                        Text("Sign In")
                            .fontWeight(.bold)
                            .foregroundColor(.travelTangoBlue)
                    }
                }
                .font(.subheadline)
                .padding(.top, 10)

                Spacer()

                // 👇 Hidden NavigationLink for programmatic navigation
                NavigationLink(destination: SignInView(isSignedIn: .constant(false)), isActive: $navigateToSignIn) {
                    EmptyView()
                }
            }
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

    func register() {
        guard let url = URL(string: "http://localhost:5001/api/auth/register") else {
            showError("Invalid URL")
            return
        }

        let body: [String: String] = [
            "fullName": fullName,
            "email": email,
            "password": password
        ]

        guard let jsonData = try? JSONEncoder().encode(body) else {
            showError("Failed to encode data")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                showError("Request error: \(error.localizedDescription)")
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                showError("No response from server")
                return
            }

            if httpResponse.statusCode == 200 || httpResponse.statusCode == 201 {
                showSuccess("Account created successfully!")
            } else {
                let statusCode = httpResponse.statusCode
                showError("Failed to register (code: \(statusCode))")
            }
        }.resume()
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
                    navigateToSignIn = true // 👈 Trigger navigation
                }
            }
        }
    }
}
