import Foundation

struct Business: Identifiable {
    var id: UUID = UUID()
    var name: String
    var category: BusinessCategory
    var location: String
    var phone: String?
    var website: String?
    var rating: Double
    var hasSanghaDiscount: Bool
    var hasMemberRate: Bool

    enum BusinessCategory: String, CaseIterable {
        case hospitality = "Hospitality"
        case jewelry     = "Jewelry"
        case legal       = "Legal"
        case medical     = "Medical"
        case finance     = "Finance"
        case food        = "Food"

        var icon: String {
            switch self {
            case .hospitality: return "building.2.fill"
            case .jewelry:     return "sparkle"
            case .legal:       return "scalemass.fill"
            case .medical:     return "cross.fill"
            case .finance:     return "banknote.fill"
            case .food:        return "fork.knife"
            }
        }
    }
}
