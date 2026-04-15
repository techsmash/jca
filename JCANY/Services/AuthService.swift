import Foundation
import Observation

@Observable
final class AuthService {
    var isSignedIn: Bool = false
    var isLoading: Bool = false
    var errorMessage: String? = nil

    func signIn(email: String, password: String) async {
        isLoading = true
        errorMessage = nil
        // Simulate network delay
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        // Accept any credentials for mock
        isSignedIn = true
        isLoading = false
    }

    func signInWithApple() async {
        isLoading = true
        try? await Task.sleep(nanoseconds: 800_000_000)
        isSignedIn = true
        isLoading = false
    }

    func signInWithGoogle() async {
        isLoading = true
        try? await Task.sleep(nanoseconds: 800_000_000)
        isSignedIn = true
        isLoading = false
    }

    func continueAsGuest() {
        isSignedIn = true
    }

    func signOut() {
        isSignedIn = false
    }
}
