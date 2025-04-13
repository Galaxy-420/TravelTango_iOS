import SwiftUI

struct SignInView: View {
    @State private var email = ""
    @State private var password = ""

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
                    .foregroundColor(Color.blue)

                // Title
                Text("Sign In")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Spacer().frame(height: 20)

                // Form
                Group {
                    TextField("Email Address", text: $email)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)

                    SecureField("Password", text: $password)
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
                        .background(isFormValid ? Color.blue : Color.gray)
                        .cornerRadius(12)
                        .padding(.horizontal)
                }
                .disabled(!isFormValid)

                Spacer().frame(height: 20)

                // Or Sign In with
                VStack(spacing: 10) {
                    Button(action: {
                        print("Sign In with Google tapped")
                    }) {
                        HStack {
                            Image(systemName: "globe")
                            Text("Sign In with Google")
                        }
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        )
                        .padding(.horizontal)
                    }

                    Button(action: {
                        print("Sign In with Apple tapped")
                    }) {
                        HStack {
                            Image(systemName: "applelogo")
                            Text("Sign In with Apple")
                        }
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.black)
                        .cornerRadius(12)
                        .padding(.horizontal)
                    }
                }

                Spacer().frame(height: 20)

                // Link to Sign Up
                HStack {
                    Text("Don't have an account?")
                    NavigationLink(destination: SignUpView()) {
                        Text("Sign Up")
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                    }
                }
                .font(.subheadline)

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
