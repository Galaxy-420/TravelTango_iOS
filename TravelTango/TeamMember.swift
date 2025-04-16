//
//  TeamMember.swift
//  TravelTango
//
//  Created by Damsara Samarakoon on 2025-04-16.
//
import Foundation

struct TeamMember: Identifiable, Equatable {
    let id: UUID
    var name: String
    var email: String
    var joinedDate: Date
    var phone: String?

    init(id: UUID = UUID(), name: String, email: String, phone: String? = nil, joinedDate: Date = Date()) {
        self.id = id
        self.name = name
        self.email = email
        self.phone = phone
        self.joinedDate = joinedDate
    }
}

