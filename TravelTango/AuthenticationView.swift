//
//  AuthenticationView.swift
//  TravelTango
//
//  Created by Nimeshika Mandakini on 2025-04-25.
//
import SwiftUI

struct AuthenticationView: View {
    @ObservedObject var authViewModel: AuthenticationViewModel

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "faceid")
                .resizable()
                .frame(width: 100, height: 100)
                .foregroundColor(.blue)

            Text("Authenticate to Access TravelTango")
                .font(.title2)
                .multilineTextAlignment(.center)

            if let error = authViewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
            }

            Button("Authenticate Now") {
                authViewModel.authenticateUser()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(12)
        }
        .padding()
    }
}


