import SwiftUI

struct NewsDetailView: View {
    let newsItem: NewsItem

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Hero
                ZStack(alignment: .bottomLeading) {
                    LinearGradient(
                        colors: [Color.jcaCrimson, Color.jcaCrimsonDeep],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .frame(height: 180)
                    VStack(alignment: .leading, spacing: 6) {
                        Text(newsItem.category.rawValue.uppercased())
                            .font(JCAFont.label)
                            .foregroundStyle(Color.jcaGoldLight.opacity(0.8))
                            .kerning(1.5)
                        Text(newsItem.title)
                            .font(.fraunces(size: 22, weight: .semibold))
                            .foregroundStyle(.white)
                    }
                    .padding(24)
                }

                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text(newsItem.author)
                            .font(JCAFont.label)
                            .foregroundStyle(Color.jcaMuted)
                            .kerning(0.8)
                        Spacer()
                        Text(newsItem.date.formatted(.dateTime.day().month(.wide).year()))
                            .font(JCAFont.caption)
                            .foregroundStyle(Color.jcaMuted)
                    }
                    Divider().overlay(Color.jcaBorder)

                    Text(newsItem.summary)
                        .font(.fraunces(size: 16, weight: .medium))
                        .foregroundStyle(Color.jcaInkSoft)
                        .lineSpacing(5)

                    Text(newsItem.body.isEmpty ? newsItem.summary : newsItem.body)
                        .font(JCAFont.body)
                        .foregroundStyle(Color.jcaInkSoft)
                        .lineSpacing(5)
                }
                .padding(24)
            }
        }
        .background(Color.jcaCream.ignoresSafeArea())
        .navigationTitle(newsItem.category.rawValue)
        .navigationBarTitleDisplayMode(.inline)
    }
}
