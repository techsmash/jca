import SwiftUI

struct ComingSoonView: View {
    let title: String
    var icon: String = "sparkles"

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            ZStack {
                Circle()
                    .fill(Color.jcaGold.opacity(0.1))
                    .frame(width: 88, height: 88)
                Image(systemName: icon)
                    .font(.system(size: 36))
                    .foregroundStyle(Color.jcaGoldDeep)
            }

            VStack(spacing: 8) {
                Text(title)
                    .font(.fraunces(size: 24, weight: .semibold))
                    .foregroundStyle(Color.jcaInk)
                Text("This feature is coming soon.\nStay tuned for updates.")
                    .font(JCAFont.body)
                    .foregroundStyle(Color.jcaMuted)
                    .multilineTextAlignment(.center)
            }

            Spacer()
        }
        .padding(.horizontal, 40)
        .background(Color.jcaCream.ignoresSafeArea())
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        ComingSoonView(title: "Youth Connect", icon: "figure.2.arms.open")
    }
}
