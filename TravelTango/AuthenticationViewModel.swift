//
//  AuthenticationViewModel.swift
//  TravelTango
//
//  Created by Nimeshika Mandakini on 2025-04-25.
//
import Foundation

class AuthenticationViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var errorMessage: String?

    func authenticateUser() {
        AuthenticationManager.shared.authenticateWithBiometrics { success, error in
            self.isAuthenticated = success
            self.errorMessage = error
        }
    }
}

