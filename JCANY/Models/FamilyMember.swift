import Foundation
import SwiftData

@Model
final class FamilyMember {
    var id: UUID
    var name: String
    var relation: String
    var dateOfBirth: Date
    var nakshatra: String?
    var gotra: String?
    var avatarInitial: String

    init(
        id: UUID = UUID(),
        name: String,
        relation: String,
        dateOfBirth: Date,
        nakshatra: String? = nil,
        gotra: String? = nil,
        avatarInitial: String
    ) {
        self.id = id
        self.name = name
        self.relation = relation
        self.dateOfBirth = dateOfBirth
        self.nakshatra = nakshatra
        self.gotra = gotra
        self.avatarInitial = avatarInitial
    }
}
