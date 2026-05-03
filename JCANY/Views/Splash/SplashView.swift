import SwiftUI
import AVKit
import AVFoundation

// ─────────────────────────────────────────────────────────────
// Add temple-bg.mp4 to the Xcode project (Build Phases → Copy
// Bundle Resources) and the video will play automatically.
// Without the file the crimson gradient renders as a fallback.
// ─────────────────────────────────────────────────────────────

struct SplashView: View {
    let onContinueAsGuest: () -> Void

    @State private var showSymbol  = false
    @State private var showTitle   = false
    @State private var showMantra  = false
    @State private var showButtons = false

    var body: some View {
        ZStack {
            // Layer 1 — video background (or solid black fallback)
            LoopingVideoBackground(videoName: "temple-bg")
                .ignoresSafeArea()

            // Layer 2 — crimson brand tint so the video reads as JCA
            LinearGradient(
                colors: [
                    Color.jcaCrimsonDeep.opacity(0.62),
                    Color.jcaCrimson.opacity(0.38),
                    Color.jcaSacredDark.opacity(0.55),
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            // Layer 3 — stronger vignette top & bottom for legibility
            VStack(spacing: 0) {
                LinearGradient(
                    colors: [Color.jcaSacredDark.opacity(0.7), Color.clear],
                    startPoint: .top, endPoint: .bottom
                )
                .frame(height: 200)
                Spacer()
                LinearGradient(
                    colors: [Color.clear, Color.jcaSacredDark.opacity(0.88)],
                    startPoint: .top, endPoint: .bottom
                )
                .frame(height: 260)
            }
            .ignoresSafeArea()

            // Layer 4 — content
            VStack(spacing: 0) {
                Spacer().frame(height: 52)

                // Swastika symbol with gold halo
                symbolView
                    .opacity(showSymbol ? 1 : 0)
                    .offset(y: showSymbol ? 0 : 28)
                    .animation(.spring(response: 0.7, dampingFraction: 0.75), value: showSymbol)

                // Title
                titleView
                    .padding(.top, 22)
                    .opacity(showTitle ? 1 : 0)
                    .offset(y: showTitle ? 0 : 20)
                    .animation(.spring(response: 0.65, dampingFraction: 0.8), value: showTitle)

                // Navkar Mantra — glassmorphism card
                mantraCard
                    .padding(.top, 32)
                    .opacity(showMantra ? 1 : 0)
                    .offset(y: showMantra ? 0 : 18)
                    .animation(.spring(response: 0.65, dampingFraction: 0.85), value: showMantra)

                Spacer()

                // CTA buttons
                ctaButtons
                    .padding(.bottom, 44)
                    .opacity(showButtons ? 1 : 0)
                    .offset(y: showButtons ? 0 : 12)
                    .animation(.spring(response: 0.55, dampingFraction: 0.8), value: showButtons)
            }
            .padding(.horizontal, 32)
        }
        .navigationDestination(for: String.self) { _ in
            SignInView()
        }
        .preferredColorScheme(.dark)
        .onAppear(perform: runEntrance)
    }

    // MARK: - Entrance

    private func runEntrance() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) { showSymbol  = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.45) { showTitle   = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.72) { showMantra  = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.00) { showButtons = true }
    }

    // MARK: - Sub-views

    @ViewBuilder
    private var symbolView: some View {
        ZStack {
            // Soft gold atmospheric glow
            Circle()
                .fill(Color.jcaGold.opacity(0.18))
                .frame(width: 140, height: 140)
                .blur(radius: 28)
            Circle()
                .fill(Color.jcaGold.opacity(0.08))
                .frame(width: 200, height: 200)
                .blur(radius: 40)
            JainSwastikaView(size: 88, color: Color.jcaGoldLight, dotColor: Color.jcaGoldLight)
        }
    }

    @ViewBuilder
    private var titleView: some View {
        VStack(spacing: 5) {
            Text("Jain Center")
                .font(.fraunces(size: 38, weight: .semibold))
                .foregroundStyle(Color.jcaCream)
                .tracking(0.5)
            Text("of America, New York")
                .font(.frauncesItalic(size: 17, weight: .light))
                .foregroundStyle(Color.jcaGoldLight.opacity(0.9))
        }
    }

