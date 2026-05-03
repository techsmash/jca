import SwiftUI

struct FacilityBookingView: View {
    @State private var selectedDate = Date()
    @State private var bookingFacility: Facility? = nil
    @State private var showingPolicy = false

    private let facilities = MockDataProvider.facilities

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Date picker
                datePicker
                    .padding(.horizontal, 24)
                    .padding(.top, 16)

                // Policy note
                HStack(spacing: 8) {
                    Image(systemName: "leaf.fill")
                        .font(.system(size: 12))
                        .foregroundStyle(Color(hex: "#047857"))
                    Text("Pure-veg catering only · 14-day cancellation · $500 refundable deposit")
                        .font(JCAFont.caption)
                        .foregroundStyle(Color.jcaMuted)
                }
                .padding(.horizontal, 24)

                // Facility cards
                ForEach(facilities) { facility in
                    FacilityCard(facility: facility, selectedDate: selectedDate) {
                        bookingFacility = facility
                    }
                    .padding(.horizontal, 24)
                }

                Spacer().frame(height: 20)
            }
        }
        .background(Color.jcaCream.ignoresSafeArea())
        .navigationTitle("Book a Facility")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showingPolicy = true
                } label: {
                    Image(systemName: "info.circle")
                        .foregroundStyle(Color.jcaMuted)
                }
                .accessibilityLabel("Booking policy")
            }
        }
        .sheet(item: $bookingFacility) { facility in
            FacilityBookingSheet(facility: facility, date: selectedDate)
        }
        .sheet(isPresented: $showingPolicy) {
            BookingPolicySheet()
        }
    }

    @ViewBuilder
    private var datePicker: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Select Date")
                .font(JCAFont.headline)
                .foregroundStyle(Color.jcaInk)
            DatePicker(
                "Event date",
                selection: $selectedDate,
                in: Date()...,
                displayedComponents: .date
            )
            .datePickerStyle(.graphical)
            .tint(Color.jcaCrimson)
            .background(Color.jcaPaper)
            .clipShape(RoundedRectangle(cornerRadius: Radii.base))
            .overlay(
                RoundedRectangle(cornerRadius: Radii.base)
                    .stroke(Color.jcaBorder, lineWidth: 0.5)
            )
        }
    }
}

// MARK: - Facility Card

private struct FacilityCard: View {
    let facility: Facility
    let selectedDate: Date
    let onBook: () -> Void

    private var formattedDate: String {
        selectedDate.formatted(.dateTime.weekday(.wide).month(.wide).day())
    }
    private var memberRateString: String {
        formatCurrency(facility.memberRate)
    }
    private var publicRateString: String {
        formatCurrency(facility.publicRate)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.jcaCrimson.opacity(0.08))
                        .frame(width: 44, height: 44)
                    Image(systemName: facility.iconName)
                        .font(.system(size: 20))
                        .foregroundStyle(Color.jcaCrimson)
                }
                VStack(alignment: .leading, spacing: 3) {
                    Text(facility.name)
                        .font(.fraunces(size: 17, weight: .semibold))
                        .foregroundStyle(Color.jcaInk)
                    Text("Capacity \(facility.capacity)")
                        .font(JCAFont.caption)
                        .foregroundStyle(Color.jcaMuted)
                }
                Spacer()
            }

            Text(facility.description)
                .font(JCAFont.body)
                .foregroundStyle(Color.jcaInkSoft)

            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 4) {
                        Text(memberRateString)
                            .font(.fraunces(size: 18, weight: .semibold))
                            .foregroundStyle(Color.jcaInk)
                        Text("/ day · Member")
                            .font(JCAFont.caption)
                            .foregroundStyle(Color.jcaMuted)
                    }
                    Text("\(publicRateString) public rate")
                        .font(JCAFont.caption)
                        .foregroundStyle(Color.jcaMuted)
                        .strikethrough(true, color: Color.jcaMuted.opacity(0.5))
                }
                Spacer()
                Button(action: onBook) {
                    Text("Book")
                        .font(JCAFont.title)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 10)
                        .background(Color.jcaCrimson)
                        .clipShape(Capsule())
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Book \(facility.name) for \(formattedDate)")
            }
        }
        .padding(16)
        .background(Color.jcaPaper)
        .clipShape(RoundedRectangle(cornerRadius: Radii.base))
        .overlay(
            RoundedRectangle(cornerRadius: Radii.base)
                .stroke(Color.jcaBorder, lineWidth: 0.5)
        )
        .shadowSm()
    }

    private func formatCurrency(_ amount: Decimal) -> String {
        let f = NumberFormatter()
        f.numberStyle = .currency
        f.locale = Locale(identifier: "en_US")
        f.maximumFractionDigits = 0
        return f.string(from: NSDecimalNumber(decimal: amount)) ?? "$\(amount)"
    }
}

// MARK: - Booking Sheet

private struct FacilityBookingSheet: View {
    let facility: Facility
    let date: Date
    @Environment(\.dismiss) private var dismiss
    @State private var showingConfirmation = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Summary card
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Booking Summary")
                            .font(JCAFont.headline)
                            .foregroundStyle(Color.jcaInk)

