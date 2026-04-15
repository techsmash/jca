import SwiftUI

struct OrnamentDivider: View {
    var color: Color = .jcaGold

    var body: some View {
        HStack(spacing: 14) {
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [.clear, color],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(height: 1)
            Rectangle()
                .fill(color)
                .frame(width: 8, height: 8)
                .rotationEffect(.degrees(45))
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [color, .clear],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(height: 1)
        }
        .accessibilityHidden(true)
    }
}

#Preview {
    ZStack {
        Color.jcaCrimson
        OrnamentDivider()
            .padding(.horizontal, 40)
    }
}
