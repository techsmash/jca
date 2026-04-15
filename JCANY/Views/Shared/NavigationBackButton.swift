import SwiftUI

struct NavigationBackButton: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        Button {
            dismiss()
        } label: {
            HStack(spacing: 4) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 17, weight: .semibold))
                Text("Back")
                    .font(JCAFont.bodyMedium)
            }
            .foregroundStyle(Color.jcaCrimson)
        }
        .accessibilityLabel("Go back")
    }
}
