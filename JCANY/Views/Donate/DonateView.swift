import SwiftUI

struct DonateView: View {
    @Environment(DonationFlowViewModel.self) private var donationVM
    @State private var progressFill: Double = 0

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Progress stats card
                GoalProgressCard(
                    target: donationVM.donationGoal.target,
                    raised: donationVM.donationGoal.raised,
                    donors: donationVM.donationGoal.donors,
                    progress: progressFill
                )
                .padding(.horizontal, 24)
                .padding(.top, 16)

                // Cause cards
                VStack(spacing: 12) {
                    SectionHeader(title: "Choose a Cause")
                        .padding(.horizontal, 24)

                    VStack(spacing: 10) {
                        ForEach(donationVM.categories) { category in
                            Button {
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                donationVM.selectedCategory = category
                                donationVM.selectedAmount = category.defaultAmount
                                donationVM.navigationPath.append(
                                    category.isBhojanshala ? DonationRoute.bhojanshala : DonationRoute.payment
                                )
                            } label: {
                                CauseCard(
                                    category: category,
                                    isSelected: donationVM.selectedCategory?.id == category.id
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 24)
                }
                .padding(.top, 28)
                .padding(.bottom, 32)
            }
        }
        .background(Color.jcaCream.ignoresSafeArea())
        .navigationTitle("Donate")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(for: DonationRoute.self) { route in
            switch route {
            case .bhojanshala:
                BhojanshalaView()
                    .environment(donationVM)
            case .payment:
                PaymentView()
                    .environment(donationVM)
            case .success:
                // Success is handled via paymentResult in PaymentView
                EmptyView()
            }
        }
        .onAppear {
            let ratio = Double(truncating: (donationVM.donationGoal.raised / donationVM.donationGoal.target) as NSDecimalNumber)
            withAnimation(.easeOut(duration: 1.2)) {
                progressFill = ratio
            }
        }
    }
}

private struct GoalProgressCard: View {
    let target: Decimal
    let raised: Decimal
    let donors: Int
    let progress: Double

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: Radii.xl)
                .fill(LinearGradient(
                    colors: [Color.jcaCrimson, Color.jcaCrimsonDeep],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))

            // Decorative gold circle
            Circle()
                .stroke(Color.jcaGold.opacity(0.25), lineWidth: 40)
                .frame(width: 200, height: 200)
                .offset(x: 80, y: 30)

            VStack(alignment: .leading, spacing: 16) {
                HStack(alignment: .lastTextBaseline) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Annual Goal")
                            .font(JCAFont.label)
                            .foregroundStyle(Color.jcaCream.opacity(0.7))
                            .kerning(1)
                            .textCase(.uppercase)
                        Text(formatAmount(raised))
                            .font(.fraunces(size: 32, weight: .semibold))
                            .foregroundStyle(.white)
                    }
                    Spacer()
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("\(Int(progress * 100))%")
                            .font(JCAFont.headline)
                            .foregroundStyle(Color.jcaGoldLight)
                        Text("of \(formatAmount(target))")
                            .font(JCAFont.caption)
                            .foregroundStyle(Color.jcaCream.opacity(0.6))
                    }
                }

                // Progress bar
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.white.opacity(0.2))
                            .frame(height: 6)
                        RoundedRectangle(cornerRadius: 4)
                            .fill(LinearGradient(
                                colors: [Color.jcaGoldLight, Color.jcaGold],
                                startPoint: .leading,
                                endPoint: .trailing
                            ))
                            .frame(width: geo.size.width * progress, height: 6)
                    }
                }
                .frame(height: 6)

                // Stats
                HStack(spacing: 24) {
                    StatPill(value: "\(donors)", label: "Donors")
                    StatPill(value: formatAmount(raised), label: "Raised")
                    StatPill(value: formatAmount(target - raised), label: "Remaining")
                }
            }
            .padding(20)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Annual goal: \(formatAmount(raised)) raised out of \(formatAmount(target)), \(Int(progress * 100)) percent complete, \(donors) donors")
    }

    private func formatAmount(_ amount: Decimal) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_US")
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSDecimalNumber(decimal: amount)) ?? "$\(amount)"
    }
}

private struct StatPill: View {
    let value: String
    let label: String

    var body: some View {
        VStack(spacing: 1) {
            Text(value)
                .font(JCAFont.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
            Text(label)
                .font(JCAFont.caption)
                .foregroundStyle(Color.jcaCream.opacity(0.6))
        }
    }
}

#Preview {
    NavigationStack {
        DonateView()
            .environment(DonationFlowViewModel())
    }
}
