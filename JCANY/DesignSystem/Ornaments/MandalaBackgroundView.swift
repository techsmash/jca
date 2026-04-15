import SwiftUI

struct MandalaBackgroundView: View {
    var opacity: Double = 0.08
    var size: CGFloat = 460
    var animate: Bool = true

    @State private var rotation: Double = 0

    var body: some View {
        Canvas { context, canvasSize in
            let w = canvasSize.width
            let h = canvasSize.height
            let cx = w / 2
            let cy = h / 2
            let radii: [CGFloat] = [0.47, 0.39, 0.30, 0.20, 0.10].map { $0 * w }
            let lineColor = Color.jcaGold.opacity(0.6)

            // Concentric circles
            for r in radii {
                var path = Path()
                path.addEllipse(in: CGRect(x: cx - r, y: cy - r, width: r * 2, height: r * 2))
                context.stroke(path, with: .color(lineColor), lineWidth: 0.5)
            }

            // Diagonal spokes
            let spokeCount = 16
            let outerR = radii[0]
            for i in 0..<spokeCount {
                let angle = Double(i) * (.pi * 2 / Double(spokeCount))
                var path = Path()
                path.move(to: CGPoint(x: cx, y: cy))
                path.addLine(to: CGPoint(
                    x: cx + cos(angle) * outerR,
                    y: cy + sin(angle) * outerR
                ))
                context.stroke(path, with: .color(lineColor), lineWidth: 0.4)
            }

            // Petal shapes at outer ring
            let petalCount = 8
            let petalR = outerR * 0.18
            for i in 0..<petalCount {
                let angle = Double(i) * (.pi * 2 / Double(petalCount))
                let px = cx + cos(angle) * outerR * 0.7
                let py = cy + sin(angle) * outerR * 0.7
                var path = Path()
                path.addEllipse(in: CGRect(x: px - petalR, y: py - petalR, width: petalR * 2, height: petalR * 2))
                context.stroke(path, with: .color(lineColor), lineWidth: 0.4)
            }
        }
        .frame(width: size, height: size)
        .opacity(opacity)
        .rotationEffect(.degrees(rotation))
        .onAppear {
            if animate {
                withAnimation(.linear(duration: 90).repeatForever(autoreverses: false)) {
                    rotation = 360
                }
            }
        }
        .accessibilityHidden(true)
    }
}

#Preview {
    ZStack {
        Color.jcaCrimson
        MandalaBackgroundView()
    }
}
