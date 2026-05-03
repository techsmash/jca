import SwiftUI

struct SubscriptionsView: View {
    @State private var selectedTab = "My Subscriptions"
    private let tabs = ["My Subscriptions", "Set Up New"]
    private let subscriptions = MockDataProvider.subscriptions

    var body: some View {
        VStack(spacing: 0) {
            PillTabBar(tabs: tabs, selection: $selectedTab)
                .padding(.top, 8)

            ScrollView {
                if selectedTab == "My Subscriptions" {
                    mySubscriptionsContent
                } else {
                    setUpNewContent
                }
            }
        }
        .background(Color.jcaCream.ignoresSafeArea())
    }

    // MARK: - My Subscriptions

    @ViewBuilder
    private var mySubscriptionsContent: some View {
        VStack(spacing: 10) {
            if subscriptions.isEmpty {
                Text("No active recurring sevas.")
                    .font(JCAFont.body)
                    .foregroundStyle(Color.jcaMuted)
                    .padding(.top, 40)
            } else {
                ForEach(subscriptions) { sub in
                    SubscriptionCard(subscription: sub)
                }
            }
        }
        .padding(.horizontal, 24)
        .padding(.top, 16)
        .padding(.bottom, 32)
    }

    // MARK: - Set Up New

    @ViewBuilder
    private var setUpNewContent: some View {
        VStack(spacing: 0) {
            Text("Start a Recurring Seva")
                .font(JCAFont.headline)
                .foregroundStyle(Color.jcaInk)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 24)
                .padding(.top, 16)
                .padding(.bottom, 4)

            Text("Choose a plan below or set a custom amount on any cause card.")
                .font(JCAFont.body)
                .foregroundStyle(Color.jcaMuted)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 24)
                .padding(.bottom, 16)

            VStack(spacing: 10) {
                RecurringPlanCard(
                    icon: "bell.fill",
                    title: "Daily Aarti Seva",
                    description: "Support morning and evening aarti every day",
                    amount: 11,
                    frequency: "day"
                )
                RecurringPlanCard(
                    icon: "fork.knife",
                    title: "Bhojanshala Family Seva",
                    description: "Nourish the community with a monthly meal contribution",
                    amount: 108,
                    frequency: "mo"
                )
                RecurringPlanCard(
                    icon: "star.fill",
                    title: "Paryushan Dāna",
                    description: "Annual seva in honor of the most sacred Jain festival",
                    amount: 2508,
                    frequency: "yr",
                    isGold: true
                )
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 32)
        }
    }
}

// MARK: - Subscription card

