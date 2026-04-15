import SwiftUI

struct ParvaCard: View {
    let parva: ParvaDay

    var body: some View {
        HStack(spacing: 14) {
            // Countdown
            VStack(spacing: 2) {
                Text("\(parva.daysUntil)")
                    .font(.fraunces(size: 22, weight: .semibold))
                    .foregroundStyle(Color.jcaCrimson)
                Text("days")
                    .font(JCAFont.caption)
                    .foregroundStyle(Color.jcaMuted)
            }
            .frame(width: 52)

            Divider()
                .overlay(Color.jcaBorderWarm)

            VStack(alignment: .leading, spacing: 3) {
                Text(parva.name)
                    .font(JCAFont.title)
                    .foregroundStyle(Color.jcaInk)
                Text(parva.date.formatted(.dateTime.weekday(.wide).month(.wide).day()))
                    .font(JCAFont.caption)
                    .foregroundStyle(Color.jcaMuted)
                if !parva.description.isEmpty {
                    Text(parva.description)
                        .font(JCAFont.caption)
                        .foregroundStyle(Color.jcaMuted.opacity(0.7))
                        .lineLimit(1)
                }
            }
            Spacer()
        }
        .padding(14)
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
        .accessibilityLabel("\(parva.name), \(parva.daysUntil) days away, on \(parva.date.formatted(.dateTime.month().day()))")
    }
}
