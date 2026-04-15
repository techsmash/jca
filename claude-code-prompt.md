# Build: JCA NY — iOS App (SwiftUI)

## Mission

Build a complete, production-quality SwiftUI iOS application for the **Jain Center of America (JCA NY)** community. A fully-designed HTML/CSS mockup is attached as `jca-ny-app.html` — **treat it as the visual and functional source of truth**. Every screen, color, typographic choice, spacing decision, and interaction pattern in the HTML must be faithfully translated into native SwiftUI. Do not invent alternative designs.

The app is a companion for JCA NY members covering darshan, donations, events, Pathshala (religious education), Bhojanshala (community meal) sponsorship, a virtual tour of the five shrines, and member profile management.

---

## Input Materials

1. **`jca-ny-app.html`** — 13 fully-designed phone screens organized into 4 sections. Open this file in a browser first and study every screen before writing any Swift. Every pixel is intentional.
2. **This prompt** — architectural and implementation guidance.

---

## Tech Stack (non-negotiable)

- **Language:** Swift 5.9+
- **UI Framework:** SwiftUI (no UIKit unless absolutely required for a specific capability)
- **Minimum target:** iOS 17.0
- **Architecture:** MVVM with `@Observable` macro (iOS 17 Observation framework), not the older `ObservableObject` pattern
- **Navigation:** `NavigationStack` + `TabView`
- **Persistence:** SwiftData for local storage of user profile, family members, donation history, saved payment methods
- **Async:** Swift Concurrency (`async/await`), no Combine unless necessary
- **Dependencies:** Zero third-party packages. Everything stdlib + SwiftUI + SwiftData. No SnapKit, no Alamofire, no SDWebImage.
- **Fonts:** Bundle **Fraunces** (variable) and **Inter** as custom fonts in the app. Register them in `Info.plist` under `UIAppFonts`. The HTML uses Google Fonts links; in the Swift app, download the TTFs and add them to the project. Use `.custom("Fraunces-Regular", size:)` style APIs, or define a `Font` extension.
- **No storyboards. No XIBs. SwiftUI only.**

---

## Design System — Extract From HTML

Create a `DesignSystem/` folder with these files. Pull exact values from the HTML's `:root` CSS variables.

### `Colors.swift`
```swift
extension Color {
    static let jcaCrimson      = Color(hex: "#a8202c")
    static let jcaCrimsonDeep  = Color(hex: "#7a1620")
    static let jcaCrimsonSoft  = Color(hex: "#c84252")
    static let jcaGold         = Color(hex: "#c9a961")
    static let jcaGoldLight    = Color(hex: "#e3c889")
    static let jcaGoldDeep     = Color(hex: "#8c6f30")
    static let jcaCream        = Color(hex: "#faf6ef")
    static let jcaCreamWarm    = Color(hex: "#f4ecdd")
    static let jcaPaper        = Color.white
    static let jcaInk          = Color(hex: "#1c1410")
    static let jcaInkSoft      = Color(hex: "#4a3d35")
    static let jcaMuted        = Color(hex: "#8a7864")
}
```
Include a `Color(hex:)` initializer.

### `Typography.swift`
Define a `JCAFont` enum or extension with:
- `displayLarge`  — Fraunces, 28–38pt, weight 500, for big serif headers
- `displayItalic` — Fraunces italic, used for the "em" accents in the HTML
- `headline`      — Fraunces, 17–22pt, weight 600
- `title`         — Fraunces, 15–17pt, weight 600
- `body`          — Inter, 13–15pt, weight 400–500
- `caption`       — Inter, 10–12pt, weight 500
- `label`         — Inter, 9–11pt, weight 600, uppercase, tracked (letter-spacing)

Match the HTML: Fraunces for all serif headers, Inter for all UI text.

### `Spacing.swift` / `Radii.swift`
Pull the common values: radii of 12, 14, 16, 18, 24; spacing of 8, 10, 12, 14, 16, 18, 20, 24.

### `Shadows.swift`
Two reusable shadows matching the CSS `--shadow-sm` and `--shadow-md`.

### `Ornaments/`
Reusable SwiftUI views for the recurring decorative elements:
- `JainSwastikaView` — draw the swastika from the splash screen (Path + Shape). Four arms with three dots above. Use `Canvas` or composed `Path` shapes.
- `MandalaBackgroundView` — concentric circles + diagonal lines matching the splash mandala SVG, with optional rotation animation.
- `OrnamentDivider` — the "line · diamond · line" divider from the page header.
- `DeityGlowView` — the stylized tirthankar silhouette glow used in Live Darshan and News feature cards.

