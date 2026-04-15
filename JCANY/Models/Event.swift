import Foundation

struct Event: Identifiable, Hashable {
    let id: UUID
    var title: String
    var subtitle: String
    var date: Date
    var location: String
    var description: String
    var category: String
    var isRSVPed: Bool

    init(
        id: UUID = UUID(),
        title: String,
        subtitle: String = "",
        date: Date,
        location: String = "",
        description: String = "",
        category: String = "",
        isRSVPed: Bool = false
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.date = date
        self.location = location
        self.description = description
        self.category = category
        self.isRSVPed = isRSVPed
    }
}

struct DonationCategory: Identifiable, Hashable {
    let id: UUID
    var name: String
    var description: String
    var iconName: String
    var defaultAmount: Decimal
    var isBhojanshala: Bool

    init(
        id: UUID = UUID(),
        name: String,
        description: String = "",
        iconName: String = "heart.fill",
        defaultAmount: Decimal = 101,
        isBhojanshala: Bool = false
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.iconName = iconName
        self.defaultAmount = defaultAmount
        self.isBhojanshala = isBhojanshala
    }
}
