import Foundation
import Observation
import SwiftData

@Observable
final class DonationFlowViewModel {
    var navigationPath: [DonationRoute] = []

    // Donation selection state
    var selectedCategory: DonationCategory?
    var selectedAmount: Decimal = 101
    var isRecurring: Bool = false
    var selectedMealType: MealType = .breakfast
    var selectedDate: Date = Date()

    // Payment state
    var selectedPaymentType: PaymentType = .creditCard
    var cardNumber: String = ""
    var cardExpiry: String = ""
    var cardCVV: String = ""
    var cardholderName: String = ""
    var billingZIP: String = ""
    var saveCard: Bool = false

    // Processing state
    var isProcessing: Bool = false
    var paymentResult: PaymentResult?
    var errorMessage: String?

    // Goals
    var donationGoal = MockDataProvider.donationGoal
    var categories: [DonationCategory] = MockDataProvider.donationCategories

    var formattedAmount: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_US")
        return formatter.string(from: NSDecimalNumber(decimal: selectedAmount)) ?? "$\(selectedAmount)"
    }

    var isCardFormValid: Bool {
        let digits = cardNumber.filter(\.isNumber)
        let cvvValid = cardCVV.filter(\.isNumber).count >= 3
        let nameValid = !cardholderName.trimmingCharacters(in: .whitespaces).isEmpty
        return digits.count >= 13 && !cardExpiry.isEmpty && cvvValid && nameValid
    }

    var isPayFormValid: Bool {
        guard selectedAmount > 0 else { return false }
        switch selectedPaymentType {
        case .creditCard, .debitCard:
            return isCardFormValid
        default:
            return true
        }
    }

    // Card number formatting with spaces every 4 digits
    func formattedCardNumber(_ raw: String) -> String {
        let digits = raw.filter(\.isNumber).prefix(16)
        var result = ""
        for (index, char) in digits.enumerated() {
            if index > 0 && index % 4 == 0 { result += " " }
            result.append(char)
        }
        return result
    }

    // Expiry formatting MM/YY
    func formattedExpiry(_ raw: String) -> String {
        let digits = raw.filter(\.isNumber).prefix(4)
        if digits.count > 2 {
            let month = String(digits.prefix(2))
            let year = String(digits.dropFirst(2))
            return "\(month)/\(year)"
        }
        return String(digits)
    }

    func submitPayment(user: User?, context: ModelContext) async {
        guard isPayFormValid else { return }
        isProcessing = true
        errorMessage = nil

        do {
            let result = try await DonationService.shared.processPayment(
                amount: selectedAmount,
                cause: selectedCategory?.name ?? "General Fund",
                paymentMethod: selectedPaymentType
            )
            paymentResult = result

            // Persist donation
            if let user = user {
                let donation = Donation(
                    amount: selectedAmount,
                    cause: selectedCategory?.name ?? "General Fund",
                    paymentMethodLast4: cardNumber.filter(\.isNumber).suffix(4).map(String.init).joined(),
                    transactionID: result.transactionID
                )
                user.donationHistory.append(donation)
                user.totalDonated += selectedAmount
                context.insert(donation)
                try? context.save()

                // Update sponsor banner with donor's name
                SponsorState.shared.currentSponsor = user.name
            }
        } catch {
            errorMessage = error.localizedDescription
        }

        isProcessing = false
    }

    func reset() {
        navigationPath = []
        selectedCategory = nil
        selectedAmount = 101
        cardNumber = ""
        cardExpiry = ""
        cardCVV = ""
        cardholderName = ""
        billingZIP = ""
        paymentResult = nil
        errorMessage = nil
    }
}

enum DonationRoute: Hashable {
    case bhojanshala
    case payment
    case success
}

enum MealType: String, CaseIterable, Identifiable {
    case breakfast = "Breakfast"
    case lunch = "Lunch"
    case dinner = "Dinner"
    case fullDay = "Full Day"

    var id: String { rawValue }

    var price: Decimal {
        switch self {
        case .breakfast: return 351
        case .lunch:     return 751
        case .dinner:    return 501
        case .fullDay:   return 1251
        }
    }

    var icon: String {
        switch self {
        case .breakfast: return "sunrise.fill"
        case .lunch:     return "sun.max.fill"
        case .dinner:    return "moon.fill"
        case .fullDay:   return "star.fill"
        }
    }
}
