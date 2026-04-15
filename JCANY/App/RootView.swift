import SwiftUI
import SwiftData

struct RootView: View {
    @Environment(AuthService.self) private var auth
    @Environment(\.modelContext) private var modelContext
    @State private var hasSeeded = false

    var body: some View {
        Group {
            if auth.isSignedIn {
                MainTabView()
            } else {
                NavigationStack {
                    SplashView(onContinueAsGuest: {
                        auth.continueAsGuest()
                    })
                }
            }
        }
        .onAppear {
            if !hasSeeded {
                MockDataProvider.seedIfNeeded(context: modelContext)
                hasSeeded = true
            }
        }
    }
}
