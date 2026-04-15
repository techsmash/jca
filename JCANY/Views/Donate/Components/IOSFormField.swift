import SwiftUI

struct IOSTextField: View {
    let label: String
    var placeholder: String = ""
    @Binding var text: String
    var isSecure: Bool = false
    var keyboardType: UIKeyboardType = .default
    var textContentType: UITextContentType? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(JCAFont.label)
                .foregroundStyle(Color.jcaMuted)
                .kerning(1.2)
                .textCase(.uppercase)
            Group {
                if isSecure {
                    SecureField(placeholder, text: $text)
                } else {
                    TextField(placeholder, text: $text)
                        .keyboardType(keyboardType)
                }
            }
            .font(JCAFont.bodyMedium)
            .foregroundStyle(Color.jcaInk)
            .textContentType(textContentType)
            .autocorrectionDisabled()
            .autocapitalization(.none)
        }
        .padding(14)
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
}
