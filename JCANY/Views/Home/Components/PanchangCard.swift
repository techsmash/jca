import SwiftUI

struct PanchangCard: View {
    let panchang: PanchangData

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .lastTextBaseline) {
                Text(panchang.tithi)
                    .font(JCAFont.headline)
                    .foregroundStyle(Color.jcaInk)
                Spacer()
                Text(panchang.month)
                    .font(.inter(size: 11, weight: .semibold))
                    .foregroundStyle(Color.jcaCrimson)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Color.jcaCrimson.opacity(0.08))
                    .clipShape(Capsule())
            }
            .padding(.bottom, 12)

            Divider()
                .overlay(Color.jcaBorder)

            HStack(spacing: 0) {
                PanchangCell(label: "Sunrise", value: panchang.sunrise, icon: "sunrise.fill")
                Divider().frame(height: 32).overlay(Color.jcaBorder)
                PanchangCell(label: "Sunset", value: panchang.sunset, icon: "sunset.fill")
                Divider().frame(height: 32).overlay(Color.jcaBorder)
                PanchangCell(label: "Pratikraman", value: panchang.pratikraman, icon: "moon.stars.fill")
            }
            .padding(.top, 12)
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: Radii.lg)
                .fill(Color.jcaPaper)
                .overlay(
                    RoundedRectangle(cornerRadius: Radii.lg)
                        .stroke(Color.jcaBorder, lineWidth: 0.5)
                )
                .overlay(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(
                            LinearGradient(
                                colors: [Color.jcaCrimson, Color.jcaGold],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(width: 3)
                        .padding(.leading, 0)
                        .clipShape(
                            RoundedRectangle(cornerRadius: Radii.lg)
                        )
                }
                .shadowSm()
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Today's Panchang: \(panchang.tithi). Sunrise at \(panchang.sunrise). Sunset at \(panchang.sunset). Pratikraman at \(panchang.pratikraman)")
    }
}

private struct PanchangCell: View {
    let label: String
    let value: String
    let icon: String

    var body: some View {
        VStack(spacing: 2) {
            Text(label)
                .font(JCAFont.label)
                .foregroundStyle(Color.jcaMuted)
                .kerning(0.8)
                .textCase(.uppercase)
            Text(value)
                .font(JCAFont.titleItalic)
                .foregroundStyle(Color.jcaInk)
        }
        .frame(maxWidth: .infinity)
    }
}
