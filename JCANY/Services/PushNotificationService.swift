import SwiftUI

@Observable
final class PushNotificationService {
    static let shared = PushNotificationService()

    var active: PushNotification?
    private var dismissTask: Task<Void, Never>?

    private init() {}

    func present(_ type: PushNotificationType) {
        let content = NotificationContentFactory.build(for: type)
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        withAnimation(.spring(response: 0.55, dampingFraction: 0.7)) {
            active = PushNotification(
                type: type,
                title: content.title,
                body: content.body,
                ctaText: content.ctaText,
                destination: content.destination
            )
        }
        dismissTask?.cancel()
        dismissTask = Task { [weak self] in
            try? await Task.sleep(for: .seconds(7))
            guard !Task.isCancelled else { return }
            await MainActor.run {
                self?.dismiss()
            }
        }
    }

    func dismiss() {
        withAnimation(.easeOut(duration: 0.3)) {
            active = nil
        }
        dismissTask?.cancel()
        dismissTask = nil
    }
}
