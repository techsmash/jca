import SwiftUI
import SwiftData

struct MainTabView: View {
    @Environment(AppState.self) private var appState
    @State private var donationVM = DonationFlowViewModel()
    @Query private var users: [User]

    var currentUser: User? { users.first }

    var body: some View {
        @Bindable var bindableState = appState
        @Bindable var bindableVM = donationVM
        ZStack(alignment: .top) {
            TabView(selection: $bindableState.selectedTab) {

                // MARK: Home
                NavigationStack(path: $bindableState.homeNavPath) {
                    HomeView()
                        .navigationDestination(for: HomeRoute.self) { route in
                            switch route {
                            case .liveDarshan:
                                LiveDarshanView()
                            case .eventDetail(let id):
                                EventDetailView(
                                    event: MockDataProvider.events.first { $0.id == id }
                                        ?? MockDataProvider.events[0]
                                )
                            }
                        }
                }
                .tabItem {
                    Label("Home", systemImage: appState.selectedTab == .home ? "house.fill" : "house")
                }
                .tag(AppTab.home)

                // MARK: Calendar
                NavigationStack {
                    CalendarView()
                }
                .tabItem {
                    Label("Calendar", systemImage: "calendar")
                }
                .tag(AppTab.calendar)

                // MARK: Donate
                NavigationStack(path: $bindableVM.navigationPath) {
                    DonateView()
                        .environment(donationVM)
                }
                .tabItem {
                    Label("Donate", systemImage: appState.selectedTab == .donate ? "heart.fill" : "heart")
                }
                .tag(AppTab.donate)

                // MARK: Community
                NavigationStack(path: $bindableState.communityNavPath) {
                    CommunityView()
                        .navigationDestination(for: CommunityRoute.self) { route in
                            switch route {
                            case .gallery:
                                GalleryView()
                            case .liveDarshan:
                                LiveDarshanView()
                            case .virtualTour:
                                VirtualTourView()
                            case .pathshala:
                                PathshalaView()
                            case .volunteer:
                                VolunteerView()
                            case .news:
                                NewsListView()
                            case .youthConnect:
                                ComingSoonView(title: "Youth Connect", icon: "figure.2.arms.open")
                            }
                        }
                }
                .tabItem {
                    Label("Community", systemImage: appState.selectedTab == .community ? "bubble.left.fill" : "bubble.left")
                }
                .tag(AppTab.community)

                // MARK: Profile
                NavigationStack {
                    ProfileView()
                }
                .tabItem {
                    Label("Profile", systemImage: appState.selectedTab == .profile ? "person.crop.circle.fill" : "person.crop.circle")
                }
                .tag(AppTab.profile)
            }
            .tint(Color.jcaCrimson)
            .onChange(of: appState.selectedTab) { _, _ in
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
            }

            // MARK: Push notification banner
            PushNotificationBanner()
                .animation(.spring(response: 0.55, dampingFraction: 0.7),
                           value: PushNotificationService.shared.active?.id)
        }
    }
}
