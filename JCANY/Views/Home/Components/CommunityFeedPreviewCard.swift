import SwiftUI

struct CommunityFeedPreviewCard: View {
    let posts: [HomePreviewPost]
    let onOpenFeed: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .lastTextBaseline) {
                Text("Community Feed")
                    .font(JCAFont.headline)
                    .foregroundStyle(Color.jcaInk)
                Spacer()
                Button("Open feed", action: onOpenFeed)
                    .font(JCAFont.subheadline)
                    .foregroundStyle(Color.jcaCrimson)
                    .accessibilityLabel("Open community feed")
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 10)

            VStack(spacing: 8) {
                ForEach(posts) { post in
                    FeedPreviewRow(post: post)
                }
            }
            .padding(.horizontal, 24)
        }
    }
}

// MARK: - Post row

private struct FeedPreviewRow: View {
    let post: HomePreviewPost

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            avatar
            postContent
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
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(post.authorName): \(post.body), \(post.timeAgo)")
    }

    @ViewBuilder
    private var avatar: some View {
        ZStack {
            Circle()
                .fill(
                    post.kind == .admin
                        ? AnyShapeStyle(LinearGradient(
                            colors: [Color.jcaCrimson, Color.jcaCrimsonDeep],
                            startPoint: .topLeading, endPoint: .bottomTrailing))
                        : AnyShapeStyle(LinearGradient(
                            colors: [Color.jcaGold, Color.jcaGoldDeep],
                            startPoint: .topLeading, endPoint: .bottomTrailing))
                )
                .frame(width: 36, height: 36)
            Text(post.authorInitials)
                .font(.fraunces(size: 13, weight: .semibold))
                .foregroundStyle(.white)
        }
    }

    @ViewBuilder
    private var postContent: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 6) {
                Text(post.authorName)
                    .font(JCAFont.subheadline)
                    .foregroundStyle(Color.jcaInk)
                if post.kind == .admin {
                    Text("OFFICIAL")
                        .font(.inter(size: 8, weight: .bold))
                        .foregroundStyle(Color.jcaCrimson)
                        .kerning(0.4)
                        .padding(.horizontal, 5)
                        .padding(.vertical, 2)
                        .background(Color.jcaCrimson.opacity(0.1))
                        .clipShape(Capsule())
                }
                if post.isPinned {
                    Image(systemName: "pin.fill")
                        .font(.system(size: 9))
                        .foregroundStyle(Color.jcaMuted)
                }
            }
            Text(post.body)
                .font(JCAFont.body)
                .foregroundStyle(Color.jcaInkSoft)
                .lineLimit(2)
            Text(post.timeAgo)
                .font(JCAFont.caption)
                .foregroundStyle(Color.jcaMuted)
        }
    }
}

// MARK: - Preview

#Preview {
    CommunityFeedPreviewCard(
        posts: [
            HomePreviewPost(
                kind: .admin, authorInitials: "JC", authorName: "JCA New York",
                body: "Reminder: Paryushan Parva begins Saturday. All schedules are on the Calendar tab. Jai Jinendra 🙏",
                timeAgo: "2h ago", isPinned: true
            ),
            HomePreviewPost(
                kind: .member, authorInitials: "PS", authorName: "Priya Shah",
                body: "Beautiful Snatra Puja this morning — so grateful to be part of this sangha. Anumodana 🪷",
                timeAgo: "4h ago", isPinned: false
            ),
        ],
        onOpenFeed: {}
    )
    .padding(.vertical)
    .background(Color.jcaCream)
}
