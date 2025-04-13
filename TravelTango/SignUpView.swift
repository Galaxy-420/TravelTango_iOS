import SwiftUI

struct SignUpView: View {
    @State private var fullName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""

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
                    .foregroundColor(Color.blue)

                // Title
                Text("Sign Up")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Spacer().frame(height: 20)

                // Form
                Group {
                    TextField("Full Name", text: $fullName)
                        .textFieldStyle(.roundedBorder)
                        .autocapitalization(.words)

                    TextField("Email Address", text: $email)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)

                    SecureField("Create Password", text: $password)
                        .textFieldStyle(.roundedBorder)

                    SecureField("Confirm Password", text: $confirmPassword)
                        .textFieldStyle(.roundedBorder)
                }
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
                        .background(isFormValid ? Color.blue : Color.gray)
                        .cornerRadius(12)
                        .padding(.horizontal)
                }
                .disabled(!isFormValid)

                Spacer().frame(height: 20)

                // Or Sign Up with
                VStack(spacing: 10) {
                    Button(action: {
                        print("Sign Up with Google tapped")
                    }) {
                        HStack {
                            Image(systemName: "globe")
                            Text("Sign Up with Google")
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
                        print("Sign Up with Apple tapped")
                    }) {
                        HStack {
                            Image(systemName: "applelogo")
                            Text("Sign Up with Apple")
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

                // Link to Sign In
                HStack {
                    Text("Already have an account?")
                    NavigationLink(destination: SignInView()) {
                        Text("Sign In")
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
    SignUpView()
}
