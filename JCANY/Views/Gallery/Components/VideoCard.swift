import SwiftUI

struct GalleryVideo: Identifiable {
    let id = UUID()
    let title: String
    let duration: String
    let thumbnailURL: URL?
}

struct VideoCard: View {
    let video: GalleryVideo

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            // Thumbnail
            CachedAsyncImage(url: video.thumbnailURL) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .opacity(0.85)
                case .empty:
                    LinearGradient(
                        colors: [Color.jcaCreamWarm, Color.jcaGold.opacity(0.3)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .overlay(ProgressView().tint(Color.jcaGold))
                default:
                    LinearGradient(
                        colors: [Color.jcaCrimsonDeep, Color.jcaCrimson],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .overlay(
                        Image(systemName: "photo.fill")
                            .foregroundStyle(.white.opacity(0.4))
                    )
                }
            }
            .aspectRatio(16 / 10, contentMode: .fill)
            .clipped()
            .background(Color.black)

            // Bottom gradient overlay
            LinearGradient(
                colors: [.clear, Color.black.opacity(0.75)],
                startPoint: .center,
                endPoint: .bottom
            )

            // Centered play badge
            Circle()
                .fill(Color.white)
                .frame(width: 38, height: 38)
                .overlay(
                    Image(systemName: "play.fill")
                        .font(.system(size: 14))
                        .foregroundStyle(Color.jcaCrimson)
                        .offset(x: 2)
                )
                .shadow(color: .black.opacity(0.4), radius: 6, y: 2)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)

            // Caption + duration
            HStack(alignment: .bottom) {
                Text(video.title)
                    .font(.fraunces(size: 11, weight: .semibold))
                    .foregroundStyle(.white)
                    .shadow(color: .black, radius: 2, y: 1)
                    .lineLimit(1)
                Spacer(minLength: 4)
                Text(video.duration)
                    .font(.inter(size: 9, weight: .bold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color.black.opacity(0.65))
                    .clipShape(RoundedRectangle(cornerRadius: 4))
            }
            .padding(.horizontal, 8)
            .padding(.bottom, 8)
        }
        .clipShape(RoundedRectangle(cornerRadius: Radii.m))
        .shadowMd()
        .accessibilityLabel("\(video.title), \(video.duration)")
    }
}
