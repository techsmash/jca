import SwiftUI

struct EventCard: View {
    let event: Event

    var body: some View {
        HStack(spacing: 14) {
            // Date block
            VStack(spacing: 0) {
                Text(event.date.formatted(.dateTime.month(.abbreviated)).uppercased())
                    .font(.inter(size: 9, weight: .bold))
                    .foregroundStyle(Color.jcaCrimson)
                    .kerning(1.2)
                Text(event.date.formatted(.dateTime.day()))
                    .font(.fraunces(size: 22, weight: .semibold))
                    .foregroundStyle(Color.jcaInk)
            }
            .frame(width: 52)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(LinearGradient(
                        colors: [Color.jcaCrimson.opacity(0.06), Color.jcaCrimson.opacity(0.02)],
                        startPoint: .top,
                        endPoint: .bottom
                    ))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.jcaBorderWarm, lineWidth: 0.5)
                    )
            )

            // Info
            VStack(alignment: .leading, spacing: 4) {
                Text(event.title)
                    .font(JCAFont.title)
                    .foregroundStyle(Color.jcaInk)
                    .lineLimit(1)
                if !event.subtitle.isEmpty {
                    Text(event.subtitle)
                        .font(JCAFont.caption)
                        .foregroundStyle(Color.jcaMuted)
                }
                if !event.location.isEmpty {
                    HStack(spacing: 4) {
                        Image(systemName: "mappin.circle.fill")
                            .font(.system(size: 10))
                            .foregroundStyle(Color.jcaCrimson.opacity(0.7))
                        Text(event.location)
                            .font(JCAFont.caption)
                            .foregroundStyle(Color.jcaMuted)
                            .lineLimit(1)
                    }
                }
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(Color.jcaMuted.opacity(0.5))
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
        .accessibilityLabel("\(event.title) on \(event.date.formatted(.dateTime.month().day()))")
    }
}
