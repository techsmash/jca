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
            // Gallery quick-access card
            NavigationLink(value: CommunityRoute.gallery) {
                HStack(spacing: 14) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(
                                LinearGradient(
                                    colors: [Color.jcaGold.opacity(0.3), Color.jcaGoldLight.opacity(0.2)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 38, height: 38)
                        Image(systemName: "photo.stack.fill")
                            .font(.system(size: 17))
                            .foregroundStyle(Color.jcaGoldDeep)
                    }
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Gallery")
                            .font(JCAFont.title)
                            .foregroundStyle(Color.jcaInk)
                        Text("Photos, videos & 360° virtual tours")
                            .font(JCAFont.caption)
                            .foregroundStyle(Color.jcaMuted)
                    }
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12))
                        .foregroundStyle(Color.jcaMuted.opacity(0.4))
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: Radii.base)
                        .fill(Color.jcaPaper)
                        .overlay(
                            RoundedRectangle(cornerRadius: Radii.base)
                                .stroke(Color.jcaBorder, lineWidth: 0.5)
                        )
                        .shadowSm()
                )
                .padding(.horizontal, 24)
                .padding(.top, 12)
                .padding(.bottom, 8)
            }
            .buttonStyle(.plain)

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
