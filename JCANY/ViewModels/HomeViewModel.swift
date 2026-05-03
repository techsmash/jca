import Foundation
import Observation

// MARK: - Supporting data types

struct QuoteOfDay {
    let text: String
    let attribution: String
}

struct DailyQuizItem {
    let question: String
    let options: [String]
    let correctIndex: Int
}

struct CenterHoursData {
    struct DayEntry {
        let day: String
        let hours: String
        let isToday: Bool
    }
    let isOpenNow: Bool
    let schedule: [DayEntry]

    static func current() -> CenterHoursData {
        let cal = Calendar.current
        let now = Date()
        let weekday = cal.component(.weekday, from: now) // 1=Sun … 7=Sat
        let minutes = cal.component(.hour, from: now) * 60 + cal.component(.minute, from: now)

        func isWeekend(_ wd: Int) -> Bool { wd == 1 || wd == 7 }
        let isOpenNow = isWeekend(weekday) ? (480..<1260).contains(minutes) : (1020..<1260).contains(minutes)

        let days = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
        let schedule = days.enumerated().map { i, day in
            let wd = i + 1
            return DayEntry(
                day: day,
                hours: isWeekend(wd) ? "8:00 AM – 9:00 PM" : "5:00 PM – 9:00 PM",
                isToday: wd == weekday
            )
        }
        return CenterHoursData(isOpenNow: isOpenNow, schedule: schedule)
    }
}

struct HomePreviewPost: Identifiable {
    enum Kind { case admin, member }
    var id = UUID()
    let kind: Kind
    let authorInitials: String
    let authorName: String
    let body: String
    let timeAgo: String
    let isPinned: Bool
}

// MARK: - ViewModel

@Observable
final class HomeViewModel {
    // Existing
    var panchang: PanchangData = PanchangService.today()
    var events: [Event] = MockDataProvider.events

    // Quote of the day
    var quoteOfDay: QuoteOfDay = Self.todaysQuote()

    // Daily quiz state
    var quizDayIndex: Int = 1
    var quizStreak: Int = 0
    var quizSelectedAnswer: Int? = nil

    // Center hours (computed from wall clock on init)
    var centerHours: CenterHoursData = .current()

    // Community feed preview
    let feedPreviewPosts: [HomePreviewPost] = Self.mockFeedPosts()

    init() {
        loadQuizState()
    }

    // MARK: - Quiz

    var currentQuiz: DailyQuizItem {
        let bank = Self.quizBank
        return bank[(quizDayIndex - 1) % bank.count]
    }

    func answerQuiz(optionIndex: Int) {
        guard quizSelectedAnswer == nil else { return }
        quizSelectedAnswer = optionIndex

        let defaults = UserDefaults.standard
        let fmt = Self.dateFmt
        let todayStr = fmt.string(from: Date())
        let lastAnsweredStr = defaults.string(forKey: "jca.quiz.lastAnsweredDate") ?? ""

        guard lastAnsweredStr != todayStr else { return }

        var newStreak = 1
        if let lastDate = fmt.date(from: lastAnsweredStr) {
            let days = Calendar.current.dateComponents(
                [.day],
                from: Calendar.current.startOfDay(for: lastDate),
                to: Calendar.current.startOfDay(for: Date())
            ).day ?? 0
            if days == 1 { newStreak = quizStreak + 1 }
        }
        quizStreak = newStreak
        defaults.set(newStreak, forKey: "jca.quiz.streak")
        defaults.set(todayStr, forKey: "jca.quiz.lastAnsweredDate")
        defaults.set(optionIndex, forKey: "jca.quiz.selectedAnswer")
    }

    private func loadQuizState() {
        let defaults = UserDefaults.standard
        let cal = Calendar.current
        let fmt = Self.dateFmt
        let today = cal.startOfDay(for: Date())
        let todayStr = fmt.string(from: today)

        // Day index — increments once per new calendar day
        let lastViewedStr = defaults.string(forKey: "jca.quiz.lastViewedDate") ?? ""
        var dayIndex = max(1, defaults.integer(forKey: "jca.quiz.dayIndex"))
        if lastViewedStr.isEmpty {
            dayIndex = 1
        } else if lastViewedStr != todayStr {
            dayIndex += 1
        }
        defaults.set(dayIndex, forKey: "jca.quiz.dayIndex")
        defaults.set(todayStr, forKey: "jca.quiz.lastViewedDate")
        quizDayIndex = dayIndex

        // Streak — reset if more than one day has passed since last answer
        let lastAnsweredStr = defaults.string(forKey: "jca.quiz.lastAnsweredDate") ?? ""
        var streak = defaults.integer(forKey: "jca.quiz.streak")
        if !lastAnsweredStr.isEmpty, let lastDate = fmt.date(from: lastAnsweredStr) {
            let daysSince = cal.dateComponents([.day], from: cal.startOfDay(for: lastDate), to: today).day ?? 0
            if daysSince > 1 {
                streak = 0
                defaults.set(0, forKey: "jca.quiz.streak")
            }
        }
        quizStreak = streak

        // Already answered today?
        if lastAnsweredStr == todayStr {
            quizSelectedAnswer = defaults.integer(forKey: "jca.quiz.selectedAnswer")
        }
    }

