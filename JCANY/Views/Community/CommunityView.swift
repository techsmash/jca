import SwiftUI

struct CommunityView: View {
    @State private var tab = "Feed"

    var body: some View {
        VStack(spacing: 0) {
            PillTabBar(tabs: ["Feed", "Hub"], selection: $tab)
                .padding(.vertical, 10)
                .background(Color.jcaCream)

            Divider().overlay(Color.jcaBorder)

            Group {
                if tab == "Feed" {
                    CommunityFeedView()
                } else {
                    CommunityHubView()
                }
            }
        }
        .background(Color.jcaCream.ignoresSafeArea())
        .navigationTitle("Community")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        CommunityView()
    }
}
