import Foundation

enum PathshalaLevel: String, CaseIterable, Identifiable {
    case balVihar    = "Bal Vihar"
    case yuva        = "Yuva"
    case advanced    = "Advanced"

    var id: String { rawValue }
}

struct PathshalaLesson: Identifiable, Hashable {
    let id: UUID
    var title: String
    var subtitle: String
    var level: PathshalaLevel
    var lessonNumber: Int
    var totalLessons: Int
    var progressPercent: Double
    var duration: String
    var nextClass: String

    init(
        id: UUID = UUID(),
        title: String,
        subtitle: String = "",
        level: PathshalaLevel = .balVihar,
        lessonNumber: Int = 1,
        totalLessons: Int = 12,
        progressPercent: Double = 0,
        duration: String = "60 min",
        nextClass: String = ""
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.level = level
        self.lessonNumber = lessonNumber
        self.totalLessons = totalLessons
        self.progressPercent = progressPercent
        self.duration = duration
        self.nextClass = nextClass
    }
}
