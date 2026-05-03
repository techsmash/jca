import SwiftUI
import SwiftData

struct DonationHistoryView: View {
    @Query private var users: [User]
    @State private var selectedYear = "2026"
    @State private var showingStatementAlert = false

    private var currentUser: User? { users.first }
    private let yearTabs = ["2026", "2025", "All Years"]

    private var allDonations: [Donation] {
        currentUser?.donationHistory.sorted(by: { $0.date > $1.date }) ?? []
    }

    private var filteredDonations: [Donation] {
        guard selectedYear != "All Years" else { return allDonations }
        let year = Int(selectedYear) ?? 2026
        return allDonations.filter {
            Calendar.current.component(.year, from: $0.date) == year
        }
    }

    private var ytdTotal: Decimal {
        let year = Calendar.current.component(.year, from: Date())
        return allDonations
            .filter { Calendar.current.component(.year, from: $0.date) == year }
            .reduce(0) { $0 + $1.amount }
    }

    private var groupedDonations: [(String, [Donation])] {
        let grouped = Dictionary(grouping: filteredDonations) { donation -> String in
            donation.date.formatted(.dateTime.month(.wide).year())
        }
        return grouped
            .sorted { lhs, rhs in
                let fmt = DateFormatter()
                fmt.dateFormat = "MMMM yyyy"
                let a = fmt.date(from: lhs.key) ?? .distantPast
                let b = fmt.date(from: rhs.key) ?? .distantPast
                return a > b
            }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                ytdHeroCard
                    .padding(.horizontal, 24)
                    .padding(.top, 16)

                PillTabBar(tabs: yearTabs, selection: $selectedYear)
                    .padding(.top, 16)

                if filteredDonations.isEmpty {
                    Text("No donations for this period.")
                        .font(JCAFont.body)
                        .foregroundStyle(Color.jcaMuted)
                        .padding(.top, 40)
                } else {
                    VStack(spacing: 20) {
                        ForEach(groupedDonations, id: \.0) { month, donations in
                            monthSection(month: month, donations: donations)
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 16)
                    .padding(.bottom, 32)
                }
            }
        }
        .background(Color.jcaCream.ignoresSafeArea())
        .alert("Year-End Statement", isPresented: $showingStatementAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Your year-end tax statement will be available to download once the backend integration is complete.")
        }
    }

    // MARK: - Subviews

    @ViewBuilder
    private var ytdHeroCard: some View {
        ZStack {
            RoundedRectangle(cornerRadius: Radii.xl)
                .fill(LinearGradient(
                    colors: [Color.jcaCrimson, Color.jcaCrimsonDeep],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
            Circle()
                .stroke(Color.jcaGold.opacity(0.2), lineWidth: 30)
                .frame(width: 180)
                .offset(x: 70, y: 20)

            VStack(alignment: .leading, spacing: 10) {
                Text("DONATED IN \(Calendar.current.component(.year, from: Date()))")
                    .font(JCAFont.label)
                    .foregroundStyle(Color.jcaCream.opacity(0.7))
                    .kerning(1)
                Text(formatCurrency(ytdTotal))
                    .font(.fraunces(size: 34, weight: .semibold))
                    .foregroundStyle(.white)

                Button {
                    showingStatementAlert = true
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "arrow.down.doc.fill")
                            .font(.system(size: 12))
                        Text("Year-End Statement")
                            .font(.inter(size: 12, weight: .semibold))
                    }
                    .foregroundStyle(Color.jcaCrimson)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .background(Color.jcaCream)
                    .clipShape(Capsule())
                }
                .buttonStyle(.plain)
                .padding(.top, 4)
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Donated \(formatCurrency(ytdTotal)) this year")
    }

    @ViewBuilder
    private func monthSection(month: String, donations: [Donation]) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(month)
                .font(JCAFont.subheadline)
                .foregroundStyle(Color.jcaMuted)

            VStack(spacing: 0) {
                ForEach(donations) { donation in
                    DonationRow(donation: donation)
                    if donation.id != donations.last?.id {
                        Divider().overlay(Color.jcaBorder).padding(.horizontal, 16)
                    }
                }
            }
            .background(
                RoundedRectangle(cornerRadius: Radii.base)
                    .fill(Color.jcaPaper)
                    .overlay(RoundedRectangle(cornerRadius: Radii.base).stroke(Color.jcaBorder, lineWidth: 0.5))
                    .shadowSm()
            )
        }
    }

    private func formatCurrency(_ amount: Decimal) -> String {
        let f = NumberFormatter()
        f.numberStyle = .currency
        f.locale = Locale(identifier: "en_US")
        f.maximumFractionDigits = 0
        return f.string(from: NSDecimalNumber(decimal: amount)) ?? "$\(amount)"
    }
}

// MARK: - Donation row

private struct DonationRow: View {
    let donation: Donation

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.jcaCrimson.opacity(0.08))
                    .frame(width: 36, height: 36)
                Image(systemName: "heart.fill")
                    .font(.system(size: 14))
                    .foregroundStyle(Color.jcaCrimson)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(donation.cause)
                    .font(JCAFont.title)
                    .foregroundStyle(Color.jcaInk)
                Text(donation.date.formatted(.dateTime.day().month(.abbreviated).year()))
                    .font(JCAFont.caption)
                    .foregroundStyle(Color.jcaMuted)
                if !donation.paymentMethodLast4.isEmpty {
                    Text("···· \(donation.paymentMethodLast4)")
                        .font(JCAFont.caption)
                        .foregroundStyle(Color.jcaMuted)
                }
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                Text(formatCurrency(donation.amount))
                    .font(.fraunces(size: 16, weight: .semibold))
                    .foregroundStyle(Color.jcaInk)
                Button {
                    // Receipt download — backend integration pending
                } label: {
                    HStack(spacing: 3) {
                        Image(systemName: "arrow.down.circle")
                            .font(.system(size: 11))
                        Text("Receipt")
                            .font(JCAFont.caption)
                    }
                    .foregroundStyle(Color.jcaCrimson)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Download receipt for \(donation.cause)")
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(donation.cause), \(formatCurrency(donation.amount)), \(donation.date.formatted(.dateTime.day().month().year()))")
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
    NavigationStack {
        DonationHistoryView()
            .navigationTitle("Donation History")
            .navigationBarTitleDisplayMode(.inline)
    }
    .modelContainer(for: [User.self, FamilyMember.self, Donation.self, PaymentMethod.self])
}
