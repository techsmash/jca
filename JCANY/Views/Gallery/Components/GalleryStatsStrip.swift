import SwiftUI

struct GalleryStatsStrip: View {
    private let stats: [(number: String, label: String)] = [
        ("1,247", "Photos"),
        ("89",    "Videos"),
        ("34",    "Albums"),
        ("9",     "360° Tours")
    ]

    var body: some View {
        HStack(spacing: 0) {
            ForEach(stats.indices, id: \.self) { i in
                statCell(number: stats[i].number, label: stats[i].label)
                if i < stats.count - 1 {
                    Rectangle()
                        .fill(Color.jcaBorder)
                        .frame(width: 1, height: 40)
                }
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: Radii.m)
                .fill(Color.jcaPaper)
                .overlay(
                    RoundedRectangle(cornerRadius: Radii.m)
                        .stroke(Color.jcaBorder, lineWidth: 0.5)
                )
                .shadowSm()
        )
        .padding(.horizontal, 24)
    }

    private func statCell(number: String, label: String) -> some View {
        VStack(spacing: 3) {
            Text(number)
                .font(.fraunces(size: 17, weight: .semibold))
                .foregroundStyle(Color.jcaCrimson)
                .lineLimit(1)
            Text(label.uppercased())
                .font(.inter(size: 9, weight: .semibold))
                .foregroundStyle(Color.jcaMuted)
                .tracking(1.2)
        }
        .frame(maxWidth: .infinity)
    }
}
