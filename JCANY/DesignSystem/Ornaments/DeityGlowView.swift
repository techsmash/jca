import SwiftUI

struct DeityGlowView: View {
    var size: CGFloat = 120

    var body: some View {
        ZStack {
            // Outer glow
            Circle()
                .fill(
                    RadialGradient(
                        colors: [Color.jcaGold.opacity(0.3), Color.clear],
                        center: .center,
                        startRadius: 0,
                        endRadius: size * 0.6
                    )
                )
                .frame(width: size * 1.4, height: size * 1.4)

            // Silhouette shape - stylized tirthankar
            TirthankaSilhouette()
                .fill(
                    LinearGradient(
                        colors: [Color.jcaGoldLight.opacity(0.7), Color.jcaGold.opacity(0.4)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: size * 0.55, height: size)
        }
        .frame(width: size * 1.4, height: size * 1.4)
        .accessibilityLabel("Tirthankar deity silhouette")
        .accessibilityHidden(true)
    }
}

private struct TirthankaSilhouette: Shape {
    func path(in rect: CGRect) -> Path {
        let w = rect.width
        let h = rect.height
        var path = Path()

        // Head (circle)
        let headR = w * 0.2
        let headCX = w * 0.5
        let headCY = h * 0.12
        path.addEllipse(in: CGRect(x: headCX - headR, y: headCY - headR, width: headR * 2, height: headR * 2))

        // Body - triangular meditating pose
        path.move(to: CGPoint(x: w * 0.5, y: headCY + headR))
        path.addLine(to: CGPoint(x: w * 0.05, y: h * 0.85))
        path.addQuadCurve(
            to: CGPoint(x: w * 0.95, y: h * 0.85),
            control: CGPoint(x: w * 0.5, y: h * 0.95)
        )
        path.closeSubpath()

        return path
    }
}

#Preview {
    ZStack {
        Color(hex: "#08040a")
        DeityGlowView(size: 120)
    }
}
