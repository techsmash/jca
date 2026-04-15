import SwiftUI

struct CommunityHubView: View {
    @State private var selectedSegment: CommunitySection = .pathshala

    enum CommunitySection: String, CaseIterable {
        case pathshala = "Pathshala"
        case volunteer = "Volunteer"
        case news      = "News"
    }

    var body: some View {
        VStack(spacing: 0) {
            // Segment control
            Picker("Community Section", selection: $selectedSegment) {
                ForEach(CommunitySection.allCases, id: \.self) { section in
                    Text(section.rawValue).tag(section)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background(Color.jcaCream)

            Divider().overlay(Color.jcaBorder)

            // Content
            Group {
                switch selectedSegment {
                case .pathshala:
                    PathshalaView()
                        .navigationBarHidden(true)
                case .volunteer:
                    VolunteerView()
                        .navigationBarHidden(true)
                case .news:
                    NewsListView()
                        .navigationBarHidden(true)
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
        CommunityHubView()
    }
}
