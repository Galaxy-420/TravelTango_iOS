//
//  UserProfileView.swift
//  TravelTango
//
//  Created by Damsara Samarakoon on 2025-04-14.
//
import SwiftUI

struct UserProfileView: View {
    var body: some View {
        VStack {
            Spacer()
            Text("User Profile Page")
                .font(.title)
                .foregroundColor(.gray)
            Spacer()
        }
        .background(Color.white)
        .ignoresSafeArea()
    }
}

#Preview {
    TeamManagementView()
}