                        summaryRow(label: "Facility", value: facility.name)
                        summaryRow(label: "Date", value: date.formatted(.dateTime.weekday().month().day().year()))
                        summaryRow(label: "Member Rate", value: formatCurrency(facility.memberRate))
                        summaryRow(label: "Deposit (refundable)", value: "$500")

                        Divider().overlay(Color.jcaBorder)

                        HStack {
                            Text("Total Due Today")
                                .font(JCAFont.title)
                                .foregroundStyle(Color.jcaInk)
                            Spacer()
                            Text(formatCurrency(facility.memberRate + 500))
                                .font(.fraunces(size: 20, weight: .semibold))
                                .foregroundStyle(Color.jcaCrimson)
                        }
                    }
                    .padding(16)
                    .background(Color.jcaPaper)
                    .clipShape(RoundedRectangle(cornerRadius: Radii.base))
                    .overlay(RoundedRectangle(cornerRadius: Radii.base).stroke(Color.jcaBorder, lineWidth: 0.5))
                    .shadowSm()
                    .padding(.horizontal, 24)

                    // Policy disclosure
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Booking Policy", systemImage: "checkmark.shield.fill")
                            .font(JCAFont.subheadline)
                            .foregroundStyle(Color.jcaInk)
                        policyItem("60% off standard rate for JCA members")
                        policyItem("$500 refundable security deposit")
                        policyItem("14-day cancellation for full refund")
                        policyItem("Pure-veg catering only — no non-veg food permitted")
                    }
                    .padding(16)
                    .background(Color(hex: "#0F766E").opacity(0.06))
                    .clipShape(RoundedRectangle(cornerRadius: Radii.base))
                    .overlay(RoundedRectangle(cornerRadius: Radii.base).stroke(Color(hex: "#0F766E").opacity(0.2), lineWidth: 1))
                    .padding(.horizontal, 24)

                    Button {
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        showingConfirmation = true
                    } label: {
                        Text("Proceed to Payment")
                            .font(JCAFont.title)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 15)
                            .background(Color.jcaCrimson)
                            .clipShape(RoundedRectangle(cornerRadius: Radii.base))
                    }
                    .buttonStyle(.plain)
                    .padding(.horizontal, 24)
                }
                .padding(.top, 20)
            }
            .background(Color.jcaCream.ignoresSafeArea())
            .navigationTitle("Confirm Booking")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                        .foregroundStyle(Color.jcaMuted)
                }
            }
            .alert("Booking Submitted", isPresented: $showingConfirmation) {
                Button("Done") { dismiss() }
            } message: {
                Text("Your booking request for \(facility.name) has been received. You'll receive a confirmation email within 24 hours.")
            }
        }
    }

    @ViewBuilder
    private func summaryRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(JCAFont.body)
                .foregroundStyle(Color.jcaMuted)
            Spacer()
            Text(value)
                .font(JCAFont.body)
                .foregroundStyle(Color.jcaInk)
        }
    }

    @ViewBuilder
    private func policyItem(_ text: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: "checkmark")
                .font(.system(size: 10, weight: .bold))
                .foregroundStyle(Color(hex: "#0F766E"))
                .padding(.top, 2)
            Text(text)
                .font(JCAFont.caption)
                .foregroundStyle(Color.jcaInkSoft)
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

// MARK: - Booking Policy Sheet

private struct BookingPolicySheet: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    policySection(
                        title: "Member Discounts",
                        items: [
                            "JCA members receive 60% off the standard public rate",
                            "Discount requires valid member ID at time of booking",
                        ]
                    )
                    policySection(
                        title: "Deposit & Payment",
                        items: [
                            "$500 refundable security deposit required at booking",
                            "Deposit returned within 7 days of event if facility left in satisfactory condition",
                            "Balance due 14 days before event date",
                        ]
                    )
                    policySection(
                        title: "Cancellation",
                        items: [
                            "Full refund (including deposit) if cancelled 14+ days before event",
                            "50% refund of rental fee for cancellations 7–13 days prior",
                            "No refund for cancellations within 7 days",
                        ]
                    )
                    policySection(
                        title: "Catering",
                        items: [
                            "Pure-veg catering only — no non-vegetarian food permitted",
                            "No root vegetables (onion, garlic, potato) in common areas",
                            "Approved caterers list available from JCA office",
                        ]
                    )
                }
                .padding(24)
            }
            .background(Color.jcaCream.ignoresSafeArea())
            .navigationTitle("Booking Policy")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                        .foregroundStyle(Color.jcaCrimson)
                }
            }
        }
    }

    @ViewBuilder
    private func policySection(title: String, items: [String]) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(JCAFont.headline)
                .foregroundStyle(Color.jcaInk)
            ForEach(items, id: \.self) { item in
                HStack(alignment: .top, spacing: 10) {
                    Circle()
                        .fill(Color.jcaCrimson)
                        .frame(width: 5, height: 5)
                        .padding(.top, 6)
                    Text(item)
                        .font(JCAFont.body)
                        .foregroundStyle(Color.jcaInkSoft)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        FacilityBookingView()
    }
}
