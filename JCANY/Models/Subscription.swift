import Foundation

struct Subscription: Identifiable {
    var id: UUID = UUID()
    var causeName: String
    var causeIcon: String
    var frequency: Frequency
    var amount: Decimal
    var startDate: Date
    var nextChargeDate: Date
    var lifetimeTotal: Decimal
    var status: Status

    enum Frequency: String {
        case daily = "Daily"
        case monthly = "Monthly"
        case annual = "Annual"

        var shortSuffix: String {
            switch self {
            case .daily:   return "/day"
            case .monthly: return "/mo"
            case .annual:  return "/yr"
            }
        }
    }

    enum Status: String {
        case active = "Active"
        case paused = "Paused"
    }
}
