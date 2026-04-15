import Foundation

struct PanchangData {
    var tithi: String
    var month: String
    var sunrise: String
    var sunset: String
    var pratikraman: String
    var nakshatra: String
}

struct PanchangService {
    static func today() -> PanchangData {
        // Static mock data matching spec
        PanchangData(
            tithi: "Chaitra Sud 8",
            month: "Chaitra",
            sunrise: "6:18 AM",
            sunset: "7:42 PM",
            pratikraman: "7:00 PM",
            nakshatra: "Pushya"
        )
    }
}
