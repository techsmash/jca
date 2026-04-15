import Foundation
import Observation
import SwiftData

@Observable
final class ProfileViewModel {
    var isAddingFamilyMember: Bool = false
    var editingFamilyMember: FamilyMember? = nil
    var showingPaymentMethods: Bool = false
    var showingDonationHistory: Bool = false
}
