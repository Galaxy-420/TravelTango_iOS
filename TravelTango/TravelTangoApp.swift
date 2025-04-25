import SwiftUI
import Firebase // Import Firebase
import GoogleMaps // Import Google Maps

@main
struct TravelTangoApp: App {
    @StateObject private var tripManager = TripManager()
    @StateObject private var tripBudgetViewModel = TripBudgetViewModel()
    @StateObject private var tripExpensesViewModel = TripExpensesViewModel()
    @StateObject private var extraExpensesViewModel = ExtraExpensesViewModel()
    @StateObject private var remainingPaymentsViewModel = RemainingPaymentsViewModel()

    @State private var isSignedIn = false
    @State private var isSplashFinished = false

    // Initialize Firebase and Google Maps in the init() method
    init() {
        // Configure Firebase
        FirebaseApp.configure()
        
        // Provide Google Maps API Key
        GMSServices.provideAPIKey("AIzaSyD9zEfifIQQFXfw2ajG1XSdQukNRYWWsbc") // Replace with your actual API key
    }

    var body: some Scene {
        WindowGroup {
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
                        .environmentObject(tripBudgetViewModel)
                        .environmentObject(tripExpensesViewModel)
                        .environmentObject(extraExpensesViewModel)
                        .environmentObject(remainingPaymentsViewModel)
                }
            }
        }
    }
}

