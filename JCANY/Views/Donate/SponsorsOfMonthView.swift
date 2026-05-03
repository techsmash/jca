import SwiftUI

struct SponsorsOfMonthView: View {
    private let sponsors = MockDataProvider.sponsorsOfMonth
    @State private var selectedFilter = "All"
    private let filters = ["All", "Bhojanshala", "Temple Fund", "General Fund"]

    private var filtered: [MonthSponsor] {
        guard selectedFilter != "All" else { return sponsors }
        return sponsors.filter { $0.cause == selectedFilter }
    }

    private var monthTotal: Decimal { sponsors.reduce(0) { $0 + $1.amount } }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                headerCard
                    .padding(.horizontal, 24)
                    .padding(.top, 16)

                PillTabBar(tabs: filters, selection: $selectedFilter)
                    .padding(.top, 16)

                LazyVStack(spacing: 10) {
                    ForEach(filtered) { sponsor in
                        SponsorRow(sponsor: sponsor)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 12)
                .padding(.bottom, 32)
            }
        }
        .background(Color.jcaCream.ignoresSafeArea())
    }

    @ViewBuilder
    private var headerCard: some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 4) {
                Text("APRIL 2026")
                    .font(JCAFont.label)
                    .foregroundStyle(Color.jcaGoldDeep)
                    .kerning(0.8)
                Text(formatCurrency(monthTotal))
                    .font(.fraunces(size: 28, weight: .semibold))
                    .foregroundStyle(Color.jcaInk)
                Text("\(sponsors.count) sponsors this month")
                    .font(JCAFont.caption)
                    .foregroundStyle(Color.jcaMuted)
            }
            Spacer()
            Text("🙏")
                .font(.system(size: 30))
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: Radii.base)
                .fill(
                    LinearGradient(
                        colors: [Color(hex: "#fff7e6"), Color(hex: "#fde8c4")],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(RoundedRectangle(cornerRadius: Radii.base).stroke(Color.jcaGold.opacity(0.4), lineWidth: 0.5))
                .shadowSm()
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel("April 2026: \(formatCurrency(monthTotal)) from \(sponsors.count) sponsors")
    }

    private func formatCurrency(_ amount: Decimal) -> String {
        let f = NumberFormatter()
        f.numberStyle = .currency
        f.locale = Locale(identifier: "en_US")
        f.maximumFractionDigits = 0
        return f.string(from: NSDecimalNumber(decimal: amount)) ?? "$\(amount)"
    }
}

// MARK: - Sponsor row

private struct SponsorRow: View {
    let sponsor: MonthSponsor

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack {
                Circle()
                    .fill(LinearGradient(
                        colors: [Color.jcaGold, Color.jcaGoldDeep],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .frame(width: 40, height: 40)
                Text(sponsor.memberInitials)
                    .font(.fraunces(size: 15, weight: .semibold))
                    .foregroundStyle(.white)
            }

            VStack(alignment: .leading, spacing: 3) {
                Text(sponsor.memberName)
                    .font(JCAFont.subheadline)
                    .foregroundStyle(Color.jcaInk)
                HStack(spacing: 6) {
                    Text(sponsor.cause)
                        .font(JCAFont.caption)
                        .foregroundStyle(Color.jcaCrimson)
                    Text("·")
                        .foregroundStyle(Color.jcaMuted)
                    Text(sponsor.date.formatted(.dateTime.month(.abbreviated).day()))
                        .font(JCAFont.caption)
                        .foregroundStyle(Color.jcaMuted)
                }
                if let memorial = sponsor.memorialText {
                    Text(memorial)
                        .font(.frauncesItalic(size: 12))
                        .foregroundStyle(Color.jcaMuted)
                        .padding(.top, 2)
                }
            }

            Spacer()

            Text(formatCurrency(sponsor.amount))
                .font(.fraunces(size: 15, weight: .semibold))
                .foregroundStyle(Color.jcaInk)
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: Radii.base)
                .fill(Color.jcaPaper)
                .overlay(RoundedRectangle(cornerRadius: Radii.base).stroke(Color.jcaBorder, lineWidth: 0.5))
                .shadowSm()
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(sponsor.memberName) sponsored \(sponsor.cause) with \(formatCurrency(sponsor.amount))")
    }

    private func formatCurrency(_ amount: Decimal) -> String {
        let f = NumberFormatter()
        f.numberStyle = .currency
        f.locale = Locale(identifier: "en_US")
        f.maximumFractionDigits = 0
        return f.string(from: NSDecimalNumber(decimal: amount)) ?? "$\(amount)"
    }
}

#Preview {
    SponsorsOfMonthView()
}
