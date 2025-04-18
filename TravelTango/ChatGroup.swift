//
//  ChatGroup.swift
//  TravelTango
//
//  Created by Damsara Samarakoon on 2025-04-17.
//
import Foundation

struct ChatGroup: Identifiable, Hashable {
    let id: UUID
    var name: String
    var imageName: String? // Optional group image
    var memberIDs: [UUID]
    var messages: [ChatMessage]

    init(id: UUID = UUID(), name: String, memberIDs: [UUID], messages: [ChatMessage] = [], imageName: String? = nil) {
        self.id = id
        self.name = name
        self.memberIDs = memberIDs
        self.messages = messages
        self.imageName = imageName
    }

    static func == (lhs: ChatGroup, rhs: ChatGroup) -> Bool {
        return lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}


