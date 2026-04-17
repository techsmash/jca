import SwiftUI
import SwiftData

struct HomeView: View {
    @State private var viewModel = HomeViewModel()
    @Query private var users: [User]
    @Environment(AppState.self) private var appState

    var currentUser: User? { users.first }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                heroSection
                    .padding(.bottom, 4)

                // Sponsor highlight banner
                SponsorHighlightBanner()

                // Quick Actions
                VStack(spacing: 12) {
                    SectionHeader(title: "Quick Actions")
                        .padding(.horizontal, 24)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            NavigationLink(destination: LiveDarshanView()) {
                                QuickActionCard(title: "Live Darshan", subtitle: "Streaming now", icon: "video.fill")
                            }
                            .buttonStyle(.plain)

                            Button {
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                appState.selectedTab = .donate
                            } label: {
                                QuickActionCard(title: "Donate", subtitle: "Support the temple", icon: "heart.fill", isGold: true)
                            }
                            .buttonStyle(.plain)

                            Button {
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                appState.selectedTab = .calendar
                            } label: {
                                QuickActionCard(title: "Calendar", subtitle: "Upcoming events", icon: "calendar")
                            }
                            .buttonStyle(.plain)

                            Button {
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                appState.navigate(to: .gallery)
                            } label: {
                                QuickActionCard(title: "Gallery", subtitle: "Photos & videos", icon: "photo.stack.fill", isGold: true)
                            }
                            .buttonStyle(.plain)

                            Button {
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                appState.selectedTab = .community
                            } label: {
                                QuickActionCard(title: "Volunteer", subtitle: "Join seva", icon: "hands.sparkles.fill")
                            }
                            .buttonStyle(.plain)

                            Button {
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                appState.selectedTab = .donate
                            } label: {
                                QuickActionCard(title: "Bhojanshala", subtitle: "Sponsor a meal", icon: "fork.knife")
                            }
                            .buttonStyle(.plain)

                            NavigationLink(destination: VirtualTourView()) {
                                QuickActionCard(title: "Virtual Tour", subtitle: "Explore shrines", icon: "building.columns", isGold: true)
                            }
                            .buttonStyle(.plain)
                        }
                        .padding(.horizontal, 24)
                        .padding(.bottom, 8)
                    }
                }
                .padding(.top, 22)

                // Upcoming Events
                VStack(spacing: 12) {
                    SectionHeader(title: "Upcoming Events", actionTitle: "See all") {
                        appState.selectedTab = .calendar
                    }
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
                    // Greeting + name + member ID
                    VStack(alignment: .leading, spacing: 2) {
                        Text("JAY JINENDRA")
                            .font(JCAFont.label)
                            .foregroundStyle(Color.jcaMuted)
                            .kerning(0.8)
                            .textCase(.uppercase)
                        Text(currentUser?.name ?? "Manan Shah")
                            .font(.fraunces(size: 26, weight: .medium))
                            .foregroundStyle(Color.jcaInk)
                        // Member ID pill — separate line below name
                        HStack(spacing: 4) {
                            Circle()
                                .fill(Color.jcaGold)
                                .frame(width: 4, height: 4)
                            Text("ID \(currentUser?.memberID ?? "04812")")
                                .font(.inter(size: 10, weight: .semibold))
                                .foregroundStyle(Color.jcaCrimson)
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(Color.jcaCrimson.opacity(0.08))
                        .clipShape(Capsule())
                        .padding(.top, 2)
                    }
                    Spacer()
                    // Avatar button → navigates to Profile tab
                    Button {
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        appState.selectedTab = .profile
                    } label: {
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
                    .buttonStyle(.plain)
                    .accessibilityLabel("View profile")
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

#Preview {
    NavigationStack {
        HomeView()
            .environment(AppState())
    }
    .modelContainer(for: [User.self, FamilyMember.self, Donation.self, PaymentMethod.self])
}
