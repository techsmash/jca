import SwiftUI

struct VolunteerView: View {
    let opportunities = MockDataProvider.volunteerOpportunities

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Impact banner
                ImpactBanner()
                    .padding(.horizontal, 24)
                    .padding(.top, 16)

                VStack(spacing: 12) {
                    SectionHeader(title: "Opportunities", actionTitle: "All"){}
                        .padding(.horizontal, 24)

                    VStack(spacing: 10) {
                        ForEach(opportunities) { opportunity in
                            VolunteerCard(opportunity: opportunity)
                        }
                    }
                    .padding(.horizontal, 24)
                }
                .padding(.top, 24)
                .padding(.bottom, 32)
            }
        }
        .background(Color.jcaCream.ignoresSafeArea())
        .navigationTitle("Volunteer & Seva")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct ImpactBanner: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: Radii.xl)
                .fill(LinearGradient(
                    colors: [Color.jcaCrimson, Color.jcaCrimsonDeep],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
                .overlay(
                    Circle()
                        .stroke(Color.jcaGold.opacity(0.2), lineWidth: 30)
                        .frame(width: 200)
                        .offset(x: 80, y: 30)
                )

            HStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("142")
                        .font(.fraunces(size: 36, weight: .semibold))
                        .foregroundStyle(.white)
                    Text("Seva Hours\nContributed")
                        .font(JCAFont.caption)
                        .foregroundStyle(Color.jcaCream.opacity(0.7))
                        .lineSpacing(3)
                }
                Spacer()
                VStack(spacing: 16) {
                    ImpactStat(value: "24", label: "Volunteers")
                    ImpactStat(value: "8", label: "Events")
                }
            }
            .padding(20)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("142 seva hours contributed, 24 volunteers, 8 events")
    }
}

private struct ImpactStat: View {
    let value: String
    let label: String

    var body: some View {
        VStack(spacing: 2) {
            Text(value)
                .font(.fraunces(size: 20, weight: .semibold))
                .foregroundStyle(.white)
            Text(label)
                .font(JCAFont.caption)
                .foregroundStyle(Color.jcaCream.opacity(0.6))
        }
    }
}

private struct VolunteerCard: View {
    let opportunity: VolunteerOpportunity

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 8) {
                        Text(opportunity.title)
                            .font(JCAFont.title)
                            .foregroundStyle(Color.jcaInk)
                        if opportunity.isUrgent {
                            Text("URGENT")
                                .font(JCAFont.label)
                                .foregroundStyle(.white)
                                .kerning(0.5)
                                .padding(.horizontal, 7)
                                .padding(.vertical, 3)
                                .background(Color.jcaCrimson)
                                .clipShape(Capsule())
                        }
                    }
                    Text(opportunity.category)
                        .font(JCAFont.caption)
                        .foregroundStyle(Color.jcaMuted)
                }
                Spacer()
                Text("\(opportunity.spotsAvailable) spots")
                    .font(JCAFont.caption)
                    .foregroundStyle(Color.jcaCrimson)
            }

            Text(opportunity.description)
                .font(JCAFont.body)
                .foregroundStyle(Color.jcaInkSoft)
                .lineLimit(2)

            HStack {
                Label(opportunity.date, systemImage: "clock.fill")
                    .font(JCAFont.caption)
                    .foregroundStyle(Color.jcaMuted)
                Spacer()
                Button {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                } label: {
                    Text("Sign Up")
                        .font(JCAFont.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 7)
                        .background(Color.jcaCrimson)
                        .clipShape(Capsule())
                }
                .accessibilityLabel("Sign up for \(opportunity.title)")
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: Radii.base)
                .fill(Color.jcaPaper)
                .overlay(
                    RoundedRectangle(cornerRadius: Radii.base)
                        .stroke(opportunity.isUrgent ? Color.jcaCrimson.opacity(0.3) : Color.jcaBorder, lineWidth: 0.5)
                )
                .shadowSm()
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(opportunity.title)\(opportunity.isUrgent ? ", urgent" : ""). \(opportunity.description). \(opportunity.spotsAvailable) spots available.")
    }
}

#Preview {
    NavigationStack {
        VolunteerView()
    }
}
