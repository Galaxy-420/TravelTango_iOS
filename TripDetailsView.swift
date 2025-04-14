//
//  TripDetailsView.swift
//  TravelTango
//
//  Created by Damsara Samarakoon on 2025-04-14.
//
import SwiftUI

struct TripDetailsView: View {
    var body: some View {
        VStack {
            Spacer()
            Text("Trip Details Page")
                .font(.title)
                .foregroundColor(.gray)
            Spacer()
        }
        .background(Color.white)
        .ignoresSafeArea()
    }
}

#Preview {
    TripDetailsView()
}
