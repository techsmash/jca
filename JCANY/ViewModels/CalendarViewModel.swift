import Foundation
import Observation

@Observable
final class CalendarViewModel {
    var currentMonth: Date = Date()
    var selectedDate: Date? = nil
    var parvaDays: [ParvaDay] = MockDataProvider.parvaDays
    var events: [Event] = MockDataProvider.events

    private let calendar = Calendar.current

    var monthDays: [Date?] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: currentMonth) else { return [] }
        let start = monthInterval.start
        let firstWeekday = calendar.component(.weekday, from: start) - 1

        var days: [Date?] = Array(repeating: nil, count: firstWeekday)

        let daysInMonth = calendar.range(of: .day, in: .month, for: currentMonth)?.count ?? 30
        for day in 1...daysInMonth {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: start) {
                days.append(date)
            }
        }

        // Pad to multiple of 7
        while days.count % 7 != 0 { days.append(nil) }
        return days
    }

    var monthTitle: String {
        currentMonth.formatted(.dateTime.month(.wide).year())
    }

    func isParvaDay(_ date: Date) -> Bool {
        parvaDays.contains { calendar.isDate($0.date, inSameDayAs: date) }
    }

    func isToday(_ date: Date) -> Bool {
        calendar.isDateInToday(date)
    }

    func isSelected(_ date: Date) -> Bool {
        guard let selected = selectedDate else { return false }
        return calendar.isDate(selected, inSameDayAs: date)
    }

    func eventsFor(_ date: Date) -> [Event] {
        events.filter { calendar.isDate($0.date, inSameDayAs: date) }
    }

    func parvaFor(_ date: Date) -> ParvaDay? {
        parvaDays.first { calendar.isDate($0.date, inSameDayAs: date) }
    }

    func nextMonth() {
        currentMonth = calendar.date(byAdding: .month, value: 1, to: currentMonth) ?? currentMonth
    }

    func prevMonth() {
        currentMonth = calendar.date(byAdding: .month, value: -1, to: currentMonth) ?? currentMonth
    }
}
