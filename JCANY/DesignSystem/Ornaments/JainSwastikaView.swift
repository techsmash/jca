import SwiftUI

struct JainSwastikaView: View {
    var size: CGFloat = 86
    var color: Color = .jcaGoldLight
    var dotColor: Color = .jcaGoldLight

    var body: some View {
        Canvas { context, canvasSize in
            let w = canvasSize.width
            let h = canvasSize.height
            let cx = w / 2
            let cy = h / 2
            let armW: CGFloat = w * 0.18
            let armLen: CGFloat = w * 0.36

            // Draw the four arms of the swastika
            // Center square
            let centerSize = armW
            let centerRect = CGRect(
                x: cx - centerSize / 2,
                y: cy - centerSize / 2,
                width: centerSize,
                height: centerSize
            )
            context.fill(Path(centerRect), with: .color(color))

            // Four arms
            // Top arm
            let topArm = Path(CGRect(x: cx - armW / 2, y: cy - armLen - armW / 2, width: armW, height: armLen))
            context.fill(topArm, with: .color(color))
            // Top arm turns right
            let topTurn = Path(CGRect(x: cx + armW / 2, y: cy - armLen - armW / 2, width: armLen * 0.45, height: armW))
            context.fill(topTurn, with: .color(color))

            // Right arm
            let rightArm = Path(CGRect(x: cx + armW / 2, y: cy - armW / 2, width: armLen, height: armW))
            context.fill(rightArm, with: .color(color))
            // Right arm turns down
            let rightTurn = Path(CGRect(x: cx + armLen + armW / 2 - armW, y: cy + armW / 2, width: armW, height: armLen * 0.45))
            context.fill(rightTurn, with: .color(color))

            // Bottom arm
            let bottomArm = Path(CGRect(x: cx - armW / 2, y: cy + armW / 2, width: armW, height: armLen))
            context.fill(bottomArm, with: .color(color))
            // Bottom arm turns left
            let bottomTurn = Path(CGRect(x: cx - armW / 2 - armLen * 0.45, y: cy + armLen + armW / 2 - armW, width: armLen * 0.45, height: armW))
            context.fill(bottomTurn, with: .color(color))

            // Left arm
            let leftArm = Path(CGRect(x: cx - armLen - armW / 2, y: cy - armW / 2, width: armLen, height: armW))
            context.fill(leftArm, with: .color(color))
            // Left arm turns up
            let leftTurn = Path(CGRect(x: cx - armLen - armW / 2, y: cy - armW / 2 - armLen * 0.45, width: armW, height: armLen * 0.45))
            context.fill(leftTurn, with: .color(color))

            // Three dots above the swastika
            let dotR: CGFloat = w * 0.04
            let dotY = cy - armLen - armW - dotR * 3
            for i in -1...1 {
                let dotX = cx + CGFloat(i) * dotR * 3
                let dotRect = CGRect(x: dotX - dotR, y: dotY - dotR, width: dotR * 2, height: dotR * 2)
                context.fill(Path(ellipseIn: dotRect), with: .color(dotColor))
            }
        }
        .frame(width: size, height: size)
        .accessibilityLabel("Jain Swastika symbol")
        .accessibilityHidden(true)
    }
}

#Preview {
    ZStack {
        Color.jcaCrimson
        JainSwastikaView(size: 100)
    }
}
