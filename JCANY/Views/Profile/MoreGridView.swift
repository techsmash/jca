import SwiftUI

struct MoreGridView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {
                MoreSection(
                    title: "Sacred & Learning",
                    tiles: [
                        MoreTile(label: "Jinvani",       icon: "book.closed.fill",        color: Color(hex: "#0F766E"),
                                 destination: AnyView(JinvaniLibraryView())),
                        MoreTile(label: "Virtual Tour",  icon: "building.columns.fill",   color: Color(hex: "#4338CA"),
                                 destination: AnyView(VirtualTourView())),
                        MoreTile(label: "Live Darshan",  icon: "video.fill",              color: Color(hex: "#B91C1C"),
                                 destination: AnyView(LiveDarshanView())),
                        MoreTile(label: "Library",       icon: "books.vertical.fill",     color: Color(hex: "#6D28D9"),
                                 destination: AnyView(ComingSoonView(title: "Library", icon: "books.vertical.fill"))),
                    ]
                )

                MoreSection(
                    title: "Community Resources",
                    tiles: [
                        MoreTile(label: "Businesses",    icon: "briefcase.fill",          color: Color(hex: "#B45309"),
                                 destination: AnyView(BusinessDirectoryView())),
                        MoreTile(label: "Restaurants",   icon: "fork.knife",              color: Color(hex: "#047857"),
                                 destination: AnyView(ComingSoonView(title: "Jain Restaurants", icon: "fork.knife"))),
                        MoreTile(label: "Jain Centers",  icon: "mappin.circle.fill",      color: Color(hex: "#0369A1"),
                                 destination: AnyView(JainCentersUSAView())),
                        MoreTile(label: "Book Facility", icon: "calendar.badge.plus",     color: Color(hex: "#7C3AED"),
                                 destination: AnyView(FacilityBookingView())),
                        MoreTile(label: "Classifieds",   icon: "tag.fill",                color: Color(hex: "#B45309"),
                                 destination: AnyView(ComingSoonView(title: "Classifieds", icon: "tag.fill"))),
                        MoreTile(label: "Horoscope",     icon: "star.circle.fill",        color: Color(hex: "#9333EA"),
                                 destination: AnyView(ComingSoonView(title: "Horoscope", icon: "star.circle.fill"))),
                        MoreTile(label: "Recipes",       icon: "frying.pan.fill",         color: Color(hex: "#D97706"),
                                 destination: AnyView(ComingSoonView(title: "Jain Recipes", icon: "frying.pan.fill"))),
                        MoreTile(label: "Youth Connect", icon: "figure.2.arms.open",      color: Color(hex: "#7C3AED"),
                                 destination: AnyView(ComingSoonView(title: "Youth Connect", icon: "figure.2.arms.open"))),
                    ]
                )

                MoreSection(
                    title: "Pravachan & News",
                    tiles: [
                        MoreTile(label: "Pravachan",     icon: "person.wave.2.fill",      color: Color(hex: "#B91C1C"),
                                 destination: AnyView(ComingSoonView(title: "Pravachan", icon: "person.wave.2.fill"))),
                        MoreTile(label: "News",          icon: "newspaper.fill",          color: Color(hex: "#374151"),
                                 destination: AnyView(NewsListView())),
                        MoreTile(label: "Video",         icon: "play.rectangle.fill",     color: Color(hex: "#1D4ED8"),
                                 destination: AnyView(ComingSoonView(title: "Video", icon: "play.rectangle.fill"))),
                        MoreTile(label: "Help",          icon: "questionmark.circle.fill", color: Color(hex: "#6B7280"),
                                 destination: AnyView(ComingSoonView(title: "Help & Support", icon: "questionmark.circle.fill"))),
                    ]
                )
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 20)
        }
        .background(Color.jcaCream.ignoresSafeArea())
        .navigationTitle("Explore More")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Section

private struct MoreSection: View {
    let title: String
    let tiles: [MoreTile]

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 10), count: 4)

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(JCAFont.headline)
                .foregroundStyle(Color.jcaInk)

            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(tiles) { tile in
                    NavigationLink(destination: tile.destination) {
                        MoreTileView(tile: tile)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}

// MARK: - Tile Model & View

private struct MoreTile: Identifiable {
    let id = UUID()
    let label: String
    let icon: String
    let color: Color
    let destination: AnyView
}

private struct MoreTileView: View {
    let tile: MoreTile

    var body: some View {
        VStack(spacing: 6) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(tile.color.opacity(0.1))
                    .frame(width: 48, height: 48)
                Image(systemName: tile.icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundStyle(tile.color)
            }
            Text(tile.label)
                .font(.inter(size: 10, weight: .medium))
                .foregroundStyle(Color.jcaInkSoft)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(Color.jcaPaper)
        .clipShape(RoundedRectangle(cornerRadius: Radii.s))
        .overlay(
            RoundedRectangle(cornerRadius: Radii.s)
                .stroke(Color.jcaBorder, lineWidth: 0.5)
        )
        .accessibilityLabel(tile.label)
        .accessibilityAddTraits(.isButton)
    }
}

#Preview {
    NavigationStack {
        MoreGridView()
    }
}
