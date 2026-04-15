import SwiftUI

struct NewsListView: View {
    @State private var selectedCategory: NewsCategory = .all
    private let newsItems = MockDataProvider.newsItems

    var filteredNews: [NewsItem] {
        if selectedCategory == .all { return newsItems }
        return newsItems.filter { $0.category == selectedCategory }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Category pills
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(NewsCategory.allCases) { category in
                            CategoryPill(
                                category: category,
                                isSelected: selectedCategory == category
                            ) {
                                withAnimation(.spring(duration: 0.2)) {
                                    selectedCategory = category
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 4)
                }
                .padding(.top, 16)

                // Featured article
                if let featured = filteredNews.first(where: { $0.isFeatured }) {
                    NavigationLink(destination: NewsDetailView(newsItem: featured)) {
                        FeaturedNewsCard(newsItem: featured)
                            .padding(.horizontal, 24)
                            .padding(.top, 20)
                    }
                    .buttonStyle(.plain)
                }

                // News list
                VStack(spacing: 10) {
                    ForEach(filteredNews.filter { !$0.isFeatured }) { item in
                        NavigationLink(destination: NewsDetailView(newsItem: item)) {
                            NewsRow(newsItem: item)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)
                .padding(.bottom, 32)
            }
        }
        .background(Color.jcaCream.ignoresSafeArea())
        .navigationTitle("News & Updates")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct CategoryPill: View {
    let category: NewsCategory
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(category.rawValue)
                .font(.inter(size: 12, weight: isSelected ? .semibold : .medium))
                .foregroundStyle(isSelected ? .white : Color.jcaInkSoft)
                .padding(.horizontal, 14)
                .padding(.vertical, 7)
                .background(
                    Capsule()
                        .fill(isSelected ? Color.jcaCrimson : Color.jcaPaper)
                        .overlay(Capsule().stroke(isSelected ? Color.jcaCrimson : Color.jcaBorder, lineWidth: 0.5))
                )
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(category.rawValue)\(isSelected ? ", selected" : "")")
    }
}

private struct FeaturedNewsCard: View {
    let newsItem: NewsItem

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            ZStack(alignment: .bottomLeading) {
                RoundedRectangle(cornerRadius: Radii.lg)
                    .fill(LinearGradient(
                        colors: [Color.jcaCrimson.opacity(0.8), Color.jcaCrimsonDeep],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .frame(height: 140)
                    .overlay(
                        Circle()
                            .stroke(Color.jcaGold.opacity(0.2), lineWidth: 30)
                            .frame(width: 200)
                            .offset(x: 100, y: -40)
                    )

                VStack(alignment: .leading, spacing: 4) {
                    Text("Featured")
                        .font(JCAFont.label)
                        .foregroundStyle(Color.jcaGoldLight.opacity(0.8))
                        .kerning(1.5)
                    Text(newsItem.title)
                        .font(JCAFont.headline)
                        .foregroundStyle(.white)
                        .lineLimit(2)
                }
                .padding(16)
            }
        }
        .background(
            RoundedRectangle(cornerRadius: Radii.base)
                .fill(Color.jcaPaper)
                .shadowSm()
        )
        .accessibilityLabel("Featured: \(newsItem.title)")
    }
}

private struct NewsRow: View {
    let newsItem: NewsItem

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.jcaCrimson.opacity(0.08))
                    .frame(width: 48, height: 48)
                Image(systemName: categoryIcon)
                    .font(.system(size: 18))
                    .foregroundStyle(Color.jcaCrimson.opacity(0.7))
            }
            VStack(alignment: .leading, spacing: 4) {
                Text(newsItem.title)
                    .font(JCAFont.title)
                    .foregroundStyle(Color.jcaInk)
                    .lineLimit(2)
                HStack(spacing: 8) {
                    Text(newsItem.category.rawValue)
                        .font(JCAFont.caption)
                        .foregroundStyle(Color.jcaCrimson)
                    Text("·")
                        .foregroundStyle(Color.jcaMuted)
                    Text(newsItem.date.formatted(.dateTime.month(.abbreviated).day().year()))
                        .font(JCAFont.caption)
                        .foregroundStyle(Color.jcaMuted)
                }
            }
            Spacer()
            Image(systemName: "chevron.right")
                .font(.system(size: 12))
                .foregroundStyle(Color.jcaMuted.opacity(0.4))
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: Radii.base)
                .fill(Color.jcaPaper)
                .overlay(
                    RoundedRectangle(cornerRadius: Radii.base)
                        .stroke(Color.jcaBorder, lineWidth: 0.5)
                )
                .shadowSm()
        )
        .accessibilityLabel("\(newsItem.title), \(newsItem.category.rawValue), \(newsItem.date.formatted(.dateTime.month().day()))")
    }

    private var categoryIcon: String {
        switch newsItem.category {
        case .community:      return "person.3.fill"
        case .events:         return "calendar.circle.fill"
        case .announcements:  return "megaphone.fill"
        case .newsletter:     return "envelope.fill"
        case .all:            return "newspaper.fill"
        }
    }
}

#Preview {
    NavigationStack {
        NewsListView()
    }
}
