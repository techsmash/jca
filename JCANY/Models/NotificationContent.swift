import Foundation

// MARK: - Deep-link destination

enum NotificationDestination: Equatable {
    case donate
    case event(id: UUID)
    case calendar
    case liveDarshan
    case donationReceipt(id: UUID)
    case volunteerList
    case pathshalaLesson(id: UUID)
    case gallery
}

// MARK: - Notification content template

struct NotificationContent {
    let type: PushNotificationType
    let title: String
    let body: String
    let ctaText: String
    let destination: NotificationDestination
}

// MARK: - Active push notification (shown in the banner)

struct PushNotification: Identifiable {
    let id = UUID()
    let type: PushNotificationType
    let title: String
    let body: String
    let ctaText: String
    let destination: NotificationDestination
}
