import SwiftUI

struct PaymentMethodOptionCard: View {
    let paymentType: PaymentType
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            action()
        }) {
            ZStack(alignment: .topTrailing) {
                VStack(spacing: 8) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(iconGradient)
                            .frame(width: 40, height: 28)
                        Text(iconLabel)
                            .font(.inter(size: 14, weight: .bold))
                            .foregroundStyle(.white)
                    }
                    Text(paymentType.displayName)
                        .font(JCAFont.caption)
                        .foregroundStyle(isSelected ? Color.jcaInk : Color.jcaMuted)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(
                    RoundedRectangle(cornerRadius: Radii.m)
                        .fill(Color.jcaPaper)
                        .overlay(
                            RoundedRectangle(cornerRadius: Radii.m)
                                .stroke(isSelected ? Color.jcaCrimson : Color.jcaBorder, lineWidth: isSelected ? 1.5 : 0.5)
                        )
                        .shadowSm()
                )
                .animation(.spring(duration: 0.2), value: isSelected)

                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 16))
                        .foregroundStyle(Color.jcaCrimson)
                        .background(Circle().fill(Color.jcaPaper))
                        .offset(x: 6, y: -6)
                }
            }
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(paymentType.displayName)\(isSelected ? ", selected" : "")")
    }

    private var iconLabel: String {
        switch paymentType {
        case .creditCard, .debitCard: return "VISA"
        case .applePay:  return ""
        case .googlePay: return "G"
        case .payPal:    return "P"
        case .zelle:     return "Z"
        case .ach:       return "ACH"
        }
    }

    private var iconGradient: LinearGradient {
        switch paymentType {
        case .creditCard, .debitCard:
            return LinearGradient(colors: [Color(hex: "#1a1f71"), Color(hex: "#1565c0")], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .applePay:
            return LinearGradient(colors: [Color.black, Color(hex: "#1a1a1a")], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .googlePay:
            return LinearGradient(colors: [Color(hex: "#4285F4"), Color(hex: "#34A853")], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .payPal:
            return LinearGradient(colors: [Color(hex: "#003087"), Color(hex: "#009cde")], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .zelle:
            return LinearGradient(colors: [Color(hex: "#6b2fa0"), Color(hex: "#9c27b0")], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .ach:
            return LinearGradient(colors: [Color(hex: "#455a64"), Color(hex: "#607d8b")], startPoint: .topLeading, endPoint: .bottomTrailing)
        }
    }
}
