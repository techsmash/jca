import SwiftUI

enum AppTab: Int {
    case home = 0, calendar = 1, donate = 2, community = 3, profile = 4
}

enum HomeRoute: Hashable {
    case liveDarshan
    case eventDetail(id: UUID)
}

enum CommunityRoute: Hashable {
    case gallery
    case liveDarshan
    case virtualTour
    case pathshala
    case volunteer
    case news
    case youthConnect
}

@Observable
final class AppState {
    var selectedTab: AppTab = .home
    var homeNavPath = NavigationPath()
    var communityNavPath = NavigationPath()

    func navigate(to destination: NotificationDestination) {
        switch destination {
        case .donate:
            selectedTab = .donate

        case .event(let id):
            selectedTab = .home
            if homeNavPath.count > 0 { homeNavPath.removeLast(homeNavPath.count) }
            homeNavPath.append(HomeRoute.eventDetail(id: id))

        case .calendar:
            selectedTab = .calendar

        case .liveDarshan:
            selectedTab = .home
            if homeNavPath.count > 0 { homeNavPath.removeLast(homeNavPath.count) }
            homeNavPath.append(HomeRoute.liveDarshan)

        case .donationReceipt:
            selectedTab = .donate

        case .volunteerList:
            selectedTab = .community
            if communityNavPath.count > 0 { communityNavPath.removeLast(communityNavPath.count) }
            communityNavPath.append(CommunityRoute.volunteer)

        case .pathshalaLesson:
            selectedTab = .community
            if communityNavPath.count > 0 { communityNavPath.removeLast(communityNavPath.count) }
            communityNavPath.append(CommunityRoute.pathshala)

        case .gallery:
            selectedTab = .community
            if communityNavPath.count > 0 { communityNavPath.removeLast(communityNavPath.count) }
            communityNavPath.append(CommunityRoute.gallery)
        }
    }
}
