import Foundation
import SwiftData

struct MockDataProvider {

    static func seedIfNeeded(context: ModelContext) {
        let descriptor = FetchDescriptor<User>()
        let existing = (try? context.fetch(descriptor)) ?? []
        guard existing.isEmpty else { return }
        seed(context: context)
    }

    static func seed(context: ModelContext) {
        // User
        let user = User(
            name: "Manan Shah",
            email: "manan.shah@jcany.org",
            memberID: "04812",
            memberTier: "Life Member",
            avatarInitial: "M",
            totalDonated: 2851,
            sevaHours: 142
        )

        // Family members
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "America/New_York")!

        func date(year: Int, month: Int, day: Int) -> Date {
            var components = DateComponents()
            components.year = year
            components.month = month
            components.day = day
            return calendar.date(from: components) ?? Date()
        }

        let father = FamilyMember(
            name: "Rajesh Shah",
            relation: "Father",
            dateOfBirth: date(year: 1968, month: 8, day: 12),
            avatarInitial: "R"
        )
        let mother = FamilyMember(
            name: "Sunita Shah",
            relation: "Mother",
            dateOfBirth: date(year: 1972, month: 3, day: 4),
            avatarInitial: "S"
        )
        let sister = FamilyMember(
            name: "Priya Shah",
            relation: "Sister",
            dateOfBirth: date(year: 2001, month: 11, day: 21),
            avatarInitial: "P"
        )

        user.familyMembers = [father, mother, sister]

        // Payment method
        let visa = PaymentMethod(
            type: .creditCard,
            last4: "8891",
            brand: "Visa",
            expiryMonth: 8,
            expiryYear: 2028,
            cardholderName: "Manan Shah",
            isDefault: true
        )
        user.savedPaymentMethods = [visa]

        // Donation history
        let donation1 = Donation(
            amount: 1001,
            cause: "Temple Maintenance",
            date: date(year: 2025, month: 12, day: 15),
            paymentMethodLast4: "8891",
            transactionID: "TXN-20251215-001"
        )
        let donation2 = Donation(
            amount: 500,
            cause: "Pathshala Education",
            date: date(year: 2025, month: 10, day: 3),
            paymentMethodLast4: "8891",
            transactionID: "TXN-20251003-042"
        )
        let donation3 = Donation(
            amount: 1350,
            cause: "General Fund",
            date: date(year: 2025, month: 6, day: 28),
            paymentMethodLast4: "8891",
            transactionID: "TXN-20250628-018"
        )
        user.donationHistory = [donation1, donation2, donation3]

        context.insert(user)
        context.insert(father)
        context.insert(mother)
        context.insert(sister)
        context.insert(visa)
        context.insert(donation1)
        context.insert(donation2)
        context.insert(donation3)

