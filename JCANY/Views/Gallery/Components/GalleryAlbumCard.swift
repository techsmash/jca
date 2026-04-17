import SwiftUI

struct GalleryAlbum: Identifiable {
    let id = UUID()
    let name: String
    let subtitle: String
    let photoCount: Int
    let imageURL: URL?
}

struct GalleryAlbumCard: View {
    let album: GalleryAlbum

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Image
            CachedAsyncImage(url: album.imageURL) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
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
            .frame(width: 130, height: 90)
            .clipped()

            VStack(alignment: .leading, spacing: 2) {
                Text(album.name)
                    .font(.fraunces(size: 12, weight: .semibold))
                    .foregroundStyle(Color.jcaInk)
                    .lineLimit(1)
                Text("\(album.photoCount) photos")
                    .font(.inter(size: 10))
                    .foregroundStyle(Color.jcaMuted)
            }
            .padding(8)
        }
        .frame(width: 130)
        .background(Color.jcaPaper)
        .clipShape(RoundedRectangle(cornerRadius: Radii.m))
        .overlay(
            RoundedRectangle(cornerRadius: Radii.m)
                .stroke(Color.jcaBorder, lineWidth: 0.5)
        )
        .shadowSm()
    }
}
