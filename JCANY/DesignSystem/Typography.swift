import SwiftUI

extension Font {
    // Fraunces — serif display
    static func fraunces(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        switch weight {
        case .semibold, .bold, .heavy, .black:
            return .custom("Fraunces-SemiBold", size: size)
        case .medium:
            return .custom("Fraunces-Medium", size: size)
        case .light, .thin, .ultraLight:
            return .custom("Fraunces-Light", size: size)
        default:
            return .custom("Fraunces-Regular", size: size)
        }
    }

    static func frauncesItalic(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        switch weight {
        case .semibold, .bold:
            return .custom("Fraunces-SemiBoldItalic", size: size)
        case .light:
            return .custom("Fraunces-LightItalic", size: size)
        default:
            return .custom("Fraunces-Italic", size: size)
        }
    }

    // Inter — UI text
    static func inter(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        switch weight {
        case .semibold:
            return .custom("Inter-SemiBold", size: size)
        case .bold, .heavy, .black:
            return .custom("Inter-Bold", size: size)
        case .medium:
            return .custom("Inter-Medium", size: size)
        case .light:
            return .custom("Inter-Light", size: size)
        default:
            return .custom("Inter-Regular", size: size)
        }
    }
}

enum JCAFont {
    /// Fraunces, 32–38pt, weight 500 — big serif headers
    static var displayLarge: Font { .fraunces(size: 34, weight: .medium) }
    /// Fraunces italic — em accents
    static var displayItalic: Font { .frauncesItalic(size: 34, weight: .light) }
    /// Fraunces, 20–22pt, weight 600
    static var headline: Font { .fraunces(size: 20, weight: .semibold) }
    /// Fraunces, 16pt, weight 600
    static var title: Font { .fraunces(size: 16, weight: .semibold) }
    /// Fraunces italic small
    static var titleItalic: Font { .frauncesItalic(size: 14) }
    /// Inter, 14pt, weight 400–500
    static var body: Font { .inter(size: 14, weight: .regular) }
    /// Inter, 15pt, weight 500
    static var bodyMedium: Font { .inter(size: 15, weight: .medium) }
    /// Inter, 11pt, weight 500
    static var caption: Font { .inter(size: 11, weight: .medium) }
    /// Inter, 10pt, weight 600, uppercase tracking
    static var label: Font { .inter(size: 10, weight: .semibold) }
    /// Inter, 13pt, weight 500
    static var subheadline: Font { .inter(size: 13, weight: .medium) }
}
