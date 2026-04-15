import Foundation

struct ParvaDay: Identifiable, Hashable {
    let id: UUID
    var name: String
    var date: Date
    var description: String
    var significance: String

    init(
        id: UUID = UUID(),
        name: String,
        date: Date,
        description: String = "",
        significance: String = ""
    ) {
        self.id = id
        self.name = name
        self.date = date
        self.description = description
        self.significance = significance
    }

    var daysUntil: Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: calendar.startOfDay(for: Date()), to: calendar.startOfDay(for: date))
        return max(0, components.day ?? 0)
    }
}
