import SwiftUI

struct GalleryHeroBanner: View {
    @State private var pulseDot = false

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            // Background image
            CachedAsyncImage(url: JCAImageURLs.mjk2025) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .saturation(1.1)
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
            .frame(height: 200)
            .clipped()

            // Dark gradient overlay
            LinearGradient(
                stops: [
                    .init(color: .clear, location: 0.35),
                    .init(color: Color.black.opacity(0.85), location: 1.0)
                ],
                startPoint: .top,
                endPoint: .bottom
            )

            // Bottom-left content
            VStack(alignment: .leading, spacing: 6) {
                // "FEATURED" pill
                HStack(spacing: 5) {
                    Circle()
                        .fill(Color.jcaCrimson)
                        .frame(width: 5, height: 5)
                        .opacity(pulseDot ? 0.4 : 1)
                        .animation(.easeInOut(duration: 0.8).repeatForever(), value: pulseDot)
                    Text("FEATURED")
                        .font(.inter(size: 9, weight: .bold))
                        .foregroundStyle(Color.jcaCrimson)
                        .tracking(0.5)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(Color.jcaGold)
                .clipShape(Capsule())

                // Title
                Group {
                    Text("Mahavir Janma ") +
                    Text("Kalyanak 2025")
                        .italic()
                        .foregroundStyle(Color.jcaGoldLight)
                }
                .font(.fraunces(size: 22, weight: .medium))
                .foregroundStyle(Color.white)
                .lineSpacing(2)

                // Meta
                HStack(spacing: 12) {
                    Label("48 photos", systemImage: "photo.on.rectangle")
                    Label("6 videos",  systemImage: "play.rectangle")
                    Label("April 2025", systemImage: "calendar")
                }
                .font(.inter(size: 10))
                .foregroundStyle(Color.white.opacity(0.85))
                .labelStyle(.titleAndIcon)
            }
            .padding(.horizontal, 18)
            .padding(.bottom, 16)
        }
        .frame(height: 200)
        .clipShape(RoundedRectangle(cornerRadius: Radii.lg))
        .shadowMd()
        .padding(.horizontal, 24)
        .onAppear { pulseDot = true }
    }
}