---

## Architecture

```
JCANY/
├── App/
│   ├── JCANYApp.swift                    (@main)
│   └── RootView.swift                    (decides Splash vs MainTabView based on auth)
├── DesignSystem/
│   ├── Colors.swift
│   ├── Typography.swift
│   ├── Spacing.swift
│   ├── Radii.swift
│   ├── Shadows.swift
│   └── Ornaments/
│       ├── JainSwastikaView.swift
│       ├── MandalaBackgroundView.swift
│       ├── OrnamentDivider.swift
│       └── DeityGlowView.swift
├── Models/
│   ├── User.swift                        (@Model — SwiftData)
│   ├── FamilyMember.swift                (@Model — includes dateOfBirth)
│   ├── Event.swift
│   ├── DonationCategory.swift
│   ├── Donation.swift                    (@Model — history)
│   ├── PaymentMethod.swift               (@Model — saved cards, enum for type)
│   ├── Shrine.swift
│   ├── LiveStream.swift
│   ├── ParvaDay.swift
│   ├── VolunteerOpportunity.swift
│   ├── PathshalaLesson.swift
│   └── NewsItem.swift
├── Services/
│   ├── MockDataProvider.swift            (seeds everything — see below)
│   ├── AuthService.swift                 (mocked sign-in; store session in SwiftData)
│   ├── DonationService.swift             (mocked payment processing w/ artificial delay)
│   └── PanchangService.swift             (computes today's tithi / sunrise / sunset — can be static data)
├── ViewModels/
│   ├── HomeViewModel.swift
│   ├── DonationFlowViewModel.swift       (shared across donate → bhojanshala → payment)
│   ├── CalendarViewModel.swift
│   ├── DarshanViewModel.swift
│   ├── ProfileViewModel.swift
│   └── ...                               (one per screen that needs state)
├── Views/
│   ├── Splash/
│   │   └── SplashView.swift
│   ├── Auth/
│   │   └── SignInView.swift
│   ├── Home/
│   │   ├── HomeView.swift
│   │   ├── Components/
│   │   │   ├── PanchangCard.swift
│   │   │   ├── QuickActionCard.swift
│   │   │   └── EventCard.swift
│   ├── Darshan/
│   │   ├── LiveDarshanView.swift
│   │   ├── FeaturedStreamView.swift
│   │   └── StreamTile.swift
│   ├── Calendar/
│   │   ├── CalendarView.swift
│   │   ├── MonthGridView.swift
│   │   └── ParvaCard.swift
│   ├── VirtualTour/
│   │   └── VirtualTourView.swift
│   ├── Donate/
│   │   ├── DonateView.swift              (cause selection + goal progress)
│   │   ├── BhojanshalaView.swift         (meal type + date picker)
│   │   ├── PaymentView.swift             (method selection + card form)
│   │   └── Components/
│   │       ├── CauseCard.swift
│   │       ├── MealTypeCard.swift
│   │       ├── PaymentMethodCard.swift
│   │       ├── CreditCardPreview.swift   (animated, updates as user types)
│   │       └── IOSFormField.swift
│   ├── Events/
│   │   ├── EventDetailView.swift
│   │   └── RSVPBar.swift
│   ├── Pathshala/
│   │   ├── PathshalaView.swift
│   │   ├── LevelTabs.swift
│   │   └── LessonCard.swift
│   ├── News/
│   │   ├── NewsListView.swift
│   │   └── NewsDetailView.swift
│   ├── Volunteer/
│   │   └── VolunteerView.swift
│   ├── Profile/
│   │   ├── ProfileView.swift
│   │   ├── FamilyMemberRow.swift
│   │   ├── AddEditFamilyMemberSheet.swift  (DatePicker for DOB)
│   │   └── SettingsRow.swift
│   └── Shared/
│       ├── MainTabView.swift
│       ├── NavigationBackButton.swift
│       ├── PrimaryButton.swift           (.jcaCrimson filled, 14pt radius)
│       ├── GhostButton.swift
│       └── SectionHeader.swift
└── Resources/
    ├── Fonts/
    │   ├── Fraunces-VariableFont.ttf
    │   ├── Inter-VariableFont.ttf
    │   └── ...
    └── Assets.xcassets/
        ├── AppIcon.appiconset/
        └── Colors/                       (mirror of DesignSystem Colors)
```

