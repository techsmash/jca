import Foundation
import Observation

@Observable
final class SponsorState {
    static let shared = SponsorState()

    var currentSponsor: String = "Sunil Jain"
    let occasion: String = "Swamivatsalya"
    let blessing: String = "Bhaut Bhaut Anumodana"

    private init() {}
}
