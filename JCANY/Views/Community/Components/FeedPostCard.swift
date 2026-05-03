import SwiftUI

struct FeedPostCard: View {
    let post: CommunityPost

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            header
            Divider().overlay(Color.jcaBorder).padding(.horizontal, 14)
            bodyText
            Divider().overlay(Color.jcaBorder).padding(.horizontal, 14)
            reactionRow
        }
        .background(Color.jcaPaper)
        .clipShape(RoundedRectangle(cornerRadius: Radii.base))
        .overlay(
            RoundedRectangle(cornerRadius: Radii.base)
                .stroke(
                    post.status == .pending ? Color.jcaGold.opacity(0.6) : Color.jcaBorder,
                    style: post.status == .pending
                        ? StrokeStyle(lineWidth: 1, dash: [6, 3])
                        : StrokeStyle(lineWidth: 0.5)
                )
        )
        .opacity(post.status == .pending ? 0.75 : 1)
        .shadowSm()
        .accessibilityElement(children: .contain)
    }

    // MARK: - Header

    @ViewBuilder
    private var header: some View {
        HStack(alignment: .top, spacing: 10) {
            avatar
            VStack(alignment: .leading, spacing: 3) {
                HStack(spacing: 6) {
                    Text(post.authorName)
                        .font(JCAFont.subheadline)
                        .foregroundStyle(Color.jcaInk)
                    badges
                }
                HStack(spacing: 4) {
                    Text(post.createdAt.relativeFormatted)
                        .font(JCAFont.caption)
                        .foregroundStyle(Color.jcaMuted)
                    if post.status == .pending {
                        Text("· Visible only to you")
                            .font(JCAFont.caption)
                            .foregroundStyle(Color.jcaGoldDeep)
                    }
                }
            }
            Spacer()
            if post.isPinned {
                Image(systemName: "pin.fill")
                    .font(.system(size: 11))
                    .foregroundStyle(Color.jcaMuted.opacity(0.5))
                    .accessibilityLabel("Pinned post")
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
    }

    @ViewBuilder
    private var avatar: some View {
        ZStack {
            Circle()
                .fill(avatarGradient)
                .frame(width: 38, height: 38)
            Text(post.authorInitials)
                .font(.fraunces(size: 14, weight: .semibold))
                .foregroundStyle(.white)
        }
    }

    private var avatarGradient: LinearGradient {
        switch post.kind {
        case .admin:
            return LinearGradient(colors: [Color.jcaCrimson, Color.jcaCrimsonDeep], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .youth:
            return LinearGradient(colors: [Color.jcaGoldDeep, Color.jcaGold], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .member:
            return LinearGradient(colors: [Color.jcaGold, Color.jcaGoldDeep], startPoint: .topLeading, endPoint: .bottomTrailing)
        }
    }

    @ViewBuilder
    private var badges: some View {
        if post.kind == .admin {
            Text("OFFICIAL")
                .font(.inter(size: 8, weight: .bold))
                .foregroundStyle(Color.jcaCrimson)
                .kerning(0.4)
                .padding(.horizontal, 5)
                .padding(.vertical, 2)
                .background(Color.jcaCrimson.opacity(0.1))
                .clipShape(Capsule())
        } else if post.kind == .youth {
            Text("YOUTH")
                .font(.inter(size: 8, weight: .bold))
                .foregroundStyle(Color.jcaGoldDeep)
                .kerning(0.4)
                .padding(.horizontal, 5)
                .padding(.vertical, 2)
                .background(Color.jcaGold.opacity(0.18))
                .clipShape(Capsule())
        }
    }

    // MARK: - Body

    @ViewBuilder
    private var bodyText: some View {
        Text(post.body)
            .font(JCAFont.body)
            .foregroundStyle(Color.jcaInkSoft)
            .fixedSize(horizontal: false, vertical: true)
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
    }

    // MARK: - Reactions

    @ViewBuilder
    private var reactionRow: some View {
        HStack(spacing: 0) {
            reactionButton(
                label: "🪷  \(post.reactions.lotus)",
                hint: "Like with lotus, \(post.reactions.lotus) lotuses"
            )
            Divider().frame(height: 28).overlay(Color.jcaBorder)
            reactionButton(
                label: "🙏  \(post.reactions.namaste)",
                hint: "Namaste, \(post.reactions.namaste)"
            )
            Divider().frame(height: 28).overlay(Color.jcaBorder)
            reactionButton(
                label: "\(Image(systemName: "bubble.left"))  \(post.reactions.comments)",
                hint: "Comments, \(post.reactions.comments) comments"
            )
            Divider().frame(height: 28).overlay(Color.jcaBorder)
            reactionButton(
                label: "\(Image(systemName: "square.and.arrow.up"))",
                hint: "Share this post"
            )
        }
        .padding(.vertical, 2)
    }

    @ViewBuilder
    private func reactionButton(label: LocalizedStringKey, hint: String) -> some View {
        Button {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        } label: {
            Text(label)
                .font(.inter(size: 12, weight: .medium))
                .foregroundStyle(Color.jcaInkSoft)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(hint)
        .accessibilityAddTraits(.isButton)
    }
}

// MARK: - Date helper

private extension Date {
    var relativeFormatted: String {
        let seconds = -timeIntervalSinceNow
        if seconds < 60 { return "Just now" }
        if seconds < 3600 { return "\(Int(seconds / 60))m ago" }
        if seconds < 86400 { return "\(Int(seconds / 3600))h ago" }
        return "\(Int(seconds / 86400))d ago"
    }
}

#Preview {
    VStack(spacing: 16) {
        FeedPostCard(post: MockDataProvider.communityPosts[0])
        FeedPostCard(post: MockDataProvider.communityPosts[1])
    }
    .padding()
    .background(Color.jcaCream)
}
