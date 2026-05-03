import SwiftUI

struct CommunityFeedView: View {
    @AppStorage("jca.feed.seenDisclosure") private var hasSeenDisclosure = false
    @State private var showingDisclosure = false
    @State private var showingComposeAlert = false
    @State private var filter = "All"

    private let tabs = ["All", "Admin", "Members", "Youth"]

    private var filteredPosts: [CommunityPost] {
        let all = MockDataProvider.communityPosts
        switch filter {
        case "Admin":   return all.filter { $0.kind == .admin }
        case "Members": return all.filter { $0.kind == .member }
        case "Youth":   return all.filter { $0.kind == .youth }
        default:        return all
        }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                composeBar
                    .padding(.horizontal, 24)
                    .padding(.top, 16)

                PillTabBar(tabs: tabs, selection: $filter)

                LazyVStack(spacing: 12) {
                    ForEach(filteredPosts) { post in
                        FeedPostCard(post: post)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
            }
        }
        .background(Color.jcaCream.ignoresSafeArea())
        .refreshable {
            try? await Task.sleep(nanoseconds: 800_000_000)
        }
        .alert("Posts are reviewed before appearing", isPresented: $showingComposeAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Your post will be visible to the community once approved by an admin.")
        }
        .sheet(isPresented: $showingDisclosure) {
            ModerationDisclosureSheet {
                hasSeenDisclosure = true
                showingDisclosure = false
            }
        }
        .onAppear {
            if !hasSeenDisclosure {
                showingDisclosure = true
            }
        }
    }

    @ViewBuilder
    private var composeBar: some View {
        Button {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            showingComposeAlert = true
        } label: {
            HStack(spacing: 10) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color.jcaGold, Color.jcaGoldDeep],
                                startPoint: .topLeading, endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 36, height: 36)
                    Image(systemName: "person.fill")
                        .font(.system(size: 14))
                        .foregroundStyle(.white)
                }
                Text("Share with the community…")
                    .font(JCAFont.body)
                    .foregroundStyle(Color.jcaMuted)
                Spacer()
                Image(systemName: "square.and.pencil")
                    .font(.system(size: 15))
                    .foregroundStyle(Color.jcaCrimson)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background(Color.jcaPaper)
            .clipShape(RoundedRectangle(cornerRadius: Radii.base))
            .overlay(
                RoundedRectangle(cornerRadius: Radii.base)
                    .stroke(Color.jcaBorder, lineWidth: 0.5)
            )
            .shadowSm()
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Moderation Disclosure Sheet

private struct ModerationDisclosureSheet: View {
    let onDismiss: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 20) {
                ZStack {
                    Circle()
                        .fill(Color.jcaCrimson.opacity(0.08))
                        .frame(width: 80, height: 80)
                    Image(systemName: "shield.checkered")
                        .font(.system(size: 36))
                        .foregroundStyle(Color.jcaCrimson)
                }

                VStack(spacing: 8) {
                    Text("Community Guidelines")
                        .font(.fraunces(size: 22, weight: .semibold))
                        .foregroundStyle(Color.jcaInk)
                    Text("All posts are reviewed by JCA admins before appearing publicly. Please keep discussions respectful, uplifting, and in the spirit of Jain values.")
                        .font(JCAFont.body)
                        .foregroundStyle(Color.jcaInkSoft)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 8)
                }

                Button {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    onDismiss()
                } label: {
                    Text("I Understand")
                        .font(JCAFont.title)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
                        .background(Color.jcaCrimson)
                        .clipShape(RoundedRectangle(cornerRadius: Radii.base))
                }
                .padding(.horizontal, 4)
            }
            .padding(.horizontal, 28)
            .padding(.bottom, 8)

            Spacer()
        }
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
        .presentationBackground(Color.jcaCream)
    }
}

#Preview {
    NavigationStack {
        CommunityFeedView()
    }
}
