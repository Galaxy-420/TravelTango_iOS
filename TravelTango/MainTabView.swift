//
//  MainTabView.swift
//  TravelTango
//
//  Created by Damsara Samarakoon on 2025-04-14.
//
import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            TeamManagementView()
                .tabItem {
                    Image(systemName: "person.3.fill")
                    Text("Team")
                }
            
            GroupChatView()
                .tabItem {
                    Image(systemName: "message.fill")
                    Text("Chat")
                }
            
            DashboardView()
                .tabItem {
                    Image(systemName: "map.fill")
                    Text("Dashboard")
                }
            
            ExpensesManagementView()
                .tabItem {
                    Image(systemName: "creditcard.fill")
                    Text("Expenses")
                }
            
            UserProfileView()
                .tabItem {
                    Image(systemName: "person.crop.circle.fill")
                    Text("Profile")
                }
        }
    }
}

#Preview {
    MainTabView()
}

