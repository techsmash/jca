import Foundation

struct LiveStream: Identifiable, Hashable {
    let id: UUID
    var title: String
    var subtitle: String
    var isLive: Bool
    var viewerCount: Int
    var scheduleTime: String?

    init(
        id: UUID = UUID(),
        title: String,
        subtitle: String = "",
        isLive: Bool = false,
        viewerCount: Int = 0,
        scheduleTime: String? = nil
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.isLive = isLive
        self.viewerCount = viewerCount
        self.scheduleTime = scheduleTime
    }
}

struct AartiSchedule: Identifiable, Hashable {
    let id: UUID
    var name: String
    var time: String
    var isNext: Bool

    init(id: UUID = UUID(), name: String, time: String, isNext: Bool = false) {
        self.id = id
        self.name = name
        self.time = time
        self.isNext = isNext
    }
}
