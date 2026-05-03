import Foundation
import SwiftData

enum BookFormat: String, Codable {
    case pdf        = "PDF"
    case audio      = "Audio"
    case illustrated = "Illustrated"
}

@Model
final class BookProgress {
    var bookID: String
    var currentPage: Int
    var totalPages: Int
    var isBookmarked: Bool

    init(bookID: String, currentPage: Int = 0, totalPages: Int, isBookmarked: Bool = false) {
        self.bookID = bookID
        self.currentPage = currentPage
        self.totalPages = totalPages
        self.isBookmarked = isBookmarked
    }
}

struct Book: Identifiable {
    var id: String
    var title: String
    var author: String
    var category: BookCategory
    var format: BookFormat
    var language: String
    var totalPages: Int
    var gradientColors: [String]

    enum BookCategory: String {
        case agamSutras    = "Agam Sutras"
        case commentaries  = "Commentaries"
        case children      = "Children"
    }
}
