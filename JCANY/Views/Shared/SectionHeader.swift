import SwiftUI

struct SectionHeader: View {
    let title: String
    var actionTitle: String? = nil
    var action: (() -> Void)? = nil

    var body: some View {
        HStack(alignment: .lastTextBaseline) {
            Text(title)
                .font(JCAFont.headline)
                .foregroundStyle(Color.jcaInk)
            Spacer()
            if let actionTitle = actionTitle, let action = action {
                Button(actionTitle, action: action)
                    .font(JCAFont.subheadline)
                    .foregroundStyle(Color.jcaCrimson)
            }
        }
    }
}
