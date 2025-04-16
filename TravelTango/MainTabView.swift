import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var tripManager: TripManager
    @State private var selectedTab = 2 // Dashboard is the default

    var body: some View {
        TabView(selection: $selectedTab) {
            
            // Team Management
            NavigationStack {
                TeamManagementView()
            }
            .tabItem {
                Image(systemName: "person.3.fill")
                Text("Team")
            }
            .tag(0)
            
            // Chat
            NavigationStack {
                GroupChatView()
            }
            .tabItem {
                Image(systemName: "message.fill")
                Text("Chat")
            }
            .tag(1)
            
            // Dashboard
            NavigationStack {
                DashboardView()
                    .environmentObject(tripManager)
            }
            .tabItem {
                Image(systemName: "map.fill")
                Text("Dashboard")
            }
            .tag(2)
            
            // Expenses
            NavigationStack {
                ExpensesManagementView()
            }
            .tabItem {
                Image(systemName: "creditcard.fill")
                Text("Expenses")
            }
            .tag(3)
            
            // Profile
            NavigationStack {
                UserProfileView()
            }
            .tabItem {
                Image(systemName: "person.crop.circle.fill")
                Text("Profile")
            }
            .tag(4)
        }
    }
}
