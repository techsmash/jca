import Foundation
import Observation
import SwiftData

@Observable
final class HomeViewModel {
    var panchang: PanchangData = PanchangService.today()
    var events: [Event] = MockDataProvider.events
    var quickActions: [(title: String, subtitle: String, icon: String, isGold: Bool)] = [
        ("Live Darshan", "Streaming now", "video.fill", false),
        ("Donate", "Support the temple", "heart.fill", true),
        ("Calendar", "Upcoming events", "calendar", false),
        ("Virtual Tour", "Explore shrines", "building.columns", true)
    ]
}
