import Foundation

struct CommunityPost: Identifiable {
    enum Kind { case admin, member, youth }
    enum Status { case approved, pending }

    struct Reactions {
        var lotus: Int
        var namaste: Int
        var comments: Int
    }

    var id: UUID = UUID()
    var authorInitials: String
    var authorName: String
    var kind: Kind
    var body: String
    var imageURL: String?
    var reactions: Reactions
    var createdAt: Date
    var status: Status
    var isPinned: Bool = false
}
