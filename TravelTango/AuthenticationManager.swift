//
//  AuthenticationManager.swift
//  TravelTango
//
//  Created by Nimeshika Mandakini on 2025-04-25.
//
import Foundation
import LocalAuthentication

class AuthenticationManager {
    static let shared = AuthenticationManager()

    func authenticateWithBiometrics(completion: @escaping (Bool, String?) -> Void) {
        let context = LAContext()
        var error: NSError?

        // Check if biometric auth is available
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Please authenticate to continue"

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        completion(true, nil)
                    } else {
                        let message = authenticationError?.localizedDescription ?? "Failed to authenticate"
                        completion(false, message)
                    }
                }
            }
        } else {
            let message = error?.localizedDescription ?? "Biometric authentication not available"
            completion(false, message)
        }
    }
}