        try? context.save()
    }

    // MARK: - In-memory mock data

    static var events: [Event] {
        var cal = Calendar.current
        cal.timeZone = TimeZone(identifier: "America/New_York")!

        func date(year: Int, month: Int, day: Int) -> Date {
            var c = DateComponents(); c.year = year; c.month = month; c.day = day
            return cal.date(from: c) ?? Date()
        }

        return [
            Event(
                title: "Mahavir Janma Kalyanak",
                subtitle: "Paryushana Parva",
                date: date(year: 2026, month: 4, day: 26),
                location: "JCA Main Temple, Elmhurst, NY",
                description: "Celebrate the auspicious birth anniversary of Lord Mahavir. Join us for aarti, pravachan, and community lunch.",
                category: "Festival",
                isRSVPed: false
            ),
            Event(
                title: "Pathshala Spring Term",
                subtitle: "Registration Open",
                date: date(year: 2026, month: 4, day: 19),
                location: "JCA Education Hall",
                description: "Spring term classes begin for all levels. Register your children for Bal Vihar, Yuva, and Advanced programs.",
                category: "Education",
                isRSVPed: true
            ),
            Event(
                title: "Lecture by Acharya Vijay",
                subtitle: "Spiritual Discourse",
                date: date(year: 2026, month: 5, day: 4),
                location: "Shrimad Rajchandra Hall",
                description: "Special discourse by Acharya Vijay on the principles of Ahimsa and non-violence in modern life.",
                category: "Spiritual",
                isRSVPed: false
            )
        ]
    }

    static var parvaDays: [ParvaDay] {
        var cal = Calendar.current
        cal.timeZone = TimeZone(identifier: "America/New_York")!

        func date(year: Int, month: Int, day: Int) -> Date {
            var c = DateComponents(); c.year = year; c.month = month; c.day = day
            return cal.date(from: c) ?? Date()
        }

        return [
            ParvaDay(
                name: "Mahavir Janma Kalyanak",
                date: date(year: 2026, month: 4, day: 26),
                description: "Birth anniversary of Lord Mahavir",
                significance: "One of the most important Jain festivals"
            ),
            ParvaDay(
                name: "Ayambil Oli",
                date: date(year: 2026, month: 4, day: 8),
                description: "Nine-day austerity period",
                significance: "Devotees observe ayambil (bland food) for nine days"
            ),
            ParvaDay(
                name: "Akshay Tritiya",
                date: date(year: 2026, month: 4, day: 22),
                description: "Auspicious day for giving",
                significance: "First day of the year on the Jain calendar"
            ),
            ParvaDay(
                name: "Paryushana",
                date: date(year: 2026, month: 8, day: 26),
                description: "Most sacred Jain festival",
                significance: "Eight-day festival of spiritual renewal"
            )
        ]
    }

    static var shrines: [Shrine] {
        [
            Shrine(name: "Mahavir Swami", subtitle: "Main Sanctum", description: "The principal deity of JCA NY, Lord Mahavir in the dhyan mudra.", romanNumeral: "i"),
            Shrine(name: "Adinathji", subtitle: "First Tirthankar", description: "Shrine of the first Tirthankar, Lord Adinath, with traditional marble carving.", romanNumeral: "ii"),
            Shrine(name: "Upashray", subtitle: "Meditation Hall", description: "Serene meditation and prayer space for daily rituals and personal reflection.", romanNumeral: "iii"),
            Shrine(name: "Shrimad Rajchandra Hall", subtitle: "Cultural Center", description: "Multi-purpose hall for lectures, events, and community gatherings.", romanNumeral: "iv"),
            Shrine(name: "Dadawadi", subtitle: "Ancestral Shrine", description: "Dedicated to Dada Gurudev, housing sacred relics and padukas.", romanNumeral: "v"),
            Shrine(name: "Ashtapad & Art Gallery", subtitle: "Sacred Mountain", description: "Replica of the holy Ashtapad mountain with traditional Jain art.", romanNumeral: "vi")
        ]
    }

    static var donationCategories: [DonationCategory] {
        [
            DonationCategory(name: "General Fund", description: "Where it's needed most", iconName: "heart.fill", defaultAmount: 0),
            DonationCategory(name: "Temple Maintenance", description: "Preserve the sacred temple grounds", iconName: "building.columns.fill", defaultAmount: 251),
            DonationCategory(name: "Sponsor Bhojanshala", description: "Feed the community with a meal", iconName: "fork.knife", defaultAmount: 1251, isBhojanshala: true),
            DonationCategory(name: "Pathshala Education", description: "Support religious education programs", iconName: "book.fill", defaultAmount: 151),
            DonationCategory(name: "Matching Gifts Program", description: "Double your impact via employer", iconName: "arrow.triangle.2.circlepath", defaultAmount: 0)
        ]
    }

    static var donationGoal: (target: Decimal, raised: Decimal, donors: Int) {
        (500_000, 340_210, 1247)
    }

    static var volunteerOpportunities: [VolunteerOpportunity] {
        [
            VolunteerOpportunity(
                title: "Bhojanshala Helper",
                description: "Help prepare and serve community meals every Sunday. Training provided.",
                date: "Every Sunday · 10 AM – 2 PM",
                spotsAvailable: 3,
                isUrgent: true,
                category: "Food Service"
            ),
            VolunteerOpportunity(
                title: "Pathshala Teacher's Aide",
                description: "Assist Pathshala teachers with class preparation and student support.",
                date: "Saturdays · 9 AM – 12 PM",
                spotsAvailable: 5,
                isUrgent: false,
                category: "Education"
            ),
            VolunteerOpportunity(
                title: "MJK Event Volunteer",
                description: "Help organize Mahavir Janma Kalyanak celebrations including setup and coordination.",
                date: "Apr 26 · 6 AM – 8 PM",
                spotsAvailable: 20,
                isUrgent: false,
                category: "Events"
            ),
            VolunteerOpportunity(
                title: "Senior Group Driver",
                description: "Provide transportation for senior members to temple events and programs.",
                date: "Weekends · Flexible",
                spotsAvailable: 8,
                isUrgent: false,
                category: "Community"
            )
        ]
    }

    static var pathshalaLessons: [PathshalaLesson] {
        [
            PathshalaLesson(
                title: "The 5 Mahavratas Explained",
                subtitle: "Non-violence, Truth, Non-stealing, Celibacy, Non-possession",
                level: .advanced,
                lessonNumber: 7,
                totalLessons: 12,
                progressPercent: 0.60,
                duration: "60 min",
                nextClass: "Sat, Apr 19 · 10:00 AM"
            ),
            PathshalaLesson(
                title: "Stories of Lord Mahavir",
                subtitle: "His life journey and teachings",
                level: .balVihar,
                lessonNumber: 4,
                totalLessons: 10,
                progressPercent: 0.35,
                duration: "45 min",
                nextClass: "Sat, Apr 19 · 9:00 AM"
            ),
            PathshalaLesson(
                title: "Introduction to Navkar Mantra",
                subtitle: "Understanding the sacred prayer",
                level: .yuva,
                lessonNumber: 2,
                totalLessons: 8,
                progressPercent: 0.20,
                duration: "50 min",
                nextClass: "Sat, Apr 19 · 11:00 AM"
            )
        ]
    }

    static var newsItems: [NewsItem] {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"

        return [
            NewsItem(
                title: "JCA NY Raises $340K Toward Annual Goal",
                summary: "Community generosity reaches 68% of $500K fundraising target with three months remaining.",
                body: "The Jain Center of America NY community has demonstrated remarkable generosity this year, raising $340,210 toward the annual $500,000 fundraising goal. With 1,247 unique donors contributing across temple maintenance, education, and community programs, JCA NY is on track to surpass its target before the fiscal year ends.",
                date: formatter.date(from: "2026-04-10") ?? Date(),
                category: .community,
                isFeatured: true
            ),
            NewsItem(
                title: "Acharya Vijay to Visit in May",
                summary: "Renowned spiritual leader will deliver pravachan series on Jain philosophy.",
                body: "JCA NY is honored to welcome Acharya Vijay for a special visit on May 4th. He will deliver a series of discourses on the principles of Ahimsa and their application in contemporary life.",
                date: formatter.date(from: "2026-04-08") ?? Date(),
                category: .announcements,
                isFeatured: false
            ),
            NewsItem(
                title: "Spring Newsletter — Chaitra Edition",
                summary: "Updates on temple renovation, Pathshala results, and upcoming festivals.",
                body: "Read our quarterly newsletter covering the temple renovation progress, Pathshala annual results, volunteer spotlight, and a full calendar of upcoming festivals and events.",
                date: formatter.date(from: "2026-04-01") ?? Date(),
                category: .newsletter,
                isFeatured: false
            ),
            NewsItem(
                title: "Bhojanshala Celebrates 500th Meal",
                summary: "The community kitchen marks a major milestone with its 500th Sunday meal served.",
                body: "JCA NY's Bhojanshala program celebrated a significant milestone last Sunday, serving its 500th community meal. Over 200 devotees joined in the celebration.",
                date: formatter.date(from: "2026-03-28") ?? Date(),
                category: .community,
                isFeatured: false
            )
        ]
    }

    static var liveStreams: [LiveStream] {
        [
            LiveStream(title: "Morning Aarti — Mahavir Swami", subtitle: "Main Sanctum", isLive: true, viewerCount: 847),
            LiveStream(title: "Pravachan with Muni Shri", subtitle: "Shrimad Hall", isLive: false, viewerCount: 0, scheduleTime: "7:00 PM"),
            LiveStream(title: "Adinathji Aarti", subtitle: "Adinath Shrine", isLive: false, viewerCount: 0, scheduleTime: "6:30 AM"),
            LiveStream(title: "Community Puja", subtitle: "Main Sanctum", isLive: false, viewerCount: 0, scheduleTime: "8:00 AM")
        ]
    }

    static var aartiSchedule: [AartiSchedule] {
        [
            AartiSchedule(name: "Mangala Aarti", time: "6:30 AM"),
            AartiSchedule(name: "Snaatra Puja", time: "8:00 AM"),
            AartiSchedule(name: "Chaityavandan", time: "12:00 PM", isNext: true),
            AartiSchedule(name: "Evening Aarti", time: "6:30 PM"),
            AartiSchedule(name: "Sandhya Aarti", time: "7:00 PM")
        ]
    }

    static var bhojanshalaDateOptions: [Date] {
        var cal = Calendar.current
        var dates: [Date] = []
        var date = Date()
        for _ in 0..<6 {
            let weekday = cal.component(.weekday, from: date)
            let daysUntilSunday = (8 - weekday) % 7
            date = cal.date(byAdding: .day, value: daysUntilSunday == 0 ? 7 : daysUntilSunday, to: date) ?? date
            dates.append(date)
        }
        return dates
    }

    // MARK: - Community Feed

    static var communityPosts: [CommunityPost] {
        func date(daysAgo: Int) -> Date {
            Calendar.current.date(byAdding: .day, value: -daysAgo, to: Date()) ?? Date()
        }
        return [
            CommunityPost(
                authorInitials: "JC",
                authorName: "JCA New York",
                kind: .admin,
                body: "Reminder: Paryushan Parva begins Saturday, August 16. All programs and schedules are posted on the Calendar tab. The temple will have extended hours throughout the festival. Jai Jinendra 🙏",
                reactions: .init(lotus: 142, namaste: 88, comments: 14),
                createdAt: date(daysAgo: 0),
                status: .approved,
                isPinned: true
            ),
            CommunityPost(
                authorInitials: "PS",
                authorName: "Priya Shah",
                kind: .member,
                body: "Beautiful Snatra Puja ceremony this morning — so grateful to be part of this sangha. Anumodana to all who participated and to the sevaks who organized everything 🪷",
                reactions: .init(lotus: 67, namaste: 31, comments: 8),
                createdAt: date(daysAgo: 0),
                status: .approved,
                isPinned: false
            ),
            CommunityPost(
                authorInitials: "JC",
                authorName: "JCA New York",
                kind: .admin,
                body: "📸 New photos from last Sunday's Mahavir Janma Kalyanak celebration are now available in the Gallery. Thank you to everyone who joined us for this joyous occasion!",
                reactions: .init(lotus: 203, namaste: 112, comments: 24),
                createdAt: date(daysAgo: 2),
                status: .approved,
                isPinned: false
            ),
            CommunityPost(
                authorInitials: "RJ",
                authorName: "Rahul Jain",
                kind: .youth,
                body: "Just completed my Pathshala advanced level certification! So proud of our entire class. Shoutout to all our amazing teachers who made this possible 🙏",
                reactions: .init(lotus: 89, namaste: 45, comments: 17),
                createdAt: date(daysAgo: 3),
                status: .approved,
                isPinned: false
            ),
            CommunityPost(
                authorInitials: "AM",
                authorName: "Alpa Mehta",
                kind: .member,
                body: "Wonderful lecture by Muni Shri last evening. His words on Aparigraha and modern life truly resonated. Looking forward to tomorrow's session!",
                reactions: .init(lotus: 54, namaste: 29, comments: 6),
                createdAt: date(daysAgo: 4),
                status: .approved,
                isPinned: false
            ),
        ]
    }

    // MARK: - Subscriptions

    static var subscriptions: [Subscription] {
        func date(year: Int, month: Int, day: Int) -> Date {
            var c = DateComponents(); c.year = year; c.month = month; c.day = day
            return Calendar.current.date(from: c) ?? Date()
        }
        return [
            Subscription(
                causeName: "Daily Aarti Seva",
                causeIcon: "bell.fill",
                frequency: .daily,
                amount: 11,
                startDate: date(year: 2025, month: 9, day: 1),
                nextChargeDate: date(year: 2026, month: 5, day: 3),
                lifetimeTotal: 2783,
                status: .active
            ),
            Subscription(
                causeName: "Bhojanshala Family Seva",
                causeIcon: "fork.knife",
                frequency: .monthly,
                amount: 108,
                startDate: date(year: 2024, month: 3, day: 15),
                nextChargeDate: date(year: 2026, month: 5, day: 15),
                lifetimeTotal: 2916,
                status: .active
            ),
        ]
    }

    // MARK: - Sponsors of the Month

    static var sponsorsOfMonth: [MonthSponsor] {
        func date(year: Int, month: Int, day: Int) -> Date {
            var c = DateComponents(); c.year = year; c.month = month; c.day = day
            return Calendar.current.date(from: c) ?? Date()
        }
        return [
            MonthSponsor(
                memberInitials: "RS",
                memberName: "Ramesh & Sunita Shah",
                cause: "Bhojanshala",
                amount: 1251,
                date: date(year: 2026, month: 4, day: 27),
                memorialText: "In loving memory of Late Shri Kantilal Shah"
            ),
            MonthSponsor(
                memberInitials: "PJ",
                memberName: "Priya & Nitin Jain",
                cause: "Bhojanshala",
                amount: 351,
                date: date(year: 2026, month: 4, day: 20),
                memorialText: nil
            ),
            MonthSponsor(
                memberInitials: "AM",
                memberName: "Alpa Mehta",
                cause: "General Fund",
                amount: 501,
                date: date(year: 2026, month: 4, day: 18),
                memorialText: "In honor of Alpa's 50th birthday"
            ),
            MonthSponsor(
                memberInitials: "DG",
                memberName: "Deepak & Kavita Gala",
                cause: "Bhojanshala",
                amount: 1251,
                date: date(year: 2026, month: 4, day: 13),
                memorialText: nil
            ),
            MonthSponsor(
                memberInitials: "SV",
                memberName: "Suresh Vora Family",
                cause: "Temple Fund",
                amount: 251,
                date: date(year: 2026, month: 4, day: 6),
                memorialText: "Anumodana on Mahavir Jayanti"
            ),
        ]
    }

    // MARK: - Jinvani Library

    static var books: [Book] {
        [
            Book(id: "tattvartha", title: "Tattvārtha Sūtra", author: "Umāsvāti", category: .agamSutras,
                 format: .pdf, language: "Sanskrit / English", totalPages: 312,
                 gradientColors: ["#B45309", "#D97706"]),
            Book(id: "acaranga", title: "Ācārānga Sūtra", author: "Sudharmasvāmī", category: .agamSutras,
                 format: .pdf, language: "Prakrit / English", totalPages: 248,
                 gradientColors: ["#0F766E", "#14B8A6"]),
            Book(id: "kalpa", title: "Kalpa Sūtra", author: "Bhadrabāhu", category: .agamSutras,
                 format: .illustrated, language: "Prakrit / English", totalPages: 180,
                 gradientColors: ["#B91C1C", "#DC2626"]),
            Book(id: "jain-phil", title: "Jain Philosophy & Religion", author: "Muni Mahendra Kumar", category: .commentaries,
                 format: .pdf, language: "English", totalPages: 420,
                 gradientColors: ["#4338CA", "#6366F1"]),
            Book(id: "anekanta", title: "Anekānta: The Third Eye", author: "Osho", category: .commentaries,
                 format: .pdf, language: "English", totalPages: 156,
                 gradientColors: ["#6D28D9", "#7C3AED"]),
            Book(id: "jain-stories", title: "Stories of the Tīrthankaras", author: "JCA Education Board", category: .children,
                 format: .illustrated, language: "English", totalPages: 96,
                 gradientColors: ["#0369A1", "#0EA5E9"]),
            Book(id: "little-jain", title: "Little Jain's ABC of Ahimsā", author: "Smita Mehta", category: .children,
                 format: .illustrated, language: "English", totalPages: 64,
                 gradientColors: ["#047857", "#10B981"]),
        ]
    }

    // MARK: - Business Directory

    static var businesses: [Business] {
        [
            Business(name: "Shah Diamonds & Jewelry", category: .jewelry, location: "Midtown Manhattan, NY",
                     phone: "+12125550101", website: "https://example.com", rating: 4.8, hasSanghaDiscount: true, hasMemberRate: false),
            Business(name: "Jain Legal Group", category: .legal, location: "Downtown Brooklyn, NY",
                     phone: "+17185550102", website: "https://example.com", rating: 4.6, hasSanghaDiscount: false, hasMemberRate: true),
            Business(name: "Ahimsa Family Medicine", category: .medical, location: "Jackson Heights, NY",
                     phone: "+17185550103", website: "https://example.com", rating: 4.9, hasSanghaDiscount: true, hasMemberRate: false),
            Business(name: "Mehta Financial Services", category: .finance, location: "Flushing, NY",
                     phone: "+17185550104", website: nil, rating: 4.5, hasSanghaDiscount: false, hasMemberRate: true),
            Business(name: "Pure Bhojan Kitchen", category: .food, location: "Elmhurst, NY",
                     phone: "+17185550105", website: "https://example.com", rating: 4.7, hasSanghaDiscount: true, hasMemberRate: false),
            Business(name: "Gala Hospitality Group", category: .hospitality, location: "Woodside, NY",
                     phone: "+17185550106", website: "https://example.com", rating: 4.4, hasSanghaDiscount: false, hasMemberRate: false),
        ]
    }

    // MARK: - Facilities

    static var facilities: [Facility] {
        [
            Facility(name: "Main Hall", capacity: 450, memberRate: 2508, publicRate: 4180,
                     description: "Grand hall with full A/V, stage, and pure-veg catering kitchen", iconName: "building.2.fill"),
            Facility(name: "Upashray Hall", capacity: 120, memberRate: 751, publicRate: 1251,
                     description: "Intimate hall ideal for satsangs, bhajans, and small celebrations", iconName: "person.3.fill"),
            Facility(name: "Marble Lobby", capacity: 80, memberRate: 351, publicRate: 585,
                     description: "Elegant lobby with marble floors for receptions and exhibitions", iconName: "sparkles"),
        ]
    }

    // MARK: - Jain Centers USA

    static var jainCenters: [JainCenter] {
        [
            JainCenter(name: "Jain Center of America (NY)", address: "43-11 Ithaca St",
                       city: "Elmhurst", state: "NY", latitude: 40.7380, longitude: -73.8826,
                       hours: "Mon–Fri 5–9 PM · Sat–Sun 8 AM–9 PM"),
            JainCenter(name: "Jain Center of Greater Boston", address: "171 Old Harvard Rd",
                       city: "Boxborough", state: "MA", latitude: 42.4868, longitude: -71.5236,
                       hours: "Sat–Sun 9 AM–8 PM"),
            JainCenter(name: "Jain Society of Metropolitan Chicago", address: "435 N Route 53",
                       city: "Bartlett", state: "IL", latitude: 41.9883, longitude: -88.1851,
                       hours: "Fri–Sun 9 AM–9 PM"),
            JainCenter(name: "Jain Center of Southern California", address: "8072 Commonwealth Ave",
                       city: "Buena Park", state: "CA", latitude: 33.8676, longitude: -117.9718,
                       hours: "Daily 9 AM–8 PM"),
            JainCenter(name: "Jain Society of Houston", address: "1700 W Sam Houston Pkwy S",
                       city: "Houston", state: "TX", latitude: 29.7441, longitude: -95.5582,
                       hours: "Sat–Sun 9 AM–7 PM"),
        ]
    }

    static var vegRestaurants: [VegRestaurant] {
        [
            VegRestaurant(name: "Desi Village", address: "74-10 37th Ave", city: "Jackson Heights, NY",
                          kind: .pureVeg, rating: 4.6, latitude: 40.7453, longitude: -73.8907),
            VegRestaurant(name: "Bhojan Pure Veg", address: "45-63 Kissena Blvd", city: "Flushing, NY",
                          kind: .pureVeg, rating: 4.8, latitude: 40.7571, longitude: -73.8304),
            VegRestaurant(name: "Saraswati Bhavan", address: "76-01 Roosevelt Ave", city: "Jackson Heights, NY",
                          kind: .jainFriendly, rating: 4.4, latitude: 40.7459, longitude: -73.8901),
            VegRestaurant(name: "Annapurna Indian Cuisine", address: "87-10 Parsons Blvd", city: "Jamaica, NY",
                          kind: .jainFriendly, rating: 4.3, latitude: 40.7099, longitude: -73.7977),
        ]
    }
}
