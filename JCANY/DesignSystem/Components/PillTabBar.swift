import SwiftUI

/// A horizontally scrolling pill-style segmented control used across Donate, Community, and Profile sub-tabs.
struct PillTabBar: View {
    let tabs: [String]
    @Binding var selection: String

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 6) {
                ForEach(tabs, id: \.self) { tab in
                    Button {
                        withAnimation(.spring(response: 0.28, dampingFraction: 0.8)) {
                            selection = tab
                        }
                    } label: {
                        Text(tab)
                            .font(.inter(size: 13, weight: selection == tab ? .semibold : .medium))
                            .foregroundStyle(selection == tab ? Color.jcaPaper : Color.jcaInkSoft)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                Capsule().fill(selection == tab ? Color.jcaCrimson : Color.jcaCreamWarm)
                            )
                            .overlay(
                                Capsule().stroke(
                                    selection == tab ? Color.clear : Color.jcaBorder,
                                    lineWidth: 0.5
                                )
                            )
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(tab)
                    .accessibilityAddTraits(selection == tab ? [.isButton, .isSelected] : .isButton)
                }
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 2)
        }
    }
}

#Preview {
    @Previewable @State var selection = "Causes"
    PillTabBar(tabs: ["Causes", "Sponsors", "History", "Subscriptions"], selection: $selection)
        .padding(.vertical)
        .background(Color.jcaCream)
}