---

## Screen Inventory

All 13 screens from the HTML must be built. Cross-reference the HTML label of each screen with the Swift view.

| # | HTML Label             | Swift View              | Tab / Stack Parent        |
|---|------------------------|-------------------------|---------------------------|
| 1 | Welcome (Splash)       | `SplashView`            | Root (pre-auth)           |
| 2 | Sign In                | `SignInView`            | Root (pre-auth)           |
| 3 | Home Dashboard         | `HomeView`              | Tab: Home                 |
| 4 | Live Darshan           | `LiveDarshanView`       | Tab: Home (pushed) or FAB |
| 5 | Jain Calendar          | `CalendarView`          | Tab: Calendar             |
| 6 | Virtual Tour           | `VirtualTourView`       | Tab: Home (pushed)        |
| 7 | Donations              | `DonateView`            | Tab: Donate               |
| 8 | Sponsor Bhojanshala    | `BhojanshalaView`       | Pushed from DonateView    |
| 9 | Payment                | `PaymentView`           | Pushed from Bhojanshala / DonateView |
| 10 | Volunteer & Seva      | `VolunteerView`         | Tab: Community            |
| 11 | Event Detail          | `EventDetailView`       | Pushed from HomeView      |
| 12 | Pathshala             | `PathshalaView`         | Tab: Community            |
| 13 | News & Newsletters    | `NewsListView`          | Tab: Community            |
| —  | Member Profile        | `ProfileView`           | Tab: Profile              |

### Tab Bar Structure
Five tabs, exact order and labels from the HTML tab bar:
1. **Home** — house icon → `HomeView`
2. **Calendar** — calendar icon → `CalendarView`
3. **Donate** — heart icon → `DonateView`
4. **Community** — message-square icon → hub with Pathshala / Volunteer / News (use an inner segmented control or navigation list)
5. **Profile** — user icon → `ProfileView`

Use SF Symbols that match the HTML's stroked icons: `house`, `calendar`, `heart`, `bubble.left`, `person`.

---

## Data Models

### `User`
```swift
@Model
final class User {
    var id: UUID
    var name: String
    var email: String
    var memberID: String              // "04812"
    var memberTier: String            // "Life Member"
    var avatarInitial: String
    var totalDonated: Decimal
    var sevaHours: Int
    @Relationship(deleteRule: .cascade) var familyMembers: [FamilyMember]
    @Relationship(deleteRule: .cascade) var savedPaymentMethods: [PaymentMethod]
    @Relationship(deleteRule: .cascade) var donationHistory: [Donation]
}
```

### `FamilyMember` — **must include DOB**
```swift
@Model
final class FamilyMember {
    var id: UUID
    var name: String
    var relation: String              // "Father", "Mother", "Sister", "Spouse", etc.
    var dateOfBirth: Date             // REQUIRED
    var nakshatra: String?
    var gotra: String?
    var avatarInitial: String
}
```

### `PaymentMethod`
```swift
@Model
final class PaymentMethod {
    var id: UUID
    var type: PaymentType             // enum: creditCard, debitCard, applePay, googlePay, payPal, zelle, ach
    var last4: String?
    var brand: String?                // "Visa", "Mastercard", "Amex", "Discover"
    var expiryMonth: Int?
    var expiryYear: Int?
    var cardholderName: String?
    var isDefault: Bool
}

enum PaymentType: String, Codable, CaseIterable {
    case creditCard, debitCard, applePay, googlePay, payPal, zelle, ach
}
```

### `Donation`
```swift
@Model
final class Donation {
    var id: UUID
    var amount: Decimal
    var cause: String                 // "Temple Maintenance", "Sponsor Bhojanshala", etc.
    var date: Date
    var paymentMethodLast4: String?
    var transactionID: String
    var isRecurring: Bool
}
```

Define supporting value types (structs, not @Model) for content that doesn't need persistence: `Event`, `Shrine`, `LiveStream`, `ParvaDay`, `NewsItem`, `VolunteerOpportunity`, `PathshalaLesson`.

---

## Mock Data

Create `MockDataProvider.swift` with realistic seed data mirroring the HTML exactly:

