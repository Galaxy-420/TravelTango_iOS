import Foundation
import LocalAuthentication

class AuthenticationManager {
    static let shared = AuthenticationManager()

    func authenticate(completion: @escaping (Bool, String?) -> Void) {
        let context = LAContext()
        var error: NSError?

        // Force Face ID only, if available
        context.localizedCancelTitle = "Cancel"

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Authenticate with Face ID to unlock TravelTango"

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        completion(true, nil)
                    } else {
                        completion(false, authenticationError?.localizedDescription ?? "Authentication Failed")
                    }
                }
            }
        } else {
            DispatchQueue.main.async {
                completion(false, error?.localizedDescription ?? "Biometric Authentication not available")
            }
        }
    }
}
