import SwiftUI
import SwiftData

struct PaymentView: View {
    @Environment(DonationFlowViewModel.self) private var donationVM
    @Environment(\.modelContext) private var modelContext
    @Query private var users: [User]
    @FocusState private var focusedField: CardField?
    @State private var amountString: String = ""

    enum CardField { case number, expiry, cvv, name, zip, amount }

    let paymentTypes: [PaymentType] = [.creditCard, .applePay, .googlePay, .payPal, .zelle, .ach]

    var body: some View {
        @Bindable var vm = donationVM

        ScrollView {
            VStack(spacing: 24) {
                // Editable amount card
                EditableAmountCard(
                    cause: donationVM.selectedCategory?.name ?? "General Fund",
                    amountString: $amountString
                )
                .padding(.horizontal, 24)
                .padding(.top, 16)

                // Payment method grid
                VStack(alignment: .leading, spacing: 14) {
                    Text("Payment Method")
                        .font(JCAFont.headline)
                        .foregroundStyle(Color.jcaInk)
                        .padding(.horizontal, 24)

                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                        ForEach(paymentTypes, id: \.self) { method in
                            PaymentMethodOptionCard(
                                paymentType: method,
                                isSelected: donationVM.selectedPaymentType == method
                            ) {
                                vm.selectedPaymentType = method
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                }

                // Card form (only for credit/debit)
                if donationVM.selectedPaymentType == .creditCard || donationVM.selectedPaymentType == .debitCard {
                    VStack(spacing: 20) {
                        // Live card preview
                        CreditCardPreview(
                            cardNumber: donationVM.cardNumber,
                            cardholderName: donationVM.cardholderName,
                            expiry: donationVM.cardExpiry
                        )
                        .padding(.horizontal, 24)

                        // Form fields
                        VStack(spacing: 14) {
                            // Card number
                            IOSTextField(
                                label: "Card Number",
                                placeholder: "•••• •••• •••• ••••",
                                text: Binding(
                                    get: { donationVM.cardNumber },
                                    set: { vm.cardNumber = donationVM.formattedCardNumber($0) }
                                ),
                                keyboardType: .numberPad
                            )
                            .focused($focusedField, equals: .number)

                            HStack(spacing: 12) {
                                IOSTextField(
                                    label: "Expiry",
                                    placeholder: "MM/YY",
                                    text: Binding(
                                        get: { donationVM.cardExpiry },
                                        set: { vm.cardExpiry = donationVM.formattedExpiry($0) }
                                    ),
                                    keyboardType: .numberPad
                                )
                                .focused($focusedField, equals: .expiry)

                                IOSTextField(
                                    label: "CVV",
                                    placeholder: "•••",
                                    text: $vm.cardCVV,
                                    isSecure: true,
                                    keyboardType: .numberPad
                                )
                                .focused($focusedField, equals: .cvv)
                            }

                            IOSTextField(
                                label: "Cardholder Name",
                                placeholder: "Manan Shah",
                                text: $vm.cardholderName,
                                textContentType: .name
                            )
                            .focused($focusedField, equals: .name)

                            IOSTextField(
                                label: "Billing ZIP",
                                placeholder: "10001",
                                text: $vm.billingZIP,
                                keyboardType: .numberPad,
                                textContentType: .postalCode
                            )
                            .focused($focusedField, equals: .zip)
                        }
                        .padding(.horizontal, 24)

                        // Save card toggle
                        HStack {
                            Text("Save card for future donations")
                                .font(JCAFont.body)
                                .foregroundStyle(Color.jcaInk)
                            Spacer()
                            Toggle("", isOn: $vm.saveCard)
                                .tint(Color.jcaCrimson)
                        }
                        .padding(.horizontal, 24)
                    }
                }

                // Error message
                if let error = donationVM.errorMessage {
                    Text(error)
                        .font(JCAFont.caption)
                        .foregroundStyle(Color.jcaCrimson)
                        .padding(.horizontal, 24)
                }

                // Pay button
                PrimaryButton(
                    title: donationVM.isProcessing ? "Processing..." : "Pay \(donationVM.formattedAmount)",
                    icon: donationVM.isProcessing ? nil : "lock.fill",
                    isLoading: donationVM.isProcessing,
                    isDisabled: !donationVM.isPayFormValid
                ) {
                    focusedField = nil
                    Task {
                        await donationVM.submitPayment(user: users.first, context: modelContext)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
        .background(Color.jcaCream.ignoresSafeArea())
        .navigationTitle("Payment")
        .navigationBarTitleDisplayMode(.inline)
        .onTapGesture { focusedField = nil }
        .onAppear {
            let amt = donationVM.selectedAmount
            amountString = amt > 0 ? String(describing: amt) : ""
        }
        .onChange(of: amountString) { _, newValue in
            let cleaned = newValue.replacingOccurrences(of: ",", with: "").replacingOccurrences(of: "$", with: "")
            if let d = Decimal(string: cleaned), d >= 0 {
                donationVM.selectedAmount = d
            } else if cleaned.isEmpty {
                donationVM.selectedAmount = 0
            }
        }
        .navigationDestination(isPresented: Binding(
            get: { donationVM.paymentResult != nil },
            set: { if !$0 { donationVM.paymentResult = nil } }
        )) {
            if let result = donationVM.paymentResult {
                PaymentSuccessView(result: result)
                    .environment(donationVM)
            }
        }
    }
}

private struct EditableAmountCard: View {
    let cause: String
    @Binding var amountString: String
    @FocusState private var isFocused: Bool

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Donating to")
                        .font(JCAFont.label)
                        .foregroundStyle(Color.jcaMuted)
                        .kerning(0.8)
                        .textCase(.uppercase)
                    Text(cause)
                        .font(JCAFont.headline)
                        .foregroundStyle(Color.jcaInk)
                }
                Spacer()
                HStack(alignment: .firstTextBaseline, spacing: 2) {
                    Text("$")
                        .font(.fraunces(size: 22, weight: .medium))
                        .foregroundStyle(Color.jcaCrimson)
                    TextField("0", text: $amountString)
                        .font(.fraunces(size: 28, weight: .semibold))
                        .foregroundStyle(Color.jcaCrimson)
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.trailing)
                        .focused($isFocused)
                        .frame(minWidth: 60, maxWidth: 120)
                }
            }
            .padding(18)
        }
        .background(
            RoundedRectangle(cornerRadius: Radii.base)
                .fill(Color.jcaPaper)
                .overlay(
                    RoundedRectangle(cornerRadius: Radii.base)
                        .stroke(isFocused ? Color.jcaCrimson.opacity(0.4) : Color.jcaBorder, lineWidth: isFocused ? 1 : 0.5)
                )
                .shadowSm()
        )
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Donating to \(cause). Amount field.")
    }
}

struct PaymentSuccessView: View {
    @Environment(DonationFlowViewModel.self) private var donationVM
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss
    let result: PaymentResult
    @State private var checkmarkScale: CGFloat = 0
    @State private var showContent = false
    @State private var showShareSheet = false

