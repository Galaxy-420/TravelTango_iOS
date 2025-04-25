import SwiftUI

@main
struct TravelTangoApp: App {
    @StateObject private var tripManager = TripManager()
    @StateObject private var authViewModel = AuthenticationViewModel()
    @State private var isSignedIn = false
    @State private var isSplashFinished = false

    var body: some Scene {
        WindowGroup {
            Group {
                if !isSplashFinished {
                    SplashView(isSplashFinished: $isSplashFinished)
                } else if !isSignedIn {
                    NavigationStack {
                        SignInView(isSignedIn: $isSignedIn)
                    }
                } else if !authViewModel.isAuthenticated {
                    NavigationStack {
                        AuthenticationView(authViewModel: authViewModel)
                    }
                } else {
                    NavigationStack {
                        MainTabView()
                            .environmentObject(tripManager)
                            .environmentObject(authViewModel)
                    }
                }
            }
        }
    }
}
