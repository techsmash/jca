import SwiftUI

struct VirtualTourView: View {
    let shrines = MockDataProvider.shrines

    var body: some View {
        ZStack {
            Color(hex: "#0d0608").ignoresSafeArea()

            ScrollView {
                VStack(spacing: 0) {
                    // Featured shrine card
                    FeaturedShrineCard(shrine: shrines[0])
                        .padding(.horizontal, 20)
                        .padding(.top, 16)

                    // Shrine list
                    VStack(alignment: .leading, spacing: 0) {
                        Text("All Shrines & Spaces")
                            .font(JCAFont.headline)
                            .foregroundStyle(Color.jcaCream)
                            .padding(.horizontal, 20)
                            .padding(.top, 28)
                            .padding(.bottom, 16)

                        VStack(spacing: 0) {
                            ForEach(Array(shrines.enumerated()), id: \.element.id) { index, shrine in
                                ShrineRow(shrine: shrine, isLast: index == shrines.count - 1)
                            }
                        }
                        .background(
                            RoundedRectangle(cornerRadius: Radii.base)
                                .fill(Color.white.opacity(0.04))
                                .overlay(
                                    RoundedRectangle(cornerRadius: Radii.base)
                                        .stroke(Color.jcaGold.opacity(0.15), lineWidth: 0.5)
                                )
                        )
                        .padding(.horizontal, 20)
                    }

                    Spacer().frame(height: 40)
                }
            }
        }
        .navigationTitle("Virtual Tour")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color(hex: "#0d0608"), for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }
}

private struct FeaturedShrineCard: View {
    let shrine: Shrine

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: Radii.xl)
                .fill(LinearGradient(
                    colors: [Color(hex: "#2a0a10"), Color(hex: "#0d0608")],
                    startPoint: .top,
                    endPoint: .bottom
                ))
                .overlay(
                    RoundedRectangle(cornerRadius: Radii.xl)
                        .stroke(Color.jcaGold.opacity(0.25), lineWidth: 0.5)
                )

            // Arch decorations
            ZStack {
                // Outer arch
                ArchShape()
                    .stroke(Color.jcaGold.opacity(0.15), lineWidth: 1)
                    .frame(width: 180, height: 120)
                    .offset(y: 20)
                // Inner arch
                ArchShape()
                    .stroke(Color.jcaGold.opacity(0.25), lineWidth: 1)
                    .frame(width: 130, height: 90)
                    .offset(y: 30)
            }

            // DeityGlow
            DeityGlowView(size: 100)
                .offset(y: 10)

            // Info
            VStack {
                Spacer()
                VStack(alignment: .leading, spacing: 4) {
                    Text(shrine.subtitle)
                        .font(JCAFont.label)
                        .foregroundStyle(Color.jcaGold.opacity(0.7))
                        .kerning(1.5)
                        .textCase(.uppercase)
                    Text(shrine.name)
                        .font(JCAFont.headline)
                        .foregroundStyle(.white)
                    Text(shrine.description)
                        .font(JCAFont.caption)
                        .foregroundStyle(Color.jcaCream.opacity(0.6))
                        .lineLimit(2)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
        }
        .frame(height: 240)
        .accessibilityLabel("Featured shrine: \(shrine.name). \(shrine.description)")
    }
}

private struct ArchShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: rect.height))
        path.addLine(to: CGPoint(x: 0, y: rect.height * 0.5))
        path.addQuadCurve(
            to: CGPoint(x: rect.width, y: rect.height * 0.5),
            control: CGPoint(x: rect.width / 2, y: 0)
        )
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        return path
    }
}

private struct ShrineRow: View {
    let shrine: Shrine
    let isLast: Bool

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 14) {
                Text(shrine.romanNumeral)
                    .font(.frauncesItalic(size: 18))
                    .foregroundStyle(Color.jcaGold.opacity(0.7))
                    .frame(width: 24)

                VStack(alignment: .leading, spacing: 2) {
                    Text(shrine.name)
                        .font(JCAFont.subheadline)
                        .foregroundStyle(Color.jcaCream)
                    Text(shrine.subtitle)
                        .font(JCAFont.caption)
                        .foregroundStyle(Color.jcaMuted)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 12))
                    .foregroundStyle(Color.jcaMuted.opacity(0.4))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)

            if !isLast {
                Divider()
                    .overlay(Color.jcaGold.opacity(0.1))
                    .padding(.horizontal, 16)
            }
        }
        .accessibilityLabel("\(shrine.romanNumeral). \(shrine.name), \(shrine.subtitle)")
    }
}

#Preview {
    NavigationStack {
        VirtualTourView()
    }
}