- **User:** Manan Shah, Member ID 04812, Life Member, $2,851 donated, 142 seva hours
- **Family members (with DOBs):**
  - Rajesh Shah — Father — DOB 12 Aug 1968
  - Sunita Shah — Mother — DOB 04 Mar 1972
  - Priya Shah — Sister — DOB 21 Nov 2001
- **Saved payment method:** Visa ending 8891, expires 08/28, Manan Shah
- **Events:** Mahavir Janma Kalyanak (Apr 26), Pathshala Spring Term (Apr 19), Lecture by Acharya Vijay (May 4)
- **Parva days:** Mahavir Janma Kalyanak, Ayambil Oli, Akshay Tritiya (use exact dates from HTML)
- **Shrines:** Mahavir Swami, Adinathji, Upashray, Shrimad Rajchandra Hall, Dadawadi, Ashtapad & Art Gallery
- **Donation causes:** Temple Maintenance, Sponsor Bhojanshala, Pathshala Education, Matching Gifts, General Fund
- **Annual goal:** $500,000 target, $340,210 raised (68%), 1,247 donors
- **Volunteer opportunities:** Bhojanshala Helper (urgent), Pathshala Teacher's Aide, MJK Event, Senior Group drive
- **Pathshala lesson:** "The 5 Mahavratas Explained" — Lesson 7 of 12, 60% complete
- **Panchang for today:** Chaitra Sud 8, sunrise 6:18 AM, sunset 7:42 PM, pratikraman 7:00 PM

Seed on first launch using SwiftData's `modelContext`.

---

## Critical Implementation Details

### Splash Screen (Screen 1)
- Full crimson radial gradient background
- Rotating mandala at 50% opacity behind content (use `.rotationEffect` animated with `.linear(duration: 90).repeatForever(autoreverses: false)`)
- Jain swastika drawn via `Shape`/`Path` — **do not use an image**. Four right-angle arms plus three dots above.
- Full Navkar Mantra displayed in italic Fraunces, with thin gold horizontal rules above and below
- "Sign In" (cream pill) and "Continue as Guest" (ghost) buttons pinned to bottom

### Sign In Screen (Screen 2)
- iOS-style elevated input fields (white background, subtle shadow, label above input)
- "Apple" and "Google" side-by-side social buttons
- Back chevron navigation

### Home Dashboard (Screen 3)
- Faint mandala SVG pattern top-right of the hero area (subtle — 6% opacity)
- `PanchangCard` with the crimson-to-gold vertical gradient accent bar on the left edge
- Horizontal `ScrollView` of `QuickActionCard`s — snap-to behavior is nice-to-have
- Event cards with a date block (month abbrev + day number) in a subtle crimson-tinted container

### Live Darshan (Screen 4)
- Dark charcoal background (`#08040a`)
- Featured stream card with the radial crimson-gold gradient and a `DeityGlowView` centered
- Pulsing red "LIVE" dot — use `.opacity` animation with `.easeInOut.repeatForever`
- 2-column grid of smaller stream tiles
- Today's aarti schedule in a gold-tinted bordered section

### Calendar (Screen 5)
- 7-column `LazyVGrid` for the month view
- Parva days shown in crimson with a small gold dot underneath
- Today highlighted with a filled crimson circle
- Countdown cards ("12 days") for upcoming parvas — `Calendar.current.dateComponents([.day], from: ...)`

