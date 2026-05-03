import Foundation

struct MonthSponsor: Identifiable {
    var id: UUID = UUID()
    var memberInitials: String
    var memberName: String
    var cause: String
    var amount: Decimal
    var date: Date
    var memorialText: String?
}
