import SwiftUI

struct CreditCardPreview: View {
    let cardNumber: String
    let cardholderName: String
    let expiry: String

    private var maskedNumber: String {
        let digits = cardNumber.filter(\.isNumber)
        var result = ""
        for (i, char) in digits.prefix(16).enumerated() {
            if i > 0 && i % 4 == 0 { result += " " }
            result.append(char)
        }
        // Pad remaining groups
        let remaining = 16 - digits.prefix(16).count
        if !result.isEmpty && remaining > 0 {
            let lastGroupCount = digits.count % 4
            if lastGroupCount > 0 {
                result += String(repeating: "•", count: 4 - lastGroupCount)
            }
        }
        // Fill remaining groups
        let groups = result.components(separatedBy: " ")
        var finalGroups = groups
        while finalGroups.count < 4 { finalGroups.append("••••") }
        return finalGroups.prefix(4).joined(separator: " ")
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(LinearGradient(
                    colors: [Color.jcaCrimson, Color(hex: "#3a0810")],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.jcaGold.opacity(0.3), lineWidth: 0.5)
                )
                .shadow(color: Color.jcaCrimson.opacity(0.3), radius: 16, y: 8)

            // Background pattern
            ZStack {
                Circle()
                    .stroke(Color.white.opacity(0.06), lineWidth: 40)
                    .frame(width: 300, height: 300)
                    .offset(x: 80, y: -60)
                Circle()
                    .stroke(Color.white.opacity(0.04), lineWidth: 30)
                    .frame(width: 200, height: 200)
                    .offset(x: -60, y: 60)
            }

            VStack(alignment: .leading, spacing: 0) {
                // JCA branding
                HStack {
                    Text("JCA")
                        .font(.fraunces(size: 18, weight: .semibold))
                        .foregroundStyle(Color.jcaGold)
                    Spacer()
                    // Chip
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.jcaGold.opacity(0.8))
                        .frame(width: 32, height: 24)
                        .overlay(
                            RoundedRectangle(cornerRadius: 2)
                                .stroke(Color.jcaGoldDeep.opacity(0.5), lineWidth: 0.5)
                                .padding(4)
                        )
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)

                Spacer()

                // Card number
                Text(maskedNumber)
                    .font(.custom("Courier", size: 16))
                    .foregroundStyle(.white)
                    .tracking(2)
                    .padding(.horizontal, 20)

                Spacer()

                // Name and expiry
                HStack(alignment: .bottom) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("CARDHOLDER")
                            .font(JCAFont.label)
                            .foregroundStyle(Color.jcaGoldLight.opacity(0.6))
                            .kerning(0.5)
                        Text(cardholderName.isEmpty ? "YOUR NAME" : cardholderName.uppercased())
                            .font(.inter(size: 13, weight: .semibold))
                            .foregroundStyle(cardholderName.isEmpty ? Color.white.opacity(0.4) : .white)
                            .lineLimit(1)
                    }
                    Spacer()
                    VStack(alignment: .trailing, spacing: 2) {
                        Text("EXPIRES")
                            .font(JCAFont.label)
                            .foregroundStyle(Color.jcaGoldLight.opacity(0.6))
                            .kerning(0.5)
                        Text(expiry.isEmpty ? "MM/YY" : expiry)
                            .font(.inter(size: 13, weight: .semibold))
                            .foregroundStyle(expiry.isEmpty ? Color.white.opacity(0.4) : .white)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
        }
        .frame(height: 180)
        .accessibilityLabel("Credit card preview")
        .accessibilityHidden(true)
    }
}

#Preview {
    ZStack {
        Color.jcaCream
        CreditCardPreview(
            cardNumber: "4111 1111 1111 1111",
            cardholderName: "Manan Shah",
            expiry: "08/28"
        )
        .padding(24)
    }
}
