import Foundation

struct PaymentResult {
    let transactionID: String
    let success: Bool
    let amount: Decimal
    let cause: String
}

final class DonationService {
    static let shared = DonationService()
    private init() {}

    func processPayment(amount: Decimal, cause: String, paymentMethod: PaymentType) async throws -> PaymentResult {
        // Simulate 2-second network delay
        try await Task.sleep(nanoseconds: 2_000_000_000)

        let txID = "TXN-\(Int(Date().timeIntervalSince1970))-\(Int.random(in: 100...999))"
        return PaymentResult(
            transactionID: txID,
            success: true,
            amount: amount,
            cause: cause
        )
    }
}
