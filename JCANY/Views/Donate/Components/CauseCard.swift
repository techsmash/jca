import SwiftUI

struct CauseCard: View {
    let category: DonationCategory
    var isSelected: Bool = false

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(isSelected ? Color.jcaCrimson.opacity(0.12) : Color.jcaCrimson.opacity(0.07))
                    .frame(width: 42, height: 42)
                Image(systemName: category.iconName)
                    .font(.system(size: 17, weight: .medium))
                    .foregroundStyle(Color.jcaCrimson)
            }

            VStack(alignment: .leading, spacing: 3) {
                Text(category.name)
                    .font(JCAFont.title)
                    .foregroundStyle(Color.jcaInk)
                Text(category.description)
                    .font(JCAFont.caption)
                    .foregroundStyle(Color.jcaMuted)
                    .lineLimit(1)
            }
            Spacer()
            if category.defaultAmount > 0 {
                Text(formatAmount(category.defaultAmount))
                    .font(JCAFont.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.jcaCrimson)
            }
            Image(systemName: "chevron.right")
                .font(.system(size: 12))
                .foregroundStyle(Color.jcaMuted.opacity(0.4))
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: Radii.base)
                .fill(Color.jcaPaper)
                .overlay(
                    RoundedRectangle(cornerRadius: Radii.base)
                        .stroke(isSelected ? Color.jcaCrimson : Color.jcaBorder, lineWidth: isSelected ? 1.5 : 0.5)
                )
                .shadowSm()
        )
        .contentShape(Rectangle())
        .animation(.spring(duration: 0.2), value: isSelected)
        .accessibilityLabel("\(category.name): \(category.description)\(category.defaultAmount > 0 ? ". Suggested amount: \(formatAmount(category.defaultAmount))" : "")")
    }

    private func formatAmount(_ amount: Decimal) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_US")
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSDecimalNumber(decimal: amount)) ?? "$\(amount)"
    }
}
