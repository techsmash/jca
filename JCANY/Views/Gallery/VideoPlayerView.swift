import SwiftUI

/// Stub video player — replace with AVPlayer + VideoPlayer when real HLS URLs are available.
/// Backend integration point: supply mp4/HLS URL per video.
struct VideoPlayerView: View {
    let title: String
    let thumbnailURL: URL?
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 24) {
                // Thumbnail
                CachedAsyncImage(url: thumbnailURL) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(16 / 9, contentMode: .fit)
                            .overlay(
                                Image(systemName: "play.circle.fill")
                                    .font(.system(size: 64))
                                    .foregroundStyle(.white.opacity(0.7))
                            )
                    default:
                        Color.jcaCrimsonDeep
                            .aspectRatio(16 / 9, contentMode: .fit)
                            .overlay(
                                Image(systemName: "play.circle.fill")
                                    .font(.system(size: 64))
                                    .foregroundStyle(.white.opacity(0.5))
                            )
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .padding(.horizontal, 20)

                VStack(spacing: 8) {
                    Text(title)
                        .font(.fraunces(size: 18, weight: .semibold))
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)

                    Text("Video streaming coming soon")
                        .font(.inter(size: 14))
                        .foregroundStyle(.white.opacity(0.55))
                }
            }

            // Close button
            VStack {
                HStack {
                    Button { dismiss() } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.white)
                            .frame(width: 36, height: 36)
                            .background(Color.black.opacity(0.5))
                            .clipShape(Circle())
                    }
                    .padding(.leading, 20)
                    .padding(.top, 16)
                    Spacer()
                }
                Spacer()
            }
        }
        .navigationBarHidden(true)
    }
}
