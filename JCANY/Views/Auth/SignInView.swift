import SwiftUI

struct SignInView: View {
    @Environment(AuthService.self) private var auth
    @State private var email: String = ""
    @State private var password: String = ""
    @FocusState private var focusedField: Field?

    enum Field { case email, password }

    var body: some View {
        @Bindable var authB = auth
        ZStack {
            Color.jcaCream.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        Group {
                            Text("Welcome")
                                .font(JCAFont.displayLarge)
                                .foregroundStyle(Color.jcaInk)
                            + Text(" back")
                                .font(.frauncesItalic(size: 34, weight: .light))
                                .foregroundStyle(Color.jcaCrimson)
                        }
                        Text("Sign in to access your JCA NY membership")
                            .font(JCAFont.body)
                            .foregroundStyle(Color.jcaMuted)
                            .lineSpacing(3)
                    }
                    .padding(.top, 16)
                    .padding(.bottom, 36)

                    // Form
                    VStack(spacing: 18) {
                        IOSTextField(
                            label: "Email Address",
                            placeholder: "manan@jcany.org",
                            text: $email,
                            keyboardType: .emailAddress,
                            textContentType: .emailAddress
                        )
                        .focused($focusedField, equals: .email)

                        IOSTextField(
                            label: "Password",
                            placeholder: "••••••••",
                            text: $password,
                            isSecure: true,
                            textContentType: .password
                        )
                        .focused($focusedField, equals: .password)

                        HStack {
                            Spacer()
                            Button("Forgot Password?") {}
                                .font(JCAFont.subheadline)
                                .foregroundStyle(Color.jcaCrimson)
                        }
                    }

                    // Sign In Button
                    PrimaryButton(
                        title: "Sign In",
                        isLoading: auth.isLoading,
                        isDisabled: email.isEmpty || password.isEmpty
                    ) {
                        focusedField = nil
                        Task { await auth.signIn(email: email, password: password) }
                    }
                    .padding(.top, 8)

                    // Divider
                    HStack(spacing: 10) {
                        Rectangle().fill(Color.jcaBorder).frame(height: 0.5)
                        Text("or")
                            .font(JCAFont.label)
                            .foregroundStyle(Color.jcaMuted)
                        Rectangle().fill(Color.jcaBorder).frame(height: 0.5)
                    }
                    .padding(.vertical, 20)

                    // Social buttons
                    HStack(spacing: 10) {
                        SocialButton(label: "Apple", icon: "apple.logo") {
                            Task { await auth.signInWithApple() }
                        }
                        SocialButton(label: "Google", icon: "g.circle.fill") {
                            Task { await auth.signInWithGoogle() }
                        }
                    }

                    // Sign up
                    HStack {
                        Spacer()
                        Text("New member? ")
                            .font(JCAFont.subheadline)
                            .foregroundStyle(Color.jcaMuted)
                        + Text("Register")
                            .font(JCAFont.subheadline)
                            .foregroundStyle(Color.jcaCrimson)
                        Spacer()
                    }
                    .padding(.top, 24)
                }
                .padding(.horizontal, 28)
                .padding(.bottom, 40)
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                NavigationBackButton()
            }
        }
        .onTapGesture { focusedField = nil }
        .preferredColorScheme(.light)
    }
}

private struct SocialButton: View {
    let label: String
    let icon: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .medium))
                Text(label)
                    .font(JCAFont.subheadline)
            }
            .foregroundStyle(Color.jcaInk)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 13)
            .background(
                RoundedRectangle(cornerRadius: Radii.md)
                    .fill(Color.jcaPaper)
                    .overlay(
                        RoundedRectangle(cornerRadius: Radii.md)
                            .stroke(Color.jcaBorder, lineWidth: 0.5)
                    )
                    .shadowSm()
            )
        }
        .accessibilityLabel("Sign in with \(label)")
    }
}

#Preview {
    NavigationStack {
        SignInView()
            .environment(AuthService())
    }
}
