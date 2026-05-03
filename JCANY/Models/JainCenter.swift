import Foundation
import CoreLocation

struct JainCenter: Identifiable {
    var id: UUID = UUID()
    var name: String
    var address: String
    var city: String
    var state: String
    var latitude: Double
    var longitude: Double
    var hours: String

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    var fullAddress: String { "\(address), \(city), \(state)" }
}

struct VegRestaurant: Identifiable {
    var id: UUID = UUID()
    var name: String
    var address: String
    var city: String
    var kind: Kind
    var rating: Double
    var latitude: Double
    var longitude: Double

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    enum Kind: String {
        case pureVeg        = "Pure Veg"
        case jainFriendly   = "Jain-Friendly"

        var badge: String {
            switch self {
            case .pureVeg:      return "🌿 Pure Veg"
            case .jainFriendly: return "🙏 Jain-Friendly"
            }
        }
    }
}
