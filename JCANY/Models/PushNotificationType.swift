import SwiftUI

enum PushNotificationType: CaseIterable {
    case birthday
    case eventReminder
    case parvaDay
    case aartiReminder
    case donationReceived
    case volunteerOpportunity
    case pathshalaClass
    case newPhotos

    var emoji: String {
        switch self {
        case .birthday:            return "🎂"
        case .eventReminder:       return "🔔"
        case .parvaDay:            return "🪷"
        case .aartiReminder:       return "🪔"
        case .donationReceived:    return "💝"
        case .volunteerOpportunity:return "🤝"
        case .pathshalaClass:      return "📚"
        case .newPhotos:           return "📸"
        }
    }

    var displayName: String {
        switch self {
        case .birthday:            return "Birthday Wishes"
        case .eventReminder:       return "Event Reminder"
        case .parvaDay:            return "Parva Day"
        case .aartiReminder:       return "Aarti Reminder"
        case .donationReceived:    return "Donation Received"
        case .volunteerOpportunity:return "Volunteer Opportunity"
        case .pathshalaClass:      return "Pathshala Class"
        case .newPhotos:           return "New Photos"
        }
    }

    var description: String {
        switch self {
        case .birthday:            return "Sent on a member's birthday"
        case .eventReminder:       return "Upcoming event RSVP alert"
        case .parvaDay:            return "Festival day approaching"
        case .aartiReminder:       return "Live aarti in 15 minutes"
        case .donationReceived:    return "Payment confirmation"
        case .volunteerOpportunity:return "Seva signup available"
        case .pathshalaClass:      return "Class starting in 30 minutes"
        case .newPhotos:           return "New album added to gallery"
        }
    }

    /// Gradient colors for the card icon background
    var gradientColors: [Color] {
        switch self {
        case .birthday:
            return [Color(hex: "#ffe1eb"), Color(hex: "#ffc2d4")]
        case .eventReminder:
            return [Color(hex: "#fde8c4"), Color(hex: "#fbd891")]
        case .parvaDay:
            return [Color(hex: "#e8d4f5"), Color(hex: "#c9a0ec")]
        case .aartiReminder:
            return [Color(hex: "#ffebc7"), Color(hex: "#ffd080")]
        case .donationReceived:
            return [Color(hex: "#d4f5dc"), Color(hex: "#a0e6b0")]
        case .volunteerOpportunity:
            return [Color(hex: "#d4e8f5"), Color(hex: "#a0c9e6")]
        case .pathshalaClass:
            return [Color(hex: "#fcebd4"), Color(hex: "#f8c897")]
        case .newPhotos:
            return [Color(hex: "#e8e0d0"), Color(hex: "#c9b896")]
        }
    }
}
