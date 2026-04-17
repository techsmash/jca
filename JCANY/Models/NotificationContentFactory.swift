import Foundation

enum NotificationContentFactory {
    static func build(for type: PushNotificationType) -> NotificationContent {
        switch type {

        case .birthday:
            return NotificationContent(
                type: type,
                title: "🎂 Happy Birthday!",
                body: "Warmest wishes from JCA. May this year bring you peace, prosperity & dharma.",
                ctaText: "Tap to donate in gratitude ›",
                destination: .donate
            )

        case .eventReminder:
            return NotificationContent(
                type: type,
                title: "🙏 Event Reminder",
                body: "Mahavir Janma Kalyanak is on 26th April. Please RSVP now.",
                ctaText: "Tap to RSVP ›",
                destination: .event(id: MockEventIDs.mjk)
            )

        case .parvaDay:
            return NotificationContent(
                type: type,
                title: "🪷 Parva Day Tomorrow",
                body: "Ayambil Oli begins tomorrow. Prepare yourself for 9 days of austerity.",
                ctaText: "View calendar ›",
                destination: .calendar
            )

        case .aartiReminder:
            return NotificationContent(
                type: type,
                title: "🪔 Sandhya Aarti in 15 min",
                body: "Join live darshan for evening aarti at Mahavir Swami Temple.",
                ctaText: "Watch live ›",
                destination: .liveDarshan
            )

        case .donationReceived:
            return NotificationContent(
                type: type,
                title: "💝 Donation Received",
                body: "Thank you! Your $1,251 donation for Bhojanshala has been processed.",
                ctaText: "View receipt ›",
                destination: .donationReceipt(id: MockEventIDs.donation)
            )

        case .volunteerOpportunity:
            return NotificationContent(
                type: type,
                title: "🤝 Seva Opportunity",
                body: "Bhojanshala needs helpers this Sunday. Sign up to serve your sangha.",
                ctaText: "Sign up now ›",
                destination: .volunteerList
            )

        case .pathshalaClass:
            return NotificationContent(
                type: type,
                title: "📚 Pathshala in 30 min",
                body: "Lesson 8: The 5 Mahavratas — See you in Upashray Hall.",
                ctaText: "Review lesson ›",
                destination: .pathshalaLesson(id: MockEventIDs.lesson)
            )

        case .newPhotos:
            return NotificationContent(
                type: type,
                title: "📸 New Photos Added",
                body: "48 new photos from Paryushan Parv 2025 are now in the gallery.",
                ctaText: "View gallery ›",
                destination: .gallery
            )
        }
    }
}

// Fixed UUIDs so destinations work consistently across the demo
private enum MockEventIDs {
    static let mjk      = UUID(uuidString: "A1B2C3D4-0001-0001-0001-000000000001")!
    static let donation = UUID(uuidString: "A1B2C3D4-0002-0002-0002-000000000002")!
    static let lesson   = UUID(uuidString: "A1B2C3D4-0003-0003-0003-000000000003")!
}
