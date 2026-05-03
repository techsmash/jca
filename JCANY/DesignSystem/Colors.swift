import SwiftUI

extension Color {
    static let jcaCrimson      = Color(hex: "#a8202c")
    static let jcaCrimsonDeep  = Color(hex: "#7a1620")
    static let jcaCrimsonSoft  = Color(hex: "#c84252")
    static let jcaGold         = Color(hex: "#c9a961")
    static let jcaGoldLight    = Color(hex: "#e3c889")
    static let jcaGoldDeep     = Color(hex: "#8c6f30")
    static let jcaCream        = Color(hex: "#faf6ef")
    static let jcaCreamWarm    = Color(hex: "#f4ecdd")
    static let jcaPaper        = Color.white
    static let jcaInk          = Color(hex: "#1c1410")
    static let jcaInkSoft      = Color(hex: "#4a3d35")
    static let jcaMuted        = Color(hex: "#8a7864")
    static let jcaBorder       = Color(hex: "#1c1410").opacity(0.08)
    static let jcaBorderWarm   = Color(hex: "#a8202c").opacity(0.12)
    static let jcaSacredDark    = Color(hex: "#08040a")

    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
