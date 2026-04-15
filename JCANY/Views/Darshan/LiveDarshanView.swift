import SwiftUI

struct LiveDarshanView: View {
    @State private var viewModel = DarshanViewModel()
    @State private var livePulse = false

    var body: some View {
        ZStack {
            Color(hex: "#08040a").ignoresSafeArea()

            ScrollView {
                VStack(spacing: 0) {
                    // Featured stream
                    if let featured = viewModel.featuredStream {
                        FeaturedStreamCard(stream: featured, livePulse: $livePulse)
                            .padding(.horizontal, 20)
                            .padding(.top, 16)
                    }

                    // Stream grid
                    VStack(alignment: .leading, spacing: 14) {
                        Text("Other Streams")
                            .font(JCAFont.headline)
                            .foregroundStyle(Color.jcaCream)
                            .padding(.horizontal, 20)
                            .padding(.top, 24)

                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                            ForEach(viewModel.gridStreams) { stream in
                                StreamTile(stream: stream)
                            }
                        }
                        .padding(.horizontal, 20)
                    }

                    // Aarti schedule
                    VStack(alignment: .leading, spacing: 14) {
                        Text("Today's Schedule")
                            .font(JCAFont.headline)
                            .foregroundStyle(Color.jcaCream)
                            .padding(.horizontal, 20)
                            .padding(.top, 24)

                        VStack(spacing: 0) {
                            ForEach(viewModel.aartiSchedule) { item in
                                AartiRow(item: item)
                                if item.id != viewModel.aartiSchedule.last?.id {
                                    Divider()
                                        .overlay(Color.jcaGold.opacity(0.15))
                                }
                            }
                        }
                        .background(
                            RoundedRectangle(cornerRadius: Radii.base)
                                .fill(Color.jcaGold.opacity(0.05))
                                .overlay(
                                    RoundedRectangle(cornerRadius: Radii.base)
                                        .stroke(Color.jcaGold.opacity(0.2), lineWidth: 0.5)
                                )
                        )
                        .padding(.horizontal, 20)
                    }

                    Spacer().frame(height: 40)
                }
            }
        }
        .navigationTitle("Live Darshan")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color(hex: "#08040a"), for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .onAppear {
            withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                livePulse = true
            }
        }
    }
}

struct FeaturedStreamCard: View {
    let stream: LiveStream
    @Binding var livePulse: Bool

    var body: some View {
        ZStack {
            // Gradient background
            RoundedRectangle(cornerRadius: Radii.xl)
                .fill(
                    RadialGradient(
                        colors: [Color.jcaCrimson.opacity(0.6), Color(hex: "#1a0810"), Color(hex: "#08040a")],
                        center: .center,
                        startRadius: 30,
                        endRadius: 180
                    )
                )
            .overlay(
                RoundedRectangle(cornerRadius: Radii.xl)
                    .stroke(Color.jcaGold.opacity(0.2), lineWidth: 0.5)
            )

            // Deity glow
            DeityGlowView(size: 120)
                .padding(.top, 20)

            // Overlay
            VStack {
                // LIVE badge
                HStack {
                    HStack(spacing: 6) {
                        Circle()
                            .fill(Color.red)
                            .frame(width: 8, height: 8)
                            .opacity(livePulse ? 1.0 : 0.3)
                        Text("LIVE")
                            .font(JCAFont.label)
                            .foregroundStyle(.white)
                            .kerning(1.5)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(
                        Capsule().fill(Color.red.opacity(0.8))
                    )
                    Spacer()
                    Text("\(stream.viewerCount) watching")
                        .font(JCAFont.caption)
                        .foregroundStyle(Color.jcaGoldLight.opacity(0.8))
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)

                Spacer()

                // Stream info
                VStack(alignment: .leading, spacing: 4) {
                    Text(stream.title)
                        .font(JCAFont.headline)
                        .foregroundStyle(.white)
                    Text(stream.subtitle)
                        .font(JCAFont.caption)
                        .foregroundStyle(Color.jcaGoldLight.opacity(0.7))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
            }
        }
        .frame(height: 220)
        .accessibilityLabel("\(stream.title), Live stream, \(stream.viewerCount) watching")
    }
}

struct StreamTile: View {
    let stream: LiveStream

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack {
                RoundedRectangle(cornerRadius: Radii.m)
                    .fill(Color.jcaCrimson.opacity(0.15))
                    .frame(height: 80)
                Image(systemName: "video.fill")
                    .font(.system(size: 22))
                    .foregroundStyle(Color.jcaGold.opacity(0.6))

                if let time = stream.scheduleTime {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Text(time)
                                .font(JCAFont.caption)
                                .foregroundStyle(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 3)
                                .background(Color.black.opacity(0.6))
                                .clipShape(Capsule())
                                .padding(6)
                        }
                    }
                }
            }
            Text(stream.title)
                .font(JCAFont.caption)
                .foregroundStyle(Color.jcaCream)
                .lineLimit(2)
            Text(stream.subtitle)
                .font(.inter(size: 10))
                .foregroundStyle(Color.jcaMuted)
        }
        .accessibilityLabel("\(stream.title): \(stream.subtitle)")
    }
}

struct AartiRow: View {
    let item: AartiSchedule

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(item.name)
                    .font(JCAFont.subheadline)
                    .foregroundStyle(item.isNext ? Color.jcaGold : Color.jcaCream)
            }
            Spacer()
            Text(item.time)
                .font(.fraunces(size: 14, weight: .medium))
                .foregroundStyle(item.isNext ? Color.jcaGold : Color.jcaCream.opacity(0.7))
            if item.isNext {
                Text("NEXT")
                    .font(JCAFont.label)
                    .foregroundStyle(Color.jcaGold)
                    .kerning(1)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .overlay(Capsule().stroke(Color.jcaGold.opacity(0.5), lineWidth: 0.5))
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .accessibilityLabel("\(item.name) at \(item.time)\(item.isNext ? ", next" : "")")
    }
}

#Preview {
    NavigationStack {
        LiveDarshanView()
    }
}
