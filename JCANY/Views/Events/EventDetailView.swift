import SwiftUI

struct EventDetailView: View {
    let event: Event
    @State private var isRSVPed: Bool

    init(event: Event) {
        self.event = event
        _isRSVPed = State(initialValue: event.isRSVPed)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Hero
                EventHeroCard(event: event)

                // Content
                VStack(alignment: .leading, spacing: 24) {
                    // Date & Time
                    EventInfoRow(
                        icon: "calendar",
                        title: "Date & Time",
                        value: event.date.formatted(.dateTime.weekday(.wide).month(.wide).day().year()) + "\n" + event.date.formatted(.dateTime.hour().minute())
                    )
                    Divider().overlay(Color.jcaBorder)

                    EventInfoRow(
                        icon: "mappin.circle.fill",
                        title: "Location",
                        value: event.location.isEmpty ? "JCA NY Temple" : event.location
                    )
                    Divider().overlay(Color.jcaBorder)

                    EventInfoRow(
                        icon: "tag.fill",
                        title: "Category",
                        value: event.category.isEmpty ? "Community" : event.category
                    )

                    if !event.description.isEmpty {
                        Divider().overlay(Color.jcaBorder)
                        VStack(alignment: .leading, spacing: 8) {
                            Text("About")
                                .font(JCAFont.headline)
                                .foregroundStyle(Color.jcaInk)
                            Text(event.description)
                                .font(JCAFont.body)
                                .foregroundStyle(Color.jcaInkSoft)
                                .lineSpacing(4)
                        }
                    }
                }
                .padding(24)
            }
        }
        .background(Color.jcaCream.ignoresSafeArea())
        .navigationTitle(event.title)
        .navigationBarTitleDisplayMode(.inline)
        .safeAreaInset(edge: .bottom) {
            RSVPBar(isRSVPed: $isRSVPed, eventTitle: event.title)
        }
    }
}

private struct EventHeroCard: View {
    let event: Event

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            LinearGradient(
                colors: [Color.jcaCrimson, Color.jcaCrimsonDeep],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .frame(height: 200)

            // Decorative circles
            Circle()
                .stroke(Color.jcaGold.opacity(0.2), lineWidth: 30)
                .frame(width: 200)
                .offset(x: 120, y: -60)

            VStack(alignment: .leading, spacing: 6) {
                Text(event.category.uppercased())
                    .font(JCAFont.label)
                    .foregroundStyle(Color.jcaGoldLight.opacity(0.8))
                    .kerning(1.5)
                Text(event.title)
                    .font(.fraunces(size: 24, weight: .semibold))
                    .foregroundStyle(.white)
                if !event.subtitle.isEmpty {
                    Text(event.subtitle)
                        .font(JCAFont.subheadline)
                        .foregroundStyle(Color.jcaCream.opacity(0.7))
                }
            }
            .padding(24)
        }
    }
}

private struct EventInfoRow: View {
    let icon: String
    let title: String
    let value: String

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.jcaCrimson.opacity(0.08))
                    .frame(width: 36, height: 36)
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(Color.jcaCrimson)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(JCAFont.label)
                    .foregroundStyle(Color.jcaMuted)
                    .kerning(0.8)
                    .textCase(.uppercase)
                Text(value)
                    .font(JCAFont.body)
                    .foregroundStyle(Color.jcaInk)
            }
            Spacer()
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title): \(value)")
    }
}

struct RSVPBar: View {
    @Binding var isRSVPed: Bool

    let eventTitle: String

    var body: some View {
        VStack(spacing: 0) {
            Divider().overlay(Color.jcaBorder)
            HStack(spacing: 12) {
                Button {
                    // Share
                } label: {
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 18))
                        .foregroundStyle(Color.jcaCrimson)
                        .frame(width: 44, height: 44)
                        .background(
                            Circle()
                                .stroke(Color.jcaBorder, lineWidth: 0.5)
                        )
                }
                .accessibilityLabel("Share event")

                Button {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    withAnimation(.spring(duration: 0.3)) {
                        isRSVPed.toggle()
                    }
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: isRSVPed ? "checkmark.circle.fill" : "calendar.badge.plus")
                            .font(.system(size: 16, weight: .semibold))
                        Text(isRSVPed ? "RSVP'd" : "RSVP")
                            .font(JCAFont.bodyMedium)
                            .fontWeight(.semibold)
                    }
                    .foregroundStyle(isRSVPed ? Color.jcaGreen : .white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(
                        RoundedRectangle(cornerRadius: Radii.m)
                            .fill(isRSVPed ? Color.jcaGreen.opacity(0.1) : Color.jcaCrimson)
                            .overlay(
                                RoundedRectangle(cornerRadius: Radii.m)
                                    .stroke(isRSVPed ? Color.jcaGreen : Color.clear, lineWidth: 1)
                            )
                    )
                }
                .accessibilityLabel(isRSVPed ? "Cancel RSVP for \(eventTitle)" : "RSVP to \(eventTitle)")
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 14)
            .background(Color.jcaPaper.ignoresSafeArea(edges: .bottom))
        }
    }
}

// MARK: - Color extension
extension Color {
    static let jcaGreen = Color(hex: "#2e7d32")
}

#Preview {
    NavigationStack {
        EventDetailView(event: MockDataProvider.events[0])
    }
}
