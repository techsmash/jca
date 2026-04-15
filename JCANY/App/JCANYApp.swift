import SwiftUI
import SwiftData

@main
struct JCANYApp: App {
    @State private var authService = AuthService()

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
                .preferredColorScheme(.light)
        }
        .modelContainer(modelContainer)
    }
}
