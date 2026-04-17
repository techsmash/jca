import SwiftUI

struct NotificationDemoView: View {
    private let service = PushNotificationService.shared
    @State private var bellTrigger = false
    private let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()

    private let wishesTypes: [PushNotificationType] = [
        .birthday, .eventReminder, .parvaDay, .aartiReminder
    ]
    private let communityTypes: [PushNotificationType] = [
        .donationReceived, .volunteerOpportunity, .pathshalaClass, .newPhotos
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                heroCard
                    .padding(.horizontal, 24)

                notificationSection(label: "✦ Wishes & Reminders", types: wishesTypes)

                notificationSection(label: "✦ Community & Seva", types: communityTypes)

                tipCard
                    .padding(.horizontal, 24)
                    .padding(.bottom, 40)
            }
            .padding(.top, 16)
        }
        .background(Color.jcaCream.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                NavigationBackButton()
            }
            ToolbarItem(placement: .principal) {
                VStack(spacing: 2) {
                    Text("Notification Demo")
                        .font(.fraunces(size: 19, weight: .semibold))
                        .foregroundStyle(Color.jcaInk)
                    Text("Preview how JCA push notifications look")
                        .font(.inter(size: 10))
                        .foregroundStyle(Color.jcaMuted)
                }
            }
        }
        .onReceive(timer) { _ in
            bellTrigger.toggle()
        }
    }

    // MARK: - Hero Card

    private var heroCard: some View {
        ZStack(alignment: .topTrailing) {
            // Background gradient
            RoundedRectangle(cornerRadius: Radii.lg)
                .fill(
                    LinearGradient(
                        colors: [Color(hex: "#a8202c"), Color(hex: "#7a1620")],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )

            // Gold glow decoration
            Circle()
                .fill(
                    RadialGradient(
                        colors: [Color.jcaGold.opacity(0.25), Color.clear],
                        center: .center,
                        startRadius: 0,
                        endRadius: 80
                    )
                )
                .frame(width: 160, height: 160)
                .offset(x: 20, y: -30)
                .allowsHitTesting(false)

            // Content
            VStack(spacing: 16) {
                HStack(spacing: 16) {
                    // Animated bell icon
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.jcaGold.opacity(0.2))
                            .frame(width: 44, height: 44)
                        Image(systemName: "bell.fill")
                            .font(.system(size: 20))
                            .foregroundStyle(Color.jcaGoldLight)
                            .phaseAnimator(
                                [0.0, -12.0, 10.0, -8.0, 4.0, 0.0],
                                trigger: bellTrigger
                            ) { view, angle in
                                view.rotationEffect(.degrees(angle))
                            } animation: { _ in
                                .easeInOut(duration: 0.08)
                            }
                    }

                    VStack(alignment: .leading, spacing: 6) {
                        Group {
                            Text("Stay connected to your ") +
                            Text("sangha.")
                                .italic()
                                .foregroundStyle(Color.jcaGoldLight)
                        }
                        .font(.fraunces(size: 20))
                        .foregroundStyle(Color.white)

                        Text("Tap any notification below to preview how it appears on your iPhone lock screen.")
                            .font(.inter(size: 11))
                            .foregroundStyle(Color.white.opacity(0.8))
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
            .padding(16)
        }
        .shadowMd()
    }

    // MARK: - Notification Section

    @ViewBuilder
    private func notificationSection(label: String, types: [PushNotificationType]) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(label)
                .font(.inter(size: 10, weight: .bold))
                .foregroundStyle(Color.jcaCrimson)
                .tracking(0.8)
                .textCase(.uppercase)
                .padding(.horizontal, 24)

            VStack(spacing: 10) {
                ForEach(types, id: \.self) { type in
                    NotificationTypeCard(type: type) {
                        UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                        service.present(type)
                    }
                }
            }
            .padding(.horizontal, 24)
        }
    }

    // MARK: - Tip Card

    private var tipCard: some View {
        HStack(alignment: .top, spacing: 12) {
            Text("💡")
                .font(.system(size: 20))
            VStack(alignment: .leading, spacing: 4) {
                Text("DEVELOPER TIP")
                    .font(.inter(size: 9, weight: .bold))
                    .foregroundStyle(Color.jcaGoldDeep)
                    .tracking(0.8)
                Text("Tap a Send button to see the iOS-style push notification banner animate in from the top. Each notification deep-links to a relevant screen when tapped.")
                    .font(.inter(size: 12))
                    .foregroundStyle(Color.jcaInkSoft)
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: Radii.m)
                .fill(Color.jcaGold.opacity(0.08))
                .overlay(
                    RoundedRectangle(cornerRadius: Radii.m)
                        .strokeBorder(
                            style: StrokeStyle(lineWidth: 1, dash: [4, 4])
                        )
                        .foregroundStyle(Color.jcaGold.opacity(0.5))
                )
        )
    }
}

// MARK: - NotificationTypeCard

private struct NotificationTypeCard: View {
    let type: PushNotificationType
    let onSend: () -> Void

    @State private var isPressed = false

    var body: some View {
        HStack(spacing: 12) {
            // Icon
            ZStack {
                LinearGradient(
                    colors: type.gradientColors,
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .frame(width: 38, height: 38)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                Text(type.emoji)
                    .font(.system(size: 20))
            }

            // Info
            VStack(alignment: .leading, spacing: 3) {
                Text(type.displayName)
                    .font(.fraunces(size: 13, weight: .semibold))
                    .foregroundStyle(Color.jcaInk)
                Text(type.description)
                    .font(.inter(size: 10))
                    .foregroundStyle(Color.jcaMuted)
            }

            Spacer(minLength: 0)

            // Send button
            Button {
                onSend()
            } label: {
                Text("Send")
                    .font(.inter(size: 11, weight: .semibold))
                    .foregroundStyle(Color.jcaCreamWarm)
                    .padding(.vertical, 7)
                    .padding(.horizontal, 14)
                    .background(
                        Capsule()
                            .fill(Color.jcaCrimson)
                            .shadow(color: Color.jcaCrimson.opacity(0.3), radius: 4, y: 2)
                    )
            }
            .buttonStyle(.plain)
            .scaleEffect(isPressed ? 0.95 : 1)
            .animation(.easeInOut(duration: 0.1), value: isPressed)
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in isPressed = true }
                    .onEnded { _ in isPressed = false }
            )
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: Radii.m)
                .fill(Color.jcaPaper)
                .overlay(
                    RoundedRectangle(cornerRadius: Radii.m)
                        .stroke(Color.jcaBorder, lineWidth: 0.5)
                )
                .shadowSm()
        )
        .accessibilityLabel("Send \(type.displayName) notification")
    }
}

#Preview {
    NavigationStack {
        NotificationDemoView()
            .environment(AppState())
    }
}
