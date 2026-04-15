import Foundation
import SwiftData

enum PaymentType: String, Codable, CaseIterable {
    case creditCard  = "creditCard"
    case debitCard   = "debitCard"
    case applePay    = "applePay"
    case googlePay   = "googlePay"
    case payPal      = "payPal"
    case zelle       = "zelle"
    case ach         = "ach"

    var displayName: String {
        switch self {
        case .creditCard:  return "Credit / Debit"
        case .debitCard:   return "Debit Card"
        case .applePay:    return "Apple Pay"
        case .googlePay:   return "Google Pay"
        case .payPal:      return "PayPal"
        case .zelle:       return "Zelle"
        case .ach:         return "Bank Transfer"
        }
    }

    var icon: String {
        switch self {
        case .creditCard, .debitCard: return "creditcard.fill"
        case .applePay:  return "apple.logo"
        case .googlePay: return "g.circle.fill"
        case .payPal:    return "p.circle.fill"
        case .zelle:     return "z.circle.fill"
        case .ach:       return "building.columns.fill"
        }
    }
}

@Model
final class PaymentMethod {
    var id: UUID
    var type: PaymentType
    var last4: String?
    var brand: String?
    var expiryMonth: Int?
    var expiryYear: Int?
    var cardholderName: String?
    var isDefault: Bool

    init(
        id: UUID = UUID(),
        type: PaymentType,
        last4: String? = nil,
        brand: String? = nil,
        expiryMonth: Int? = nil,
        expiryYear: Int? = nil,
        cardholderName: String? = nil,
        isDefault: Bool = false
    ) {
        self.id = id
        self.type = type
        self.last4 = last4
        self.brand = brand
        self.expiryMonth = expiryMonth
        self.expiryYear = expiryYear
        self.cardholderName = cardholderName
        self.isDefault = isDefault
    }

    var displayString: String {
        if let brand = brand, let last4 = last4 {
            return "\(brand) ••••\(last4)"
        }
        return type.displayName
    }

    var expiryString: String {
        guard let month = expiryMonth, let year = expiryYear else { return "" }
        return String(format: "%02d/%02d", month, year % 100)
    }
}