    @ViewBuilder
    private var mantraCard: some View {
        VStack(spacing: 14) {
            // Label
            HStack(spacing: 8) {
                Rectangle()
                    .fill(Color.jcaGold.opacity(0.45))
                    .frame(height: 0.5)
                Text("NAVKAR MANTRA")
                    .font(JCAFont.label)
                    .foregroundStyle(Color.jcaGoldLight.opacity(0.85))
                    .kerning(2.5)
                Rectangle()
                    .fill(Color.jcaGold.opacity(0.45))
                    .frame(height: 0.5)
            }

            // Lines
            VStack(spacing: 5) {
                ForEach(navkarLines, id: \.self) { line in
                    Text(line)
                        .font(.frauncesItalic(size: 14))
                        .foregroundStyle(Color.jcaCream.opacity(0.93))
                        .multilineTextAlignment(.center)
                }
            }
        }
        .padding(.vertical, 22)
        .padding(.horizontal, 24)
        .background(.ultraThinMaterial)
        .environment(\.colorScheme, .dark)
        .clipShape(RoundedRectangle(cornerRadius: Radii.base))
        .overlay(
            RoundedRectangle(cornerRadius: Radii.base)
                .stroke(
                    LinearGradient(
                        colors: [Color.jcaGold.opacity(0.35), Color.jcaGold.opacity(0.1)],
                        startPoint: .topLeading, endPoint: .bottomTrailing
                    ),
                    lineWidth: 0.8
                )
        )
    }

    @ViewBuilder
    private var ctaButtons: some View {
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
                            .shadow(color: .black.opacity(0.3), radius: 16, y: 6)
                    )
            }
            .accessibilityLabel("Sign In")

            Button(action: onContinueAsGuest) {
                Text("Continue as Guest")
                    .font(JCAFont.subheadline)
                    .foregroundStyle(Color.jcaCream.opacity(0.8))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
            }
            .accessibilityLabel("Continue as guest")
        }
    }

    private var navkarLines: [String] {[
        "Namo Arihantanam",
        "Namo Siddhanam",
        "Namo Ayariyanam",
        "Namo Uvajjhayanam",
        "Namo Loe Savva Sahunam",
    ]}
}

// MARK: - Looping Video Background

private struct LoopingVideoBackground: UIViewRepresentable {
    let videoName: String

    func makeCoordinator() -> Coordinator { Coordinator() }

    func makeUIView(context: Context) -> PlayerView {
        let view = PlayerView()

        guard let url = Bundle.main.url(forResource: videoName, withExtension: "mp4") else {
            // No video file — crimsoon gradient overlay is the fallback
            return view
        }

        let asset = AVURLAsset(url: url)
        let item  = AVPlayerItem(asset: asset)
        let player = AVQueuePlayer()
        player.isMuted = true
        player.preventsDisplaySleepDuringVideoPlayback = false

        let looper = AVPlayerLooper(player: player, templateItem: item)

        view.playerLayer.player = player
        view.playerLayer.videoGravity = .resizeAspectFill

        context.coordinator.player = player
        context.coordinator.looper  = looper

        // Slight delay so the first frame is visible before play starts
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            player.play()
        }

        return view
    }

    func updateUIView(_ uiView: PlayerView, context: Context) {}

    // PlayerView overrides layerClass so the AVPlayerLayer auto-resizes
    // with the view bounds — no manual frame updates needed.
    final class PlayerView: UIView {
        override class var layerClass: AnyClass { AVPlayerLayer.self }
        var playerLayer: AVPlayerLayer { layer as! AVPlayerLayer }

        override init(frame: CGRect) {
            super.init(frame: frame)
            backgroundColor = UIColor(Color.jcaSacredDark)
        }
        required init?(coder: NSCoder) { super.init(coder: coder) }
    }

    final class Coordinator {
        var player: AVQueuePlayer?
        var looper: AVPlayerLooper?
    }
}

#Preview {
    NavigationStack {
        SplashView(onContinueAsGuest: {})
    }
}
