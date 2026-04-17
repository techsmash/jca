import SwiftUI

struct MasonryPhoto: Identifiable {
    let id = UUID()
    let caption: String
    let imageURL: URL?
    let heightClass: HeightClass

    enum HeightClass {
        case tall, medium, short
        var height: CGFloat {
            switch self {
            case .tall:   return 200
            case .medium: return 160
            case .short:  return 120
            }
        }
    }
}

struct MasonryPhotoGrid: View {
    let photos: [MasonryPhoto]
    @State private var selectedPhoto: MasonryPhoto?

    // Split photos into two columns
    private var leftColumn: [MasonryPhoto] {
        photos.enumerated().filter { $0.offset % 2 == 0 }.map(\.element)
    }
    private var rightColumn: [MasonryPhoto] {
        photos.enumerated().filter { $0.offset % 2 == 1 }.map(\.element)
    }

    var body: some View {
        HStack(alignment: .top, spacing: 6) {
            column(leftColumn)
            column(rightColumn)
        }
        .padding(.horizontal, 24)
        .sheet(item: $selectedPhoto) { photo in
            GalleryViewerView(url: photo.imageURL, caption: photo.caption)
        }
    }

    @ViewBuilder
    private func column(_ photos: [MasonryPhoto]) -> some View {
        VStack(spacing: 6) {
            ForEach(photos) { photo in
                CachedAsyncImage(url: photo.imageURL) { phase in
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
                .frame(height: photo.heightClass.height)
                .frame(maxWidth: .infinity)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .contentShape(Rectangle())
                .onTapGesture { selectedPhoto = photo }
                .accessibilityLabel(photo.caption)
            }
        }
    }
}
