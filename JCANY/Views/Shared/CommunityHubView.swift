import SwiftUI

struct CommunityHubView: View {
    private let items: [HubItem] = [
        HubItem(title: "Gallery",      subtitle: "Photos & videos",   icon: "photo.stack.fill",         color: Color(hex: "#B45309"), route: .gallery),
        HubItem(title: "Live Darshan", subtitle: "Watch live",         icon: "video.fill",               color: Color(hex: "#B91C1C"), route: .liveDarshan),
        HubItem(title: "Virtual Tour", subtitle: "Explore the temple", icon: "building.columns.fill",    color: Color(hex: "#4338CA"), route: .virtualTour),
        HubItem(title: "Pathshala",    subtitle: "Jain education",     icon: "book.closed.fill",         color: Color(hex: "#0F766E"), route: .pathshala),
        HubItem(title: "Volunteer",    subtitle: "Seva opportunities",  icon: "hands.sparkles.fill",     color: Color(hex: "#C2410C"), route: .volunteer),
        HubItem(title: "News",         subtitle: "Latest updates",     icon: "newspaper.fill",           color: Color(hex: "#374151"), route: .news),
        HubItem(title: "Youth Connect", subtitle: "Coming soon",       icon: "figure.2.arms.open",       color: Color(hex: "#7C3AED"), route: .youthConnect),
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(
                columns: [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)],
                spacing: 12
            ) {
                ForEach(items) { item in
                    NavigationLink(value: item.route) {
                        HubTile(item: item)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)
            .padding(.bottom, 32)
        }
        .background(Color.jcaCream.ignoresSafeArea())
    }
}

// MARK: - Hub Data Model

private struct HubItem: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let route: CommunityRoute
}

// MARK: - Tile View

private struct HubTile: View {
    let item: HubItem

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: Radii.base)
                    .fill(Color.jcaPaper)
                    .overlay(
                        RoundedRectangle(cornerRadius: Radii.base)
                            .stroke(Color.jcaBorder, lineWidth: 0.5)
                    )
                    .shadowSm()

                VStack(alignment: .leading, spacing: 10) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(item.color.opacity(0.1))
                            .frame(width: 44, height: 44)
                        Image(systemName: item.icon)
                            .font(.system(size: 20, weight: .medium))
                            .foregroundStyle(item.color)
                    }

                    VStack(alignment: .leading, spacing: 3) {
                        Text(item.title)
                            .font(JCAFont.title)
                            .foregroundStyle(Color.jcaInk)
                            .lineLimit(1)
                        Text(item.subtitle)
                            .font(JCAFont.caption)
                            .foregroundStyle(Color.jcaMuted)
                            .lineLimit(1)
                    }
                }
                .padding(14)
            }
        }
        .accessibilityLabel(item.title)
        .accessibilityHint(item.subtitle)
    }
}

#Preview {
    NavigationStack {
        CommunityHubView()
            .navigationTitle("Community")
            .navigationBarTitleDisplayMode(.inline)
    }
}
