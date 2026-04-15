import SwiftUI

struct ShadowStyle {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat
}

enum JCAShadow {
    static let sm = ShadowStyle(
        color: Color(hex: "#1c1410").opacity(0.06),
        radius: 3,
        x: 0,
        y: 1
    )
    static let md = ShadowStyle(
        color: Color(hex: "#1c1410").opacity(0.08),
        radius: 8,
        x: 0,
        y: 4
    )
}

extension View {
    func shadowSm() -> some View {
        self
            .shadow(color: JCAShadow.sm.color, radius: JCAShadow.sm.radius, x: JCAShadow.sm.x, y: JCAShadow.sm.y)
    }

    func shadowMd() -> some View {
        self
            .shadow(color: JCAShadow.md.color, radius: JCAShadow.md.radius, x: JCAShadow.md.x, y: JCAShadow.md.y)
    }
}
