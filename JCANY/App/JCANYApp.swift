import SwiftUI
import SwiftData

@main
struct JCANYApp: App {
    @State private var authService = AuthService()
    @State private var appState = AppState()

    init() {
        // Configure shared URL cache for remote gallery images (50 MB memory, 200 MB disk)
        URLCache.shared.memoryCapacity  = 50 * 1024 * 1024
        URLCache.shared.diskCapacity    = 200 * 1024 * 1024
    }

    let modelContainer: ModelContainer = {
        let schema = Schema([
            User.self,
            FamilyMember.self,
            PaymentMethod.self,
            Donation.self
        ])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            return try ModelContainer(for: schema, configurations: [config])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(authService)
                .environment(appState)
                .environment(PushNotificationService.shared)
                .preferredColorScheme(.light)
        }
        .modelContainer(modelContainer)
    }
}
