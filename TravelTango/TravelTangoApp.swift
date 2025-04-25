import SwiftUI
import Firebase // Import Firebase
import GoogleMaps // Import Google Maps
import UserNotifications // Import UserNotifications

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

        // Set up notification delegate
        UNUserNotificationCenter.current().delegate = NotificationDelegate()
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

// Notification Delegate
class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Show notification as a banner even when the app is in the foreground
        completionHandler([.banner, .sound])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // Handle notification tap
        print("Notification tapped: \(response.notification.request.content.body)")
        completionHandler()
    }
}

