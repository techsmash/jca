import SwiftUI

struct CenterHoursCard: View {
    let data: CenterHoursData
    @Environment(\.openURL) private var openURL

    var body: some View {
        VStack(spacing: 0) {
            headerRow
            Divider().overlay(Color.jcaBorder).padding(.horizontal, 16)
            scheduleList
            Divider().overlay(Color.jcaBorder).padding(.horizontal, 16)
            actionRow
        }
        .background(
            RoundedRectangle(cornerRadius: Radii.base)
                .fill(Color.jcaPaper)
                .overlay(
                    RoundedRectangle(cornerRadius: Radii.base)
                        .stroke(Color.jcaBorder, lineWidth: 0.5)
                )
                .shadowSm()
        )
        .accessibilityElement(children: .contain)
        .accessibilityLabel("JCA Elmhurst, \(data.isOpenNow ? "currently open" : "currently closed")")
    }

    // MARK: - Subviews

    @ViewBuilder
    private var headerRow: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 2) {
                Text("JCA Elmhurst")
                    .font(JCAFont.headline)
                    .foregroundStyle(Color.jcaInk)
                Text("43-11 Ithaca St, Elmhurst NY 11373")
                    .font(JCAFont.caption)
                    .foregroundStyle(Color.jcaMuted)
            }
            Spacer()
            HStack(spacing: 5) {
                Circle()
                    .fill(data.isOpenNow ? Color.green : Color.red)
                    .frame(width: 6, height: 6)
                Text(data.isOpenNow ? "Open Now" : "Closed")
                    .font(.inter(size: 11, weight: .semibold))
                    .foregroundStyle(data.isOpenNow ? Color.green : Color.red)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background((data.isOpenNow ? Color.green : Color.red).opacity(0.08))
            .clipShape(Capsule())
        }
        .padding(.horizontal, 16)
        .padding(.top, 14)
        .padding(.bottom, 12)
    }

    @ViewBuilder
    private var scheduleList: some View {
        VStack(spacing: 0) {
            ForEach(data.schedule, id: \.day) { entry in
                HStack {
                    Text(entry.day)
                        .font(entry.isToday ? .inter(size: 13, weight: .semibold) : JCAFont.body)
                        .foregroundStyle(entry.isToday ? Color.jcaCrimson : Color.jcaInkSoft)
                        .frame(width: 38, alignment: .leading)
                    Spacer()
                    Text(entry.hours)
                        .font(entry.isToday ? .inter(size: 13, weight: .semibold) : JCAFont.body)
                        .foregroundStyle(entry.isToday ? Color.jcaCrimson : Color.jcaInk)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 7)
                .background(entry.isToday ? Color.jcaCrimson.opacity(0.04) : Color.clear)
            }
        }
    }

    @ViewBuilder
    private var actionRow: some View {
        HStack(spacing: 0) {
            actionButton(icon: "phone.fill", title: "Call") {
                if let url = URL(string: "tel:+17184583586") { openURL(url) }
            }
            Divider().frame(height: 36).overlay(Color.jcaBorder)
            actionButton(icon: "map.fill", title: "Directions") {
                if let url = URL(string: "maps://?daddr=43-11+Ithaca+Street+Elmhurst+NY+11373") { openURL(url) }
            }
            Divider().frame(height: 36).overlay(Color.jcaBorder)
            actionButton(icon: "envelope.fill", title: "Email") {
                if let url = URL(string: "mailto:info@jcany.org") { openURL(url) }
            }
        }
        .padding(.vertical, 8)
    }

    @ViewBuilder
    private func actionButton(icon: String, title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(Color.jcaCrimson)
                Text(title)
                    .font(JCAFont.caption)
                    .foregroundStyle(Color.jcaInkSoft)
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(title)
        .accessibilityAddTraits(.isButton)
    }
}

// MARK: - Preview

#Preview {
    CenterHoursCard(data: .current())
        .padding()
        .background(Color.jcaCream)
}
