import Foundation

enum NewsCategory: String, CaseIterable, Identifiable {
    case all         = "All"
    case community   = "Community"
    case events      = "Events"
    case announcements = "Announcements"
    case newsletter  = "Newsletter"

    var id: String { rawValue }
}

struct NewsItem: Identifiable, Hashable {
    let id: UUID
    var title: String
    var summary: String
    var body: String
    var date: Date
    var category: NewsCategory
    var isFeatured: Bool
    var author: String

    init(
        id: UUID = UUID(),
        title: String,
        summary: String = "",
        body: String = "",
        date: Date = Date(),
        category: NewsCategory = .community,
        isFeatured: Bool = false,
        author: String = "JCA NY"
    ) {
        self.id = id
        self.title = title
        self.summary = summary
        self.body = body
        self.date = date
        self.category = category
        self.isFeatured = isFeatured
        self.author = author
    }
}
