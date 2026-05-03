import Foundation

struct Facility: Identifiable {
    var id: UUID = UUID()
    var name: String
    var capacity: Int
    var memberRate: Decimal
    var publicRate: Decimal
    var description: String
    var iconName: String
}
