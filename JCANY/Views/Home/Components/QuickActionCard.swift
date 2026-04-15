import SwiftUI

struct QuickActionCard: View {
    let title: String
    let subtitle: String
    let icon: String
    var isGold: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(iconBg)
                    .frame(width: 36, height: 36)
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(iconColor)
            }
            VStack(alignment: .leading, spacing: 1) {
                Text(title)
                    .font(JCAFont.title)
                    .foregroundStyle(Color.jcaInk)
                Text(subtitle)
                    .font(JCAFont.caption)
                    .foregroundStyle(Color.jcaMuted)
            }
        }
        .padding(14)
        .frame(minWidth: 130)
        .background(
            RoundedRectangle(cornerRadius: Radii.base)
                .fill(Color.jcaPaper)
                .overlay(
                    RoundedRectangle(cornerRadius: Radii.base)
                        .stroke(Color.jcaBorder, lineWidth: 0.5)
                )
                .shadowSm()
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title): \(subtitle)")
    }

    private var iconBg: Color {
        isGold ? Color.jcaGold.opacity(0.15) : Color.jcaCrimson.opacity(0.08)
    }
    private var iconColor: Color {
        isGold ? Color.jcaGoldDeep : Color.jcaCrimson
    }
}
