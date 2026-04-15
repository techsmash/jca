import Foundation
import SwiftData

@Model
final class User {
    var id: UUID
    var name: String
    var email: String
    var memberID: String
    var memberTier: String
    var avatarInitial: String
    var totalDonated: Decimal
    var sevaHours: Int
    @Relationship(deleteRule: .cascade) var familyMembers: [FamilyMember]
    @Relationship(deleteRule: .cascade) var savedPaymentMethods: [PaymentMethod]
    @Relationship(deleteRule: .cascade) var donationHistory: [Donation]

    init(
        id: UUID = UUID(),
        name: String,
        email: String,
        memberID: String,
        memberTier: String,
        avatarInitial: String,
        totalDonated: Decimal = 0,
        sevaHours: Int = 0
    ) {
        self.id = id
        self.name = name
        self.email = email
        self.memberID = memberID
        self.memberTier = memberTier
        self.avatarInitial = avatarInitial
        self.totalDonated = totalDonated
        self.sevaHours = sevaHours
        self.familyMembers = []
        self.savedPaymentMethods = []
        self.donationHistory = []
    }
}