private struct SubscriptionCard: View {
    let subscription: Subscription
    @State private var showingPauseAlert = false
    @State private var showingEditAlert = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.jcaCrimson.opacity(0.08))
                        .frame(width: 38, height: 38)
                    Image(systemName: subscription.causeIcon)
                        .font(.system(size: 15))
                        .foregroundStyle(Color.jcaCrimson)
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text(subscription.causeName)
                        .font(JCAFont.title)
                        .foregroundStyle(Color.jcaInk)
                    HStack(spacing: 4) {
                        Text(subscription.frequency.rawValue)
                            .font(JCAFont.caption)
                            .foregroundStyle(Color.jcaMuted)
                        Text("·")
                            .foregroundStyle(Color.jcaMuted)
                        Text("Since \(subscription.startDate.formatted(.dateTime.month(.abbreviated).year()))")
                            .font(JCAFont.caption)
                            .foregroundStyle(Color.jcaMuted)
                    }
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 1) {
                    HStack(alignment: .lastTextBaseline, spacing: 2) {
                        Text(formatCurrency(subscription.amount))
                            .font(.fraunces(size: 18, weight: .semibold))
                            .foregroundStyle(Color.jcaInk)
                        Text(subscription.frequency.shortSuffix)
                            .font(JCAFont.caption)
                            .foregroundStyle(Color.jcaMuted)
                    }
                    statusBadge
                }
            }

            Divider().overlay(Color.jcaBorder)

            HStack {
                VStack(alignment: .leading, spacing: 1) {
                    Text("Next charge")
                        .font(JCAFont.caption)
                        .foregroundStyle(Color.jcaMuted)
                    Text(subscription.nextChargeDate.formatted(.dateTime.day().month(.abbreviated).year()))
                        .font(JCAFont.subheadline)
                        .foregroundStyle(Color.jcaInk)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 1) {
                    Text("Lifetime total")
                        .font(JCAFont.caption)
                        .foregroundStyle(Color.jcaMuted)
                    Text(formatCurrency(subscription.lifetimeTotal))
                        .font(JCAFont.subheadline)
                        .foregroundStyle(Color.jcaInk)
                }
            }

            HStack(spacing: 8) {
                Button {
                    showingEditAlert = true
                } label: {
                    Text("Edit Amount")
                        .font(.inter(size: 13, weight: .semibold))
                        .foregroundStyle(Color.jcaCrimson)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 9)
                        .frame(maxWidth: .infinity)
                        .background(Color.jcaCrimson.opacity(0.08))
                        .clipShape(RoundedRectangle(cornerRadius: Radii.m))
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Edit amount for \(subscription.causeName)")

                Button {
                    showingPauseAlert = true
                } label: {
                    Text(subscription.status == .paused ? "Resume" : "Pause")
                        .font(.inter(size: 13, weight: .semibold))
                        .foregroundStyle(Color.jcaInkSoft)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 9)
                        .frame(maxWidth: .infinity)
                        .background(Color.jcaCreamWarm)
                        .clipShape(RoundedRectangle(cornerRadius: Radii.m))
                        .overlay(RoundedRectangle(cornerRadius: Radii.m).stroke(Color.jcaBorder, lineWidth: 0.5))
                }
                .buttonStyle(.plain)
                .accessibilityLabel(subscription.status == .paused ? "Resume \(subscription.causeName)" : "Pause \(subscription.causeName)")
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: Radii.base)
                .fill(Color.jcaPaper)
                .overlay(RoundedRectangle(cornerRadius: Radii.base).stroke(Color.jcaBorder, lineWidth: 0.5))
                .shadowSm()
        )
        .alert("Edit Amount", isPresented: $showingEditAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Amount editing will be available once backend integration is complete.")
        }
        .alert("Pause Subscription", isPresented: $showingPauseAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Pause/resume controls will be available once backend integration is complete.")
        }
    }

    @ViewBuilder
    private var statusBadge: some View {
        Text(subscription.status.rawValue)
            .font(.inter(size: 9, weight: .bold))
            .foregroundStyle(subscription.status == .active ? Color.green : Color.jcaMuted)
            .padding(.horizontal, 7)
            .padding(.vertical, 3)
            .background((subscription.status == .active ? Color.green : Color.jcaMuted).opacity(0.1))
            .clipShape(Capsule())
    }

    private func formatCurrency(_ amount: Decimal) -> String {
        let f = NumberFormatter()
        f.numberStyle = .currency
        f.locale = Locale(identifier: "en_US")
        f.maximumFractionDigits = 0
        return f.string(from: NSDecimalNumber(decimal: amount)) ?? "$\(amount)"
    }
}

// MARK: - Recurring plan template card

private struct RecurringPlanCard: View {
    let icon: String
    let title: String
    let description: String
    let amount: Decimal
    let frequency: String
    var isGold: Bool = false
    @State private var showingAlert = false

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(isGold ? Color.jcaGold.opacity(0.15) : Color.jcaCrimson.opacity(0.08))
                    .frame(width: 44, height: 44)
                Image(systemName: icon)
                    .font(.system(size: 17))
                    .foregroundStyle(isGold ? Color.jcaGoldDeep : Color.jcaCrimson)
            }
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(JCAFont.title)
                    .foregroundStyle(Color.jcaInk)
                Text(description)
                    .font(JCAFont.caption)
                    .foregroundStyle(Color.jcaMuted)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 0) {
                Text(formatAmount(amount))
                    .font(.fraunces(size: 16, weight: .semibold))
                    .foregroundStyle(Color.jcaInk)
                Text("/\(frequency)")
                    .font(JCAFont.caption)
                    .foregroundStyle(Color.jcaMuted)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: Radii.base)
                .fill(Color.jcaPaper)
                .overlay(RoundedRectangle(cornerRadius: Radii.base).stroke(
                    isGold ? Color.jcaGold.opacity(0.4) : Color.jcaBorder, lineWidth: isGold ? 1 : 0.5
                ))
                .shadowSm()
        )
        .contentShape(RoundedRectangle(cornerRadius: Radii.base))
        .onTapGesture { showingAlert = true }
        .alert("Set Up Recurring Seva", isPresented: $showingAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Recurring seva setup will be available once backend integration is complete.")
        }
        .accessibilityLabel("\(title), \(formatAmount(amount)) per \(frequency)")
        .accessibilityAddTraits(.isButton)
    }

    private func formatAmount(_ amount: Decimal) -> String {
        let f = NumberFormatter()
        f.numberStyle = .currency
        f.locale = Locale(identifier: "en_US")
        f.maximumFractionDigits = 0
        return f.string(from: NSDecimalNumber(decimal: amount)) ?? "$\(amount)"
    }
}

#Preview {
    SubscriptionsView()
}
