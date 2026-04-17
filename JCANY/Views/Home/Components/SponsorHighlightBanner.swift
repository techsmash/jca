import SwiftUI

struct SponsorHighlightBanner: View {
    private let state = SponsorState.shared

    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            VStack(alignment: .leading, spacing: 3) {
                Text("TODAY'S SWAMIVATSALYA")
                    .font(.inter(size: 9, weight: .bold))
                    .tracking(1.35)
                    .foregroundStyle(Color.jcaGoldDeep)

                HStack(spacing: 0) {
                    Text("Sponsored by ")
                        .font(.fraunces(size: 13, weight: .regular))
                        .foregroundStyle(Color.jcaInk)
                    Text(state.currentSponsor)
                        .font(.fraunces(size: 13, weight: .semibold))
                        .foregroundStyle(Color.jcaCrimson)
                }

                Text(state.blessing)
                    .font(.frauncesItalic(size: 11))
                    .foregroundStyle(Color.jcaGoldDeep)
            }
            .padding(.trailing, 30)

            Spacer()

            Text("🙏")
                .font(.system(size: 22))
                .opacity(0.7)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(
            LinearGradient(
                colors: [Color(hex: "#fff7e6"), Color(hex: "#fde8c4")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .overlay(alignment: .leading) {
            LinearGradient(
                colors: [Color.jcaGold, Color.jcaGoldDeep],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(width: 3)
        }
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color.jcaGold.opacity(0.4), lineWidth: 0.5)
        )
        .shadow(color: Color.jcaGold.opacity(0.15), radius: 5, y: 3)
        .padding(.horizontal, 24)
        .padding(.top, 14)
        .animation(.easeInOut(duration: 0.4), value: state.currentSponsor)
        .accessibilityLabel("Today's Swamivatsalya sponsored by \(state.currentSponsor). \(state.blessing).")
    }
}
