import SwiftUI

struct SplashView: View {
    @State private var navigateToSignIn = false
    let onContinueAsGuest: () -> Void

    var body: some View {
        ZStack {
            // Crimson radial gradient background
            RadialGradient(
                colors: [Color(hex: "#b82834"), Color.jcaCrimson, Color.jcaCrimsonDeep],
                center: .top,
                startRadius: 0,
                endRadius: 500
            )
            .ignoresSafeArea()

            // Subtle gold glow
            RadialGradient(
                colors: [Color.jcaGold.opacity(0.18), Color.clear],
                center: UnitPoint(x: 0.5, y: 0.3),
                startRadius: 0,
                endRadius: 200
            )
            .ignoresSafeArea()

            // Rotating mandala
            MandalaBackgroundView(opacity: 0.08, size: 460, animate: true)

            VStack(spacing: 0) {
                Spacer().frame(height: 60)

                // Swastika
                JainSwastikaView(size: 86, color: Color.jcaGoldLight.opacity(0.9), dotColor: Color.jcaGoldLight)
                    .padding(.top, 16)

                // Title
                VStack(spacing: 6) {
                    Text("Jain Center")
                        .font(JCAFont.displayLarge)
                        .foregroundStyle(Color.jcaCream)
                    Text("of America, New York")
                        .font(.frauncesItalic(size: 18, weight: .light))
                        .foregroundStyle(Color.jcaGoldLight)
                }
                .padding(.top, 24)

                // Navkar Mantra
                VStack(spacing: 10) {
                    Text("NAVKAR MANTRA")
                        .font(JCAFont.label)
                        .foregroundStyle(Color.jcaGoldLight)
                        .kerning(3)
                        .opacity(0.8)
                    VStack(spacing: 2) {
                        ForEach(navkarLines, id: \.self) { line in
                            Text(line)
                                .font(.frauncesItalic(size: 14))
                                .foregroundStyle(Color.jcaCream.opacity(0.92))
                                .multilineTextAlignment(.center)
                                .lineSpacing(4)
                        }
                    }
                }
                .padding(.vertical, 22)
                .padding(.horizontal, 18)
                .overlay(
                    VStack {
                        Rectangle()
                            .fill(Color.jcaGold.opacity(0.3))
                            .frame(height: 1)
                        Spacer()
                        Rectangle()
                            .fill(Color.jcaGold.opacity(0.3))
                            .frame(height: 1)
                    }
                )
                .padding(.top, 28)

                Spacer()

                // CTA Buttons
                VStack(spacing: 0) {
                    NavigationLink(value: "signin") {
                        Text("Sign In")
                            .font(JCAFont.bodyMedium)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.jcaCrimson)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 17)
                            .background(
                                Capsule()
                                    .fill(Color.jcaCream)
                                    .shadow(color: .black.opacity(0.25), radius: 12, y: 6)
                            )
                    }
                    .accessibilityLabel("Sign In")

                    Button(action: onContinueAsGuest) {
                        Text("Continue as Guest")
                            .font(JCAFont.subheadline)
                            .foregroundStyle(Color.jcaCream.opacity(0.85))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 15)
                    }
                    .accessibilityLabel("Continue as guest")
                }
                .padding(.bottom, 40)
            }
            .padding(.horizontal, 36)
        }
        .navigationDestination(for: String.self) { _ in
            SignInView()
        }
        .preferredColorScheme(.dark)
    }

    private var navkarLines: [String] {
        [
            "Namo Arihantanam",
            "Namo Siddhanam",
            "Namo Ayariyanam",
            "Namo Uvajjhayanam",
            "Namo Loe Savva Sahunam"
        ]
    }
}

#Preview {
    NavigationStack {
        SplashView(onContinueAsGuest: {})
    }
}
