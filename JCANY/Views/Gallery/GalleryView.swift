import SwiftUI

struct GalleryView: View {
    @State private var selectedSegment: GallerySegment = .all
    @State private var selectedVideo: GalleryVideo?
    @Environment(\.openURL) private var openURL

    enum GallerySegment: String, CaseIterable {
        case all    = "All"
        case videos = "Videos"
        case tour   = "360°"
    }

    // MARK: - Seed data

    private let featuredEvents: [GalleryFeaturedEvent] = [
        GalleryFeaturedEvent(
            title: "Mahavir Janma Kalyanak",
            dateLabel: "April 26, 2025",
            photoCount: 48,
            imageURL: JCAImageURLs.mjk2025
        ),
        GalleryFeaturedEvent(
            title: "Paryushan Maha Parv",
            dateLabel: "Sept 2025",
            photoCount: 124,
            imageURL: JCAImageURLs.paryushan
        ),
        GalleryFeaturedEvent(
            title: "Annual GB Meeting",
            dateLabel: "Dec 14, 2025",
            photoCount: 32,
            imageURL: JCAImageURLs.gbMeeting
        ),
        GalleryFeaturedEvent(
            title: "Diwali Celebration",
            dateLabel: "Nov 2025",
            photoCount: 67,
            imageURL: JCAImageURLs.mjk2025
        )
    ]

    private let shrineAlbums: [GalleryAlbum] = [
        GalleryAlbum(name: "Mahavir Swami",   subtitle: "Main Sanctum",    photoCount: 24, imageURL: JCAImageURLs.mahavirTemple),
        GalleryAlbum(name: "Adinathji Temple", subtitle: "First Tirthankar", photoCount: 18, imageURL: JCAImageURLs.adinathTemple),
        GalleryAlbum(name: "Upashray Hall",   subtitle: "Meditation Hall",  photoCount: 22, imageURL: JCAImageURLs.upashrayHall),
        GalleryAlbum(name: "Shrimad Hall",    subtitle: "Cultural Center",  photoCount: 16, imageURL: JCAImageURLs.shrimadHall),
        GalleryAlbum(name: "Dadawadi Shrine", subtitle: "Ancestral Shrine", photoCount: 14, imageURL: JCAImageURLs.dadawadi),
        GalleryAlbum(name: "Art Gallery",     subtitle: "Ashtapad & Art",   photoCount: 32, imageURL: JCAImageURLs.artGallery)
    ]

    private let videos: [GalleryVideo] = [
        GalleryVideo(title: "Mangal Aarti",      duration: "5:42",  thumbnailURL: JCAImageURLs.mahavirTemple),
        GalleryVideo(title: "Acharya Lecture",   duration: "42:18", thumbnailURL: JCAImageURLs.upashrayHall),
        GalleryVideo(title: "MJK Highlights",    duration: "12:03", thumbnailURL: JCAImageURLs.mjk2025),
        GalleryVideo(title: "Paryushan Prayers", duration: "8:27",  thumbnailURL: JCAImageURLs.paryushan)
    ]

    private let masonryPhotos: [MasonryPhoto] = [
        MasonryPhoto(caption: "JCA Temple",       imageURL: JCAImageURLs.jcaTemple,     heightClass: .tall),
        MasonryPhoto(caption: "JCA Lobby",        imageURL: JCAImageURLs.jcaLobby,      heightClass: .short),
        MasonryPhoto(caption: "Shrimad Hall",     imageURL: JCAImageURLs.shrimadHall,   heightClass: .medium),
        MasonryPhoto(caption: "Adinath Temple",   imageURL: JCAImageURLs.adinathTemple, heightClass: .tall),
        MasonryPhoto(caption: "Asthapad",         imageURL: JCAImageURLs.asthapad,      heightClass: .short),
        MasonryPhoto(caption: "Dadawadi",         imageURL: JCAImageURLs.dadawadi,      heightClass: .medium),
        MasonryPhoto(caption: "Art Gallery",      imageURL: JCAImageURLs.artGallery,    heightClass: .medium),
        MasonryPhoto(caption: "Mahavir Swami",    imageURL: JCAImageURLs.mahavirTemple, heightClass: .tall)
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 4) {
                    HStack(spacing: 0) {
                        Text("Gallery")
                            .font(.fraunces(size: 28, weight: .semibold))
                            .foregroundStyle(Color.jcaInk)
                        Text(" · moments.")
                            .font(.frauncesItalic(size: 28))
                            .foregroundStyle(Color.jcaCrimson)
                        Spacer()
                    }
                    Text("Photographs and memories from JCA NY")
                        .font(JCAFont.body)
                        .foregroundStyle(Color.jcaMuted)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.horizontal, 24)
                .padding(.top, 8)
                .padding(.bottom, 16)

