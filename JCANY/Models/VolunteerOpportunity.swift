import Foundation

struct VolunteerOpportunity: Identifiable, Hashable {
    let id: UUID
    var title: String
    var description: String
    var date: String
    var spotsAvailable: Int
    var isUrgent: Bool
    var category: String

    init(
        id: UUID = UUID(),
        title: String,
        description: String = "",
        date: String = "",
        spotsAvailable: Int = 0,
        isUrgent: Bool = false,
        category: String = ""
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.date = date
        self.spotsAvailable = spotsAvailable
        self.isUrgent = isUrgent
        self.category = category
    }
}
