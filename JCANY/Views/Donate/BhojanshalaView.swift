import SwiftUI

struct BhojanshalaView: View {
    @Environment(DonationFlowViewModel.self) private var donationVM

    var body: some View {
        @Bindable var vm = donationVM

        ScrollView {
            VStack(spacing: 0) {
                // Hero card
                BhojanshalaHeroCard()
                    .padding(.horizontal, 24)
                    .padding(.top, 16)

                // Meal types
                VStack(spacing: 14) {
                    SectionHeader(title: "Select Meal")
                        .padding(.horizontal, 24)

                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                        ForEach(MealType.allCases) { meal in
                            MealTypeCard(
                                meal: meal,
                                isSelected: donationVM.selectedMealType == meal
                            ) {
                                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                vm.selectedMealType = meal
                                vm.selectedAmount = meal.price
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                }
                .padding(.top, 24)

                // Date picker
                VStack(alignment: .leading, spacing: 14) {
                    SectionHeader(title: "Select Date")
                        .padding(.horizontal, 24)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(MockDataProvider.bhojanshalaDateOptions, id: \.self) { date in
                                DatePill(
                                    date: date,
                                    isSelected: Calendar.current.isDate(donationVM.selectedDate, inSameDayAs: date)
                                ) {
                                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                    vm.selectedDate = date
                                }
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.bottom, 4)
                    }
                }
                .padding(.top, 24)

                // CTA
                NavigationLink(destination: PaymentView().environment(donationVM)) {
                    HStack {
                        Text("Continue to Payment")
                            .font(JCAFont.bodyMedium)
                            .fontWeight(.semibold)
                        Spacer()
                        Text(donationVM.formattedAmount)
                            .font(JCAFont.bodyMedium)
                            .fontWeight(.bold)
                    }
                    .foregroundStyle(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: Radii.md)
                            .fill(Color.jcaCrimson)
                            .shadow(color: Color.jcaCrimson.opacity(0.25), radius: 8, y: 4)
                    )
                }
                .padding(.horizontal, 24)
                .padding(.top, 28)
                .padding(.bottom, 40)
            }
        }
        .background(Color.jcaCream.ignoresSafeArea())
        .navigationTitle("Sponsor Bhojanshala")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if donationVM.selectedDate == Date() || donationVM.selectedDate < Date() {
                donationVM.selectedDate = MockDataProvider.bhojanshalaDateOptions.first ?? Date()
            }
        }
    }
}

private struct BhojanshalaHeroCard: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: Radii.xl)
                .fill(LinearGradient(
                    colors: [Color.jcaCream, Color.jcaCreamWarm],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
                .overlay(
                    RoundedRectangle(cornerRadius: Radii.xl)
                        .stroke(Color.jcaGold.opacity(0.3), lineWidth: 1)
                )

            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(Color.jcaGold.opacity(0.15))
                        .frame(width: 64, height: 64)
                    Image(systemName: "fork.knife")
                        .font(.system(size: 26, weight: .medium))
                        .foregroundStyle(Color.jcaGoldDeep)
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text("Sponsor a Meal")
                        .font(JCAFont.headline)
                        .foregroundStyle(Color.jcaInk)
                    Text("Nourish the community\nwith a sacred meal offering")
                        .font(JCAFont.caption)
                        .foregroundStyle(Color.jcaMuted)
                        .lineSpacing(3)
                }
                Spacer()
            }
            .padding(20)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Sponsor a Bhojanshala meal to nourish the community")
    }
}

struct MealTypeCard: View {
    let meal: MealType
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 10) {
                ZStack {
                    Circle()
                        .fill(isSelected ? Color.jcaCrimson.opacity(0.12) : Color.jcaCrimson.opacity(0.06))
                        .frame(width: 48, height: 48)
                    Image(systemName: meal.icon)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(isSelected ? Color.jcaCrimson : Color.jcaMuted)
                }
                Text(meal.rawValue)
                    .font(JCAFont.subheadline)
                    .foregroundStyle(isSelected ? Color.jcaInk : Color.jcaInkSoft)
                Text(formatAmount(meal.price))
                    .font(.fraunces(size: 14, weight: .semibold))
                    .foregroundStyle(isSelected ? Color.jcaCrimson : Color.jcaMuted)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .background(
                RoundedRectangle(cornerRadius: Radii.base)
                    .fill(Color.jcaPaper)
                    .overlay(
                        RoundedRectangle(cornerRadius: Radii.base)
                            .stroke(isSelected ? Color.jcaCrimson : Color.jcaBorder, lineWidth: isSelected ? 1.5 : 0.5)
                    )
                    .shadowSm()
            )
            .animation(.spring(duration: 0.2), value: isSelected)
        }
        .buttonStyle(.plain)
        .accessibilityLabel("\(meal.rawValue) meal, \(formatAmount(meal.price))\(isSelected ? ", selected" : "")")
    }

    private func formatAmount(_ amount: Decimal) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_US")
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSDecimalNumber(decimal: amount)) ?? "$\(amount)"
    }
}

private struct DatePill: View {
    let date: Date
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 2) {
                Text(date.formatted(.dateTime.weekday(.abbreviated)).uppercased())
                    .font(JCAFont.caption)
                    .foregroundStyle(isSelected ? .white : Color.jcaMuted)
                Text(date.formatted(.dateTime.month(.abbreviated).day()))
                    .font(.fraunces(size: 14, weight: .semibold))
                    .foregroundStyle(isSelected ? .white : Color.jcaInk)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: Radii.m)
                    .fill(isSelected ? Color.jcaCrimson : Color.jcaPaper)
                    .overlay(
                        RoundedRectangle(cornerRadius: Radii.m)
                            .stroke(isSelected ? Color.jcaCrimson : Color.jcaBorder, lineWidth: 0.5)
                    )
                    .shadowSm()
            )
            .animation(.spring(duration: 0.2), value: isSelected)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(date.formatted(.dateTime.weekday().month().day()) + (isSelected ? ", selected" : ""))
    }
}

#Preview {
    NavigationStack {
        BhojanshalaView()
            .environment(DonationFlowViewModel())
    }
}