                // Segment tabs
                HStack(spacing: 8) {
                    ForEach(GallerySegment.allCases, id: \.self) { seg in
                        Button {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                selectedSegment = seg
                            }
                        } label: {
                            Text(seg.rawValue)
                                .font(.inter(size: 13, weight: selectedSegment == seg ? .semibold : .regular))
                                .foregroundStyle(selectedSegment == seg ? Color.jcaCrimson : Color.jcaMuted)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(
                                    Capsule()
                                        .fill(selectedSegment == seg ? Color.jcaCrimson.opacity(0.1) : Color.clear)
                                )
                        }
                        .buttonStyle(.plain)
                    }
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 16)

                Group {
                    switch selectedSegment {
                    case .all:
                        allContent
                    case .videos:
                        videoContent
                    case .tour:
                        tourContent
                    }
                }
                .padding(.bottom, 40)
            }
        }
        .background(Color.jcaCream.ignoresSafeArea())
        .navigationTitle("Gallery")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(item: $selectedVideo) { video in
            VideoPlayerView(title: video.title, thumbnailURL: video.thumbnailURL)
        }
    }

    // MARK: - All tab

    private var allContent: some View {
        VStack(spacing: 24) {
            // Hero banner
            GalleryHeroBanner()

            // Stats strip
            GalleryStatsStrip()

            // Featured Events
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Featured Events")
                            .font(JCAFont.headline)
                            .foregroundStyle(Color.jcaInk)
                        Text("Latest albums")
                            .font(JCAFont.caption)
                            .foregroundStyle(Color.jcaMuted)
                    }
                    Spacer()
                }
                .padding(.horizontal, 24)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(featuredEvents) { event in
                            GalleryEventCard(event: event)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 4)
                }
            }

            // Explore Shrines
            VStack(alignment: .leading, spacing: 10) {
                Text("Explore Shrines")
                    .font(JCAFont.headline)
                    .foregroundStyle(Color.jcaInk)
                    .padding(.horizontal, 24)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(shrineAlbums) { album in
                            GalleryAlbumCard(album: album)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 4)
                }
            }

            // Video Library
            videoLibrarySection

            // Masonry photos
            VStack(alignment: .leading, spacing: 12) {
                Text("Photos")
                    .font(JCAFont.headline)
                    .foregroundStyle(Color.jcaInk)
                    .padding(.horizontal, 24)

                MasonryPhotoGrid(photos: masonryPhotos)
            }
        }
    }

    // MARK: - Videos tab

    private var videoContent: some View {
        VStack(alignment: .leading, spacing: 12) {
            videoLibrarySection
        }
    }

    // MARK: - 360° tab

    private var tourContent: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Explore Shrines")
                .font(JCAFont.headline)
                .foregroundStyle(Color.jcaInk)
                .padding(.horizontal, 24)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(shrineAlbums) { album in
                        GalleryAlbumCard(album: album)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 4)
            }
        }
        .padding(.top, 8)
    }

    // MARK: - Shared video library section

    private var videoLibrarySection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Video Library")
                    .font(JCAFont.headline)
                    .foregroundStyle(Color.jcaInk)
                Spacer()
                Button {
                    openURL(JCAImageURLs.youtubeChannel)
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "play.rectangle.fill")
                            .font(.system(size: 13))
                            .foregroundStyle(.red)
                        Text("YouTube ›")
                            .font(.inter(size: 12, weight: .medium))
                            .foregroundStyle(Color.jcaCrimson)
                    }
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 24)

            let columns = [GridItem(.flexible(), spacing: 8), GridItem(.flexible(), spacing: 8)]
            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(videos) { video in
                    VideoCard(video: video)
                        .onTapGesture { selectedVideo = video }
                }
            }
            .padding(.horizontal, 24)
        }
    }
}

#Preview {
    NavigationStack {
        GalleryView()
    }
}
