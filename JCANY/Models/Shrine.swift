import Foundation

struct Shrine: Identifiable, Hashable {
    let id: UUID
    var name: String
    var subtitle: String
    var description: String
    var romanNumeral: String
    var iconDescription: String

    init(
        id: UUID = UUID(),
        name: String,
        subtitle: String = "",
        description: String = "",
        romanNumeral: String = "i",
        iconDescription: String = ""
    ) {
        self.id = id
        self.name = name
        self.subtitle = subtitle
        self.description = description
        self.romanNumeral = romanNumeral
        self.iconDescription = iconDescription
    }
}
