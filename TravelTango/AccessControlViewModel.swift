import Foundation
import SwiftUI

class AccessControlViewModel: ObservableObject {
    @Published var members: [TeamMember] = [
        TeamMember(name: "Mandakini", email: "mandakini@example.com", hasExpenseAccess: true),
        TeamMember(name: "Sam", email: "sam@example.com", hasExpenseAccess: false),
        TeamMember(name: "Damsara", email: "damsara@example.com", hasExpenseAccess: false)
    ]

    @Published var allowAll: Bool = false {
        didSet {
            if allowAll {
                for i in members.indices {
                    members[i].hasExpenseAccess = true
                }
            }
        }
    }

    func toggleAccess(for member: TeamMember) {
        if let index = members.firstIndex(where: { $0.id == member.id }) {
            var updatedMember = members[index]
            updatedMember.hasExpenseAccess.toggle()
            members[index] = updatedMember
        }
    }
}
