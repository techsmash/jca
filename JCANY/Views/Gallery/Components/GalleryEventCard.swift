import SwiftUI

struct GalleryFeaturedEvent: Identifiable {
    let id = UUID()
    let title: String
    let dateLabel: String
    let photoCount: Int
    let imageURL: URL?
}

struct GalleryEventCard: View {
    let event: GalleryFeaturedEvent

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Image
            ZStack(alignment: .topTrailing) {
                CachedAsyncImage(url: event.imageURL) { phase in
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
                .frame(height: 120)
                .clipped()

                // Photo count badge
                Text("📸 \(event.photoCount)")
                    .font(.inter(size: 10, weight: .semibold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 7)
                    .padding(.vertical, 4)
                    .background(.ultraThinMaterial)
                    .clipShape(Capsule())
                    .padding(8)
            }

            // Info block
            VStack(alignment: .leading, spacing: 2) {
                Text(event.dateLabel.uppercased())
                    .font(.inter(size: 9, weight: .bold))
                    .foregroundStyle(Color.jcaCrimson)
                    .tracking(0.3)
                Text(event.title)
                    .font(.fraunces(size: 13, weight: .semibold))
                    .foregroundStyle(Color.jcaInk)
                    .lineLimit(2)
                    .padding(.top, 2)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 12)
        }
        .frame(width: 180)
        .background(Color.jcaPaper)
        .clipShape(RoundedRectangle(cornerRadius: Radii.md))
        .overlay(
            RoundedRectangle(cornerRadius: Radii.md)
                .stroke(Color.jcaBorder, lineWidth: 0.5)
        )
        .shadowSm()
    }
}
