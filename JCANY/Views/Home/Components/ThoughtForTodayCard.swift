import SwiftUI

struct ThoughtForTodayCard: View {
    let text: String
    let attribution: String

    var body: some View {
        HStack(spacing: 0) {
            LinearGradient(
                colors: [Color.jcaGold, Color.jcaGoldDeep],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(width: 3)

            VStack(alignment: .leading, spacing: 6) {
                Text("THOUGHT FOR TODAY")
                    .font(JCAFont.label)
                    .foregroundStyle(Color.jcaGoldDeep)
                    .kerning(0.8)

                Text(""\(text)"")
                    .font(.frauncesItalic(size: 15))
                    .foregroundStyle(Color.jcaInk)
                    .fixedSize(horizontal: false, vertical: true)

                Text("— \(attribution)")
                    .font(JCAFont.caption)
                    .foregroundStyle(Color.jcaMuted)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 14)

            Spacer(minLength: 0)
        }
        .background(Color.jcaPaper)
        .clipShape(RoundedRectangle(cornerRadius: Radii.base))
        .overlay(
            RoundedRectangle(cornerRadius: Radii.base)
                .stroke(Color.jcaBorder, lineWidth: 0.5)
        )
        .shadowSm()
        .padding(.horizontal, 24)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Thought for today: \(text). Attributed to \(attribution).")
    }
}

#Preview {
    ThoughtForTodayCard(
        text: "Parasparopagraho Jīvānām — all life is bound together by mutual support and interdependence.",
        attribution: "Tattvārtha Sūtra, 5.21"
    )
    .padding(.vertical)
    .background(Color.jcaCream)
}