### Virtual Tour (Screen 6)
- Dark background
- Featured shrine card with the stylized arches drawn via overlapping rounded rectangles (matching the HTML's `::before`/`::after` arches)
- Numbered list of shrines (i, ii, iii, iv, v in Fraunces italic)

### Donate (Screen 7)
- Progress stats card with the crimson gradient + decorative gold circle overlay (use `.overlay` with `Circle().stroke()`)
- Animated progress bar — fill width animates on appear
- Cause cards — tapping any pushes to Bhojanshala flow (for bhojanshala cause) or directly to `PaymentView` with that cause pre-selected

### Bhojanshala (Screen 8)
- Cream/gold gradient hero card
- 2x2 grid of meal types with selection state (crimson border when selected)
- Horizontal scroll of date pills for upcoming Sundays
- "Continue to Payment · $1,251" CTA → pushes `PaymentView`

### Payment (Screen 9) — **critical**
- **Amount summary card** at top with selected cause name and total
- **Payment method grid** — 2 columns, 6 options:
  1. Credit / Debit — Visa logo (blue gradient)
  2. Apple Pay — black pill with  glyph
  3. Google Pay — multi-color G
  4. PayPal — blue gradient "P"
  5. Zelle — purple gradient "Z"
  6. Bank Transfer / ACH — slate gradient
- Selected method shows a crimson border + small checkmark badge top-right
- **Live credit card preview** — a realistic card with chip, masked number, cardholder name, expiry. Must update reactively as user types in the form below (use `@State` bindings). The card has the JCA crimson-to-black gradient, gold chip, and gold "JCA" brand mark.
- **Form fields** below: Card Number (format as `•••• •••• •••• ••••` with spaces), Expiry (MM/YY auto-format), CVV (secure, 3 digits), Cardholder Name, Billing ZIP
- Number formatting must be smart: as user types card number, insert spaces every 4 digits; expiry auto-inserts `/` after month
- **"Save card for future donations" Toggle** — use native iOS `Toggle` with `.tint(.jcaCrimson)`
- **"Pay $X" primary button** with a lock icon
- Tapping Pay: show a loading state, simulate 2-second network delay, then push a **Payment Success** view (checkmark animation, transaction ID, "Download Receipt" button, "Done" button back to home). Persist the donation to SwiftData.
- Use **Apple Pay** correctly: if user taps the Apple Pay method, the flow should invoke `PKPaymentAuthorizationController` stub (or just simulate it with a sheet — OK for mock)

### Profile (Screen — final)
- Crimson gradient header with decorative gold circles
- Gold avatar circle with user's initial
- Three stat columns: Donated / Seva Hours / Family
- **Family Members section** — list with:
  - Avatar circle (initial)
  - Name (Inter 14pt semibold)
  - Relation + DOB (Inter 10pt uppercase, format: "Father · DOB 12 Aug 1968")
  - Chevron to the right
- **"+ Add" button** in the section header → opens `AddEditFamilyMemberSheet` as a sheet
- Add/Edit sheet has a `DatePicker` for DOB with `.datePickerStyle(.wheel)` or `.graphical`, plus text fields for name, relation picker, optional nakshatra/gotra
- Tapping an existing row opens the same sheet in edit mode
- Account list below: Donation Receipts, Payment Methods (navigates to a list showing saved cards), Notifications, Help & Support
- **Payment Methods** screen lets the user view, add, and remove saved cards — reuses `PaymentMethodCard` components

---

## Navigation Flow

```
SplashView
  └─> SignInView
        └─> MainTabView
              ├─ HomeView
              │    ├─> LiveDarshanView
              │    ├─> VirtualTourView
              │    ├─> EventDetailView
              │    └─> NewsListView
              ├─ CalendarView
              │    └─> EventDetailView
              ├─ DonateView
              │    ├─> BhojanshalaView ─> PaymentView ─> PaymentSuccessView
              │    └─> PaymentView (direct for non-bhojanshala causes) ─> PaymentSuccessView
              ├─ CommunityHubView
              │    ├─> PathshalaView
              │    ├─> VolunteerView
              │    └─> NewsListView ─> NewsDetailView
              └─ ProfileView
                   ├─> AddEditFamilyMemberSheet (sheet)
                   ├─> PaymentMethodsView
                   ├─> DonationHistoryView
                   └─> SettingsView
```

Use one `NavigationStack` per tab. The donation flow uses a `NavigationPath` tracked in `DonationFlowViewModel` so "Done" on success can pop back to root.

---

## Specific Polish Requirements

1. **Haptics:** Add `UIImpactFeedbackGenerator(style: .light).impactOccurred()` on primary button taps, tab changes, and selection changes (meal type, payment method).
2. **Loading states:** Payment submission shows a `ProgressView` inside the button and disables further taps.
3. **Accessibility:** Every interactive element gets an `accessibilityLabel`. Respect Dynamic Type for body text (use `.dynamicTypeSize(...DynamicTypeSize.xxLarge)` as a ceiling to prevent layout breakage).
4. **Dark mode:** Not required for v1 — the design is intentionally light with cream backgrounds. Lock to light mode via `.preferredColorScheme(.light)` at the root.
5. **Safe areas:** Respect top and bottom safe areas. The tab bar and dark screens (Live Darshan, Virtual Tour) should extend under the status bar with correct `.ignoresSafeArea(.container, edges: .top)` but leave content padded.
6. **Status bar:** Dark screens use `.statusBarHidden(false)` with light content; light screens use dark content. Use `.toolbarColorScheme(.dark, for: .navigationBar)` on dark screens.
7. **Animations:**
   - Mandala rotation on splash (90s loop)
   - LIVE dot pulse
   - Progress bar fill on appear (`.animation(.easeOut(duration: 1.2), value: progress)`)
   - Tab transitions
   - Card selection (spring animation on border color change)
   - Success screen checkmark draw-in animation
8. **Keyboard handling:** Payment form auto-scrolls to the active field. Dismiss keyboard on tap outside.
9. **Currency formatting:** Use `Decimal` + `NumberFormatter` with `.currency` style and USD locale. Never use `Double` for money.
10. **Date formatting:** Use `Date.FormatStyle` APIs — e.g. `date.formatted(.dateTime.day().month(.abbreviated).year())`.

---

## Acceptance Criteria

The app is considered complete when:

- [ ] All 13 screens from the HTML are implemented and visually match within reasonable tolerance (colors, fonts, spacing, ornaments)
- [ ] Custom fonts (Fraunces + Inter) load correctly on device and simulator
- [ ] App launches to Splash, Sign In works (any credentials accepted for mock), lands on Home
- [ ] All five tabs navigate correctly; back buttons work; no dead ends
- [ ] User can browse donation causes → Bhojanshala → Payment → Success, and the donation appears in their history and profile stats update
- [ ] User can tap a family member to edit, tap "+ Add" to create a new one with a DOB picker, and changes persist via SwiftData across app restarts
- [ ] User can add/remove saved payment methods in Profile
- [ ] Live Darshan shows the pulsing LIVE dot and featured stream; stream grid displays correctly
- [ ] Calendar shows parva days marked and tappable, countdown cards update relative to current date
- [ ] Payment form validates card number length, expiry, CVV; disables Pay button if invalid
- [ ] Live card preview on Payment screen updates as user types
- [ ] No crashes, no `fatalError`, no force-unwraps of optionals in production paths
- [ ] Zero compiler warnings
- [ ] Builds and runs on iOS 17 simulator (iPhone 15 Pro)

---

## Workflow

1. **First, open `jca-ny-app.html` in a browser and scroll through every screen.** Study it. Take notes on the exact visual patterns before writing any code.
2. Create the Xcode project: `JCANY`, SwiftUI app, iOS 17, SwiftData enabled.
3. Set up the folder structure exactly as specified above.
4. Build the design system first (Colors, Typography, reusable Ornament views). Verify fonts render.
5. Build models and `MockDataProvider`. Seed SwiftData on first launch.
6. Build screens in this order, testing each before moving on:
   - Splash → Sign In → Home → Profile (to prove the design system works across dark and light screens and the persistence layer works)
   - Then: Calendar → Donate → Bhojanshala → Payment → Payment Success (the critical donation flow)
   - Then: Live Darshan → Virtual Tour → Event Detail
   - Then: Pathshala → Volunteer → News (Community tab)
7. Wire navigation and the tab bar last.
8. Polish pass: haptics, animations, accessibility labels, keyboard handling.
9. Build for iPhone 15 Pro simulator. Verify visual fidelity against the HTML side-by-side.

---

## What NOT to Do

- Do not redesign. The HTML is final.
- Do not substitute system fonts for Fraunces/Inter "temporarily." Bundle the real fonts from the start.
- Do not use emoji as icons in final UI — replace the HTML's placeholder emoji with SF Symbols or custom `Shape`s. The swastika, mandala, and deity glow must be drawn, not imaged.
- Do not add features not in the HTML (no chat, no forums, no AI assistant — unless the HTML shows it).
- Do not use `UIViewRepresentable` wrappers for things SwiftUI already handles natively.
- Do not hardcode strings in views — put all user-facing strings in a `Localizable.strings` file from the start so Gujarati/Hindi can be added later.
- Do not commit placeholder `// TODO` comments in acceptance-critical paths.

---

## Deliverable

A complete, buildable Xcode project with all files in the structure above. Every screen from the HTML implemented natively. Mock data seeded. Navigation working end-to-end. Donation flow fully functional through the mock payment success state. Family member management with DOB picker fully working and persisting across launches.

When finished, provide a brief `README.md` with: how to build, where custom fonts need to be added if the assistant couldn't bundle them directly, any TODOs for a real backend integration (marked clearly as "Backend integration points"), and a screen-by-screen checklist of what was implemented.

Begin by viewing `jca-ny-app.html` in full before writing any Swift.
