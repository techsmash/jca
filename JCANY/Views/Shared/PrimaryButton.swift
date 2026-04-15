import SwiftUI

struct PrimaryButton: View {
    let title: String
    var icon: String? = nil
    var isLoading: Bool = false
    var isDisabled: Bool = false
    let action: () -> Void

    var body: some View {
        Button(action: {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            action()
        }) {
            HStack(spacing: 8) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(.white)
                        .scaleEffect(0.85)
                } else {
                    if let icon = icon {
                        Image(systemName: icon)
                            .font(.system(size: 15, weight: .semibold))
                    }
                    Text(title)
                        .font(JCAFont.bodyMedium)
                        .fontWeight(.semibold)
                }
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: Radii.md)
                    .fill(isDisabled ? Color.jcaMuted : Color.jcaCrimson)
                    .shadow(color: Color.jcaCrimson.opacity(isDisabled ? 0 : 0.25), radius: 8, y: 4)
            )
        }
        .disabled(isDisabled || isLoading)
        .accessibilityLabel(title)
    }
}

struct GhostButton: View {
    let title: String
    var isLight: Bool = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(JCAFont.body)
                .fontWeight(.medium)
                .foregroundStyle(isLight ? Color.jcaCream.opacity(0.85) : Color.jcaCrimson)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 15)
        }
        .accessibilityLabel(title)
    }
}
