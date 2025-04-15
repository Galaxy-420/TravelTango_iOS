import SwiftUI

@main
struct TravelTangoApp: App {
    @StateObject var tripManager = TripManager()

    var body: some Scene {
        WindowGroup {
            DashboardView()
                .environmentObject(tripManager)
        }
    }
}
