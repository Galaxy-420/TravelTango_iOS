//
//  ResetPasswordView.swift
//  TravelTango
//
//  Created by Damsara Samarakoon on 2025-04-13.
//

import SwiftUI

struct ResetPasswordView: View {
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var isPasswordVisible = false
    @State private var isConfirmPasswordVisible = false
    @State private var showSuccessPopup = false
    @State private var errorMessage = ""

    var isFormValid: Bool {
        password.count >= 8 && password == confirmPassword
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

                Text("Set New Password")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.travelTangoBlue)

                VStack(spacing: 15) {
                    HStack {
                        if isPasswordVisible {
                            TextField("Enter new password", text: $password)
                        } else {
                            SecureField("Enter new password", text: $password)
                        }
                        Button(action: { isPasswordVisible.toggle() }) {
                            Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                                .foregroundColor(.gray)
                        }
                    }
                    .textFieldStyle(.roundedBorder)

                    HStack {
                        if isConfirmPasswordVisible {
                            TextField("Re-enter password", text: $confirmPassword)
                        } else {
                            SecureField("Re-enter password", text: $confirmPassword)
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

                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                }

                Spacer()

                Button(action: {
                    if password != confirmPassword {
                        errorMessage = "Passwords do not match!"
                    } else {
                        errorMessage = ""
                        showSuccessPopup = true
                    }
                }) {
                    Text("Update Password")
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
            .sheet(isPresented: $showSuccessPopup) {
                SuccessPopupView()
            }
        }
    }
}

#Preview {
    ResetPasswordView()
}
