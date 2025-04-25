import SwiftUI

struct SignInView: View {
    @Binding var isSignedIn: Bool

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

                Image(systemName: "airplane.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.travelTangoBlue)
                    .padding(.bottom, 10)

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
                }
                .padding()
                .background(Color.white)
                .cornerRadius(16)
                .shadow(color: .gray.opacity(0.2), radius: 10)
                .padding(.horizontal)

                // Sign In Button
                Button(action: {
                    isSignedIn = true
                }) {
                    Text("Sign In")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(isFormValid ? Color.travelTangoBlue : Color.gray)
                        .cornerRadius(12)
                }
                .disabled(!isFormValid)
                .padding(.horizontal)

                // Social Buttons
                VStack(spacing: 10) {
                    Button(action: {}) {
                        HStack {
                            Image(systemName: "globe")
                                .foregroundColor(.black)
                            Text("Sign In with Google")
                                .foregroundColor(.black)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(radius: 4)
                    }
                    .padding(.horizontal)

                    Button(action: {}) {
                        HStack {
                            Image(systemName: "applelogo")
                                .foregroundColor(.white)
                            Text("Sign In with Apple")
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black)
                        .cornerRadius(12)
                        .shadow(radius: 4)
                    }
                    .padding(.horizontal)
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
        }
    }
}