    private var receiptText: String {
        """
        JCA NY Donation Receipt
        -----------------------
        Amount:         \(formatAmount(result.amount))
        Cause:          \(result.cause)
        Transaction ID: \(result.transactionID)
        Date:           \(Date().formatted(.dateTime.day().month().year()))

        Jay Jinendra 🙏
        Jain Center of America, New York
        """
    }

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 24) {
                // Animated checkmark
                ZStack {
                    Circle()
                        .fill(Color.jcaCrimson.opacity(0.1))
                        .frame(width: 100, height: 100)
                    Circle()
                        .fill(Color.jcaCrimson.opacity(0.2))
                        .frame(width: 80, height: 80)
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 56))
                        .foregroundStyle(Color.jcaCrimson)
                        .scaleEffect(checkmarkScale)
                }
                .onAppear {
                    withAnimation(.spring(duration: 0.6, bounce: 0.4)) {
                        checkmarkScale = 1
                    }
                }

                VStack(spacing: 8) {
                    Text("Donation Complete!")
                        .font(JCAFont.displayLarge)
                        .foregroundStyle(Color.jcaInk)
                    Text("Jay Jinendra 🙏")
                        .font(.frauncesItalic(size: 18))
                        .foregroundStyle(Color.jcaGold)
                }

                VStack(spacing: 12) {
                    SuccessRow(label: "Amount", value: formatAmount(result.amount))
                    SuccessRow(label: "Cause", value: result.cause)
                    SuccessRow(label: "Transaction ID", value: result.transactionID)
                    SuccessRow(label: "Date", value: Date().formatted(.dateTime.day().month(.abbreviated).year()))
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: Radii.base)
                        .fill(Color.jcaPaper)
                        .overlay(
                            RoundedRectangle(cornerRadius: Radii.base)
                                .stroke(Color.jcaBorder, lineWidth: 0.5)
                        )
                )
                .padding(.horizontal, 24)
            }
            .opacity(showContent ? 1 : 0)
            .onAppear {
                withAnimation(.easeOut(duration: 0.4).delay(0.3)) {
                    showContent = true
                }
            }

            Spacer()

            VStack(spacing: 12) {
                // Download / Share receipt
                ShareLink(item: receiptText) {
                    HStack(spacing: 8) {
                        Image(systemName: "arrow.down.doc.fill")
                        Text("Download Receipt")
                    }
                    .font(JCAFont.bodyMedium)
                    .foregroundStyle(Color.jcaCrimson)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(
                        RoundedRectangle(cornerRadius: Radii.m)
                            .stroke(Color.jcaCrimson, lineWidth: 1)
                    )
                }
                .accessibilityLabel("Download receipt")

                Button {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    appState.selectedTab = .home
                    // Delay reset so tab switch animates first
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        donationVM.reset()
                    }
                } label: {
                    Text("Back to Home")
                        .font(JCAFont.bodyMedium)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: Radii.md)
                                .fill(Color.jcaCrimson)
                        )
                }
                .accessibilityLabel("Return to home screen")
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
        }
        .background(Color.jcaCream.ignoresSafeArea())
        .navigationBarBackButtonHidden(true)
    }

    private func formatAmount(_ amount: Decimal) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_US")
        return formatter.string(from: NSDecimalNumber(decimal: amount)) ?? "$\(amount)"
    }
}

private struct SuccessRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .font(JCAFont.caption)
                .foregroundStyle(Color.jcaMuted)
            Spacer()
            Text(value)
                .font(JCAFont.subheadline)
                .foregroundStyle(Color.jcaInk)
        }
    }
}

#Preview {
    NavigationStack {
        PaymentView()
            .environment(DonationFlowViewModel())
    }
    .modelContainer(for: [User.self, Donation.self])
}
