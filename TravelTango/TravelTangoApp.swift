import SwiftUI

@main
struct TravelTangoApp: App {
    @StateObject private var tripManager = TripManager()
    @State private var isSignedIn = false
    @State private var isSplashFinished = false

    var body: some Scene {
        WindowGroup {
            // We use a single NavigationStack here to control the flow
            if !isSplashFinished {
                SplashView(isSplashFinished: $isSplashFinished)
            } else if !isSignedIn {
                NavigationStack {
                    SignInView(isSignedIn: $isSignedIn)
                }
            } else {
                NavigationStack {
                    MainTabView()
                        .environmentObject(tripManager)
                }
            }
        }
    }
}
