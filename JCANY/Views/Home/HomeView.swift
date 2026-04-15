import SwiftUI
import SwiftData

struct HomeView: View {
    @State private var viewModel = HomeViewModel()
    @Query private var users: [User]

    var currentUser: User? { users.first }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                heroSection
                    .padding(.bottom, 4)

                // Quick Actions
                VStack(spacing: 12) {
                    SectionHeader(title: "Quick Actions")
                        .padding(.horizontal, 24)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            NavigationLink(destination: LiveDarshanView()) {
                                QuickActionCard(title: "Live Darshan", subtitle: "Streaming now", icon: "video.fill")
                            }
                            NavigationLink(destination: DonateViewWrapper()) {
                                QuickActionCard(title: "Donate", subtitle: "Support the temple", icon: "heart.fill", isGold: true)
                            }
                            NavigationLink(destination: CalendarView()) {
                                QuickActionCard(title: "Calendar", subtitle: "Upcoming events", icon: "calendar")
                            }
                            NavigationLink(destination: VirtualTourView()) {
                                QuickActionCard(title: "Virtual Tour", subtitle: "Explore shrines", icon: "building.columns", isGold: true)
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.bottom, 8)
                    }
                }
                .padding(.top, 22)

                // Upcoming Events
                VStack(spacing: 12) {
                    SectionHeader(title: "Upcoming Events", actionTitle: "See all") {}
                        .padding(.horizontal, 24)

                    VStack(spacing: 10) {
                        ForEach(viewModel.events) { event in
                            NavigationLink(destination: EventDetailView(event: event)) {
                                EventCard(event: event)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 24)
                }
                .padding(.top, 22)
                .padding(.bottom, 32)
            }
        }
        .background(Color.jcaCream.ignoresSafeArea())
        .navigationBarHidden(true)
    }

    @ViewBuilder
    private var heroSection: some View {
        ZStack(alignment: .topTrailing) {
            // Faint mandala
            MandalaBackgroundView(opacity: 0.06, size: 280, animate: false)
                .offset(x: 60, y: -40)
                .allowsHitTesting(false)

            VStack(spacing: 0) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("JAY JINENDRA")
                            .font(JCAFont.label)
                            .foregroundStyle(Color.jcaMuted)
                            .kerning(0.8)
                            .textCase(.uppercase)
                        Text("Manan Shah")
                            .font(.fraunces(size: 26, weight: .medium))
                            .foregroundStyle(Color.jcaInk)
                    }
                    Spacer()
                    Circle()
                        .fill(LinearGradient(
                            colors: [Color.jcaCrimson, Color.jcaCrimsonDeep],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ))
                        .frame(width: 42, height: 42)
                        .overlay(
                            Text(currentUser?.avatarInitial ?? "M")
                                .font(.fraunces(size: 18, weight: .semibold))
                                .foregroundStyle(Color.jcaCream)
                        )
                        .shadow(color: Color.jcaCrimson.opacity(0.3), radius: 8, y: 4)
                }

                PanchangCard(panchang: viewModel.panchang)
                    .padding(.top, 16)
            }
            .padding(.horizontal, 24)
            .padding(.top, 8)
            .padding(.bottom, 16)
        }
    }
}

/// Wrapper to provide a fresh DonationFlowViewModel when accessing Donate from Home tab
private struct DonateViewWrapper: View {
    @State private var vm = DonationFlowViewModel()
    var body: some View {
        DonateView().environment(vm)
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
    .modelContainer(for: [User.self, FamilyMember.self, Donation.self, PaymentMethod.self])
}
