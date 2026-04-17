import SwiftUI

struct PushNotificationBanner: View {
    @Environment(AppState.self) private var appState
    private let service = PushNotificationService.shared

    var body: some View {
        if let notification = service.active {
            bannerContent(notification)
                .transition(.asymmetric(
                    insertion: .move(edge: .top).combined(with: .opacity),
                    removal: .move(edge: .top).combined(with: .opacity)
                ))
                .zIndex(999)
        }
    }

    @ViewBuilder
    private func bannerContent(_ notification: PushNotification) -> some View {
        HStack(spacing: 12) {
            // App icon badge
            ZStack {
                LinearGradient(
                    colors: [Color.jcaCrimson, Color.jcaCrimsonDeep],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .frame(width: 40, height: 40)
                .clipShape(RoundedRectangle(cornerRadius: 9))
                Text("JCA")
                    .font(.inter(size: 9, weight: .bold))
                    .foregroundStyle(Color.jcaGold)
            }

            // Content
            VStack(alignment: .leading, spacing: 2) {
                Text(notification.title)
                    .font(.inter(size: 13, weight: .semibold))
                    .foregroundStyle(Color.jcaInk)
                    .lineLimit(1)
                Text(notification.body)
                    .font(.inter(size: 12))
                    .foregroundStyle(Color.jcaInkSoft)
                    .lineLimit(2)
                Text(notification.ctaText)
                    .font(.inter(size: 11, weight: .medium))
                    .foregroundStyle(Color.jcaCrimson)
                    .lineLimit(1)
                    .padding(.top, 1)
            }

            Spacer(minLength: 0)

            // Dismiss button
            Button {
                service.dismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(Color.jcaMuted)
                    .frame(width: 22, height: 22)
                    .background(Color.jcaBorder)
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: Radii.md)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: Radii.md)
                        .stroke(Color.jcaBorder, lineWidth: 0.5)
                )
                .shadow(color: Color.jcaInk.opacity(0.18), radius: 16, x: 0, y: 6)
        )
        .padding(.horizontal, 16)
        .padding(.top, 8)
        .onTapGesture {
            let destination = notification.destination
            service.dismiss()
            appState.navigate(to: destination)
        }
        .gesture(
            DragGesture(minimumDistance: 30)
                .onEnded { value in
                    if value.translation.height < -20 {
                        service.dismiss()
                    }
                }
        )
        .accessibilityLabel("\(notification.title). \(notification.body). \(notification.ctaText)")
    }
}