    private static let dateFmt: ISO8601DateFormatter = {
        let f = ISO8601DateFormatter()
        f.formatOptions = [.withFullDate]
        return f
    }()

    // MARK: - Static content

    private static func todaysQuote() -> QuoteOfDay {
        let bank: [QuoteOfDay] = [
            QuoteOfDay(
                text: "Parasparopagraho Jīvānām — all life is bound together by mutual support and interdependence.",
                attribution: "Tattvārtha Sūtra, 5.21"
            ),
            QuoteOfDay(
                text: "Live and let live. Injure no one; do no harm to any life.",
                attribution: "Lord Mahavir"
            ),
            QuoteOfDay(
                text: "Conquer anger by forgiveness, pride by modesty, deceit by honesty, and greed by contentment.",
                attribution: "Lord Mahavir"
            ),
            QuoteOfDay(
                text: "The soul comes alone and goes alone, no one accompanies it, and no one becomes its mate.",
                attribution: "Acharanga Sutra"
            ),
            QuoteOfDay(
                text: "Anekānta — reality is multifaceted; any single perspective captures only a partial truth.",
                attribution: "Tattvārtha Sūtra"
            ),
            QuoteOfDay(
                text: "The greatest sin is to be unkind. The greatest merit is compassion toward all living beings.",
                attribution: "Mahavir Swami"
            ),
            QuoteOfDay(
                text: "Have compassion towards all living beings. Hatred leads to destruction.",
                attribution: "Lord Mahavir"
            ),
        ]
        let dayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 1
        return bank[(dayOfYear - 1) % bank.count]
    }

    static let quizBank: [DailyQuizItem] = [
        DailyQuizItem(
            question: "How many Mahavratas (Great Vows) are observed in Jain monastic life?",
            options: ["Three", "Five", "Seven", "Nine"],
            correctIndex: 1
        ),
        DailyQuizItem(
            question: "Which parva marks the end of Paryushan with collective forgiveness?",
            options: ["Diwali", "Mahavir Jayanti", "Samvatsari", "Das Lakshan"],
            correctIndex: 2
        ),
        DailyQuizItem(
            question: "How many Tirthankaras are in the current cosmic cycle?",
            options: ["Twelve", "Forty-Eight", "One Hundred Eight", "Twenty-Four"],
            correctIndex: 3
        ),
        DailyQuizItem(
            question: "Which is the first and foremost Mahavrata in Jainism?",
            options: ["Aparigraha", "Brahmacharya", "Satya", "Ahimsa"],
            correctIndex: 3
        ),
        DailyQuizItem(
            question: "What Jain concept describes non-attachment to worldly possessions?",
            options: ["Ahimsa", "Satya", "Asteya", "Aparigraha"],
            correctIndex: 3
        ),
        DailyQuizItem(
            question: "For how many days is Paryushan Parva observed by Shvetambar Jains?",
            options: ["Five days", "Eight days", "Ten days", "Fourteen days"],
            correctIndex: 1
        ),
        DailyQuizItem(
            question: "What is the most sacred mantra in Jainism, recited during pratikraman?",
            options: ["Gayatri Mantra", "Mahamrityunjaya", "Navkar Mantra", "Shanti Path"],
            correctIndex: 2
        ),
    ]

    private static func mockFeedPosts() -> [HomePreviewPost] {
        [
            HomePreviewPost(
                kind: .admin,
                authorInitials: "JC",
                authorName: "JCA New York",
                body: "Reminder: Paryushan Parva begins Saturday. All schedules are posted on the Calendar tab. Jai Jinendra 🙏",
                timeAgo: "2h ago",
                isPinned: true
            ),
            HomePreviewPost(
                kind: .member,
                authorInitials: "PS",
                authorName: "Priya Shah",
                body: "Beautiful Snatra Puja this morning — so grateful to be part of this sangha. Anumodana to all who participated 🪷",
                timeAgo: "4h ago",
                isPinned: false
            ),
        ]
    }
}
