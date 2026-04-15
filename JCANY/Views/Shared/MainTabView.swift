import SwiftUI
import SwiftData

struct MainTabView: View {
    @State private var selectedTab: Tab = .home
    @State private var donationVM = DonationFlowViewModel()
    @Query private var users: [User]

    enum Tab: Int, CaseIterable {
        case home, calendar, donate, community, profile
    }

    var currentUser: User? { users.first }

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                HomeView()
            }
            .tabItem {
                Label("Home", systemImage: selectedTab == .home ? "house.fill" : "house")
            }
            .tag(Tab.home)

            NavigationStack {
                CalendarView()
            }
            .tabItem {
                Label("Calendar", systemImage: "calendar")
            }
            .tag(Tab.calendar)

            NavigationStack {
                DonateView()
                    .environment(donationVM)
            }
            .tabItem {
                Label("Donate", systemImage: selectedTab == .donate ? "heart.fill" : "heart")
            }
            .tag(Tab.donate)

            NavigationStack {
                CommunityHubView()
            }
            .tabItem {
                Label("Community", systemImage: selectedTab == .community ? "bubble.left.fill" : "bubble.left")
            }
            .tag(Tab.community)

            NavigationStack {
                ProfileView()
            }
            .tabItem {
                Label("Profile", systemImage: selectedTab == .profile ? "person.fill" : "person")
            }
            .tag(Tab.profile)
        }
        .tint(Color.jcaCrimson)
        .onChange(of: selectedTab) { _, _ in
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        }
    }
}
