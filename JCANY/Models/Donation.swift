import Foundation
import SwiftData

@Model
final class Donation {
    var id: UUID
    var amount: Decimal
    var cause: String
    var date: Date
    var paymentMethodLast4: String?
    var transactionID: String
    var isRecurring: Bool

    init(
        id: UUID = UUID(),
        amount: Decimal,
        cause: String,
        date: Date = Date(),
        paymentMethodLast4: String? = nil,
        transactionID: String,
        isRecurring: Bool = false
    ) {
        self.id = id
        self.amount = amount
        self.cause = cause
        self.date = date
        self.paymentMethodLast4 = paymentMethodLast4
        self.transactionID = transactionID
        self.isRecurring = isRecurring
    }
}
