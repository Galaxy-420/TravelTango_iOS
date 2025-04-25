import Foundation

class AuthenticationViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var errorMessage: String?

    func authenticate() {
        AuthenticationManager.shared.authenticate { success, error in
            self.isAuthenticated = success
            self.errorMessage = error
        }
    }
}
