import SwiftUI

struct ForgotPasswordCodeView: View {
    var email: String
    @State private var code: [String] = Array(repeating: "", count: 5)
    @FocusState private var focusIndex: Int?
    @State private var showResendPopup = false

    var isCodeComplete: Bool {
        return code.allSatisfy { !$0.isEmpty }
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

                Text("Forgot Password")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.travelTangoBlue)

                Text("We've sent a 5-digit code to \(email)\nPlease check your email and enter the code below.")
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                HStack(spacing: 12) {
                    ForEach(0..<5) { index in
                        TextField("", text: $code[index])
                            .frame(width: 50, height: 50)
                            .background(Color.white)
                            .cornerRadius(8)
                            .multilineTextAlignment(.center)
                            .keyboardType(.numberPad)
                            .focused($focusIndex, equals: index)
                            .onChange(of: code[index]) { _ in
                                if code[index].count > 1 {
                                    code[index] = String(code[index].last!)
                                }
                                if code[index] != "" {
                                    focusIndex = min((focusIndex ?? 0) + 1, 4)
                                }
                            }
                    }
                }
                .padding()

                Spacer()

                // 🔥 Correct way: wrap the Button directly inside NavigationLink
                NavigationLink(destination: ResetPasswordView()) {
                    Text("Next")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(isCodeComplete ? Color.travelTangoBlue : Color.gray)
                        .cornerRadius(12)
                        .padding(.horizontal)
                }
                .disabled(!isCodeComplete)

                Button(action: {
                    showResendPopup = true
                }) {
                    Text("Haven't received an email? Resend email")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                        .padding(.top, 10)
                }
                .alert("We've sent you a new email.", isPresented: $showResendPopup) {
                    Button("OK", role: .cancel) { }
                }

                Spacer()
            }
            .background(Color(UIColor.systemGroupedBackground))
            .ignoresSafeArea()
        }
    }
}

#Preview {
    ForgotPasswordCodeView(email: "nim.mandakini@gmail.com")
}
