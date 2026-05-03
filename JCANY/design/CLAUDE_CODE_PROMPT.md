# Claude Code Prompt — JCA NY iOS App Redesign

You are working on an **existing native iOS (SwiftUI) app** for the **Jain Center of America** (JCA), a real Jain temple at 43-11 Ithaca Street, Elmhurst, Queens NY 11373. The app already builds and runs — your job is to **migrate it from the previous design to the new design** described in the attached HTML mockup, **without rewriting the app from scratch**.

---

## Step 0 — Discovery (do this first, before writing any code)

Before generating any changes:

1. **Read the entire codebase.** Run `find . -name "*.swift" | head -100` and `ls`/`tree` the project root. Identify:
   - Project structure (App/, Features/, Views/, ViewModels/, Models/, Services/, DesignSystem/, Resources/, etc.)
   - The current root tab bar — file name, how tabs are declared, what tabs exist today
   - The DI / state pattern in use (plain `@StateObject`, TCA, Observation framework, Redux-style, etc.)
   - The networking layer (URLSession wrapper? a generated API client? mocks?)
   - The persistence layer (Core Data, SwiftData, UserDefaults, Keychain, none)
   - Existing design tokens — is there already a `Colors.swift`, `Typography.swift`, `Theme.swift`?
   - Asset catalog — what images, icons, custom SF Symbols already exist
   - Localization setup (Localizable.strings, .xcstrings, no localization yet)
   - Test setup (XCTest, Swift Testing, snapshot tests, none)

2. **Read `jca-ny-app.html`** (the design source of truth). It contains 28 phone mockups in 5 sections plus the design system as CSS variables. Note:
   - The 5 bottom-nav tabs: **Home · Calendar · Donate · Community · Profile/More**
   - The complete color palette in `:root` CSS vars (crimson `#a8202c`, gold `#c9a961`, cream `#faf6ef`, ink `#1c1410`, etc.)
   - Typography pairing: **Fraunces** (variable serif, italic for accent, used for sacred/display + numbers) + **Inter** (UI/body)
   - iOS conventions already simulated in the mockup: Dynamic Island, status bar, blurred tab bar with `backdrop-filter`, spring-feel transitions
   - Real Jain terminology — `tithi`, `parva`, `aarti`, `swamivatsalya`, `anumodana`, `dāna`, `pratikraman`, `Mahavratas`, `Jinvani`, `Pathshala`, `Bhojanshala`, `Upashray`. Do not anglicize or translate these.
   - **Jain, NOT Hindu** — no saffron/orange, no Om, no Ganesha; the visual identity is white marble + crimson + gold

3. **Read `JCA_iOS_App_Walkthrough.pptx`** if you can (it has the per-screen navigation map and the tab → screen taxonomy).

4. **Produce a written migration plan** before any code changes:
   - List the screens that already exist and need updating (e.g., "Home, Donate, Profile exist but need restructuring")
   - List the screens that are brand new and need to be created from scratch
   - List the screens being deprecated/merged
   - Identify any architectural changes needed (e.g., new TabView ordering, new shared components)
   - Note anything ambiguous about the existing code that affects the migration — and **ask before guessing**

Wait for confirmation on the plan before writing code.

---

## Project context

- **Target:** iOS 17+ (use Observation, NavigationStack, modern SwiftUI APIs — not legacy `NavigationView` or `ObservableObject` if the existing code already uses Observation; otherwise match what's there)
- **Language:** Swift 5.9+ / SwiftUI
- **Platforms:** iPhone first, iPad layouts deferred (do not implement adaptive layouts unless trivial)
- **Audience:** JCA NY sangha members. The user persona is multi-generational — from Pathshala kids (5–17) to first-gen elders. UX must be **forgiving, calm, and unambiguous**. No dark patterns, no growth-hacky pop-ups.

---

## The five-tab information architecture (this is the critical change)

The bottom tab bar must contain exactly these five tabs in this order. If the existing app has different tabs, **migrate** to this structure — keeping existing screens that fit, restructuring those that don't.

| # | Tab | SF Symbol | Purpose |
|---|-----|-----------|---------|
| 1 | **Home** | `house.fill` | Daily-touch dashboard ("toothbrush test" — opened weekly+) |
| 2 | **Calendar** | `calendar` | Month view + events + festivals + Jain Panchang |
| 3 | **Donate** | `heart.fill` | Causes, Sponsors-this-month, History (with receipts), Subscriptions |
| 4 | **Community** | `bubble.left.fill` | Sangha hub: Feed, Pathshala, Volunteer, News, Gallery, Live Darshan, Virtual Tour |
| 5 | **Profile** | `person.crop.circle.fill` | Account + Family/Dues + Membership + Notifications + a "More" grid for long-tail features |

**Long-tail features** (Jinvani, Business Directory, Recipes, Restaurants, Library, Facility Booking, Jain Centers USA, Horoscope, Classifieds, Youth Connect, Pravachan, News, Video, Help) live in the **More grid inside Profile**, not in the tab bar.

---

## Design system — port this exactly

Create or update a `DesignSystem/` (or `Theme/`) module with these tokens. If the existing app already has design tokens, **extend rather than replace**, mapping old token names to new ones in a single migration commit.

### Colors (semantic tokens, all from the HTML's `:root` CSS vars)

```swift
extension Color {
    // Primary Jain identity
    static let jcaCrimson      = Color(hex: 0xA8202C) // primary
    static let jcaCrimsonDeep  = Color(hex: 0x7A1620)
    static let jcaCrimsonSoft  = Color(hex: 0xC84252)

    // Accent — sacred gold
    static let jcaGold         = Color(hex: 0xC9A961)
    static let jcaGoldLight    = Color(hex: 0xE3C889)
    static let jcaGoldDeep     = Color(hex: 0x8C6F30)

    // Surfaces — marble + cream
    static let jcaCream        = Color(hex: 0xFAF6EF)
    static let jcaCreamWarm    = Color(hex: 0xF4ECDD)
    static let jcaPaper        = Color.white

    // Text
    static let jcaInk          = Color(hex: 0x1C1410)
    static let jcaInkSoft      = Color(hex: 0x4A3D35)
    static let jcaMuted        = Color(hex: 0x8A7864)

    // Structure
    static let jcaBorder       = Color(hex: 0xE8DFD0)
    static let jcaBorderWarm   = Color(hex: 0xEAD9B8)

    // Reserved for Live Darshan + Virtual Tour ONLY
    static let jcaSacredDark   = Color(hex: 0x08040A)
}
```

Add a `Color(hex:)` initializer if one doesn't already exist.

### Typography

```swift
enum JCAFont {
    // Fraunces — variable serif, used for sacred/display + numerical values
    static func display(_ size: CGFloat, italic: Bool = false) -> Font { … }
    // Inter — UI / body
    static func body(_ size: CGFloat, weight: Font.Weight = .regular) -> Font { … }
}
```

Bundle Fraunces (variable) and Inter as custom fonts. If they're not already in the asset catalog, download from Google Fonts, add to `Resources/Fonts/`, register in Info.plist (`UIAppFonts`), and verify via `UIFont.familyNames`. Provide system-font fallbacks (`.serif` for display, `.system` for body) if registration fails.

### Spacing, radii, shadows

Match the HTML — most cards use `border-radius: 16px`, padding `14–16px`, subtle shadow `0 1px 2px rgba(28,20,16,0.04)`. Codify as `JCASpacing.cardPadding`, `JCARadius.card`, `JCAShadow.card`.

### Iconography

The HTML uses inline SVGs that are essentially **stroke-based, 24×24, weight 2px** — these map cleanly to SF Symbols. Use SF Symbols as the default. For the few that don't have a clean SF Symbol equivalent (Jain swastika ornament, the diamond ornament, the lotus 🪷), commission them as custom SVG/PDF assets in the asset catalog. **Do not use the lotus emoji as a UI element** — only as text content where the original mockup uses it.

### Dark mode

Light mode is the default and the design's home base. **Dark mode applies ONLY to the Live Darshan and Virtual Tour screens** for meditative reasons. Do not blanket-port the whole app to support `.preferredColorScheme(.dark)` — the cream-and-marble identity is core.

---

## Screen-by-screen specification

For each screen below: **(a) what's new or changed**, **(b) navigation entry points**, **(c) key data model**, **(d) implementation notes**. Reference the matching phone in `jca-ny-app.html` for exact pixel-level details.

### 1. Home Dashboard (`HomeView`)

**This is the most-changed screen. It must be rebuilt as a vertically scrolling stack of 8 sections.**

Sections in order from top to bottom:

1. **Greeting + Member ID chip** — "Jai Jinendra 🙏" eyebrow, member name in Fraunces 28pt, member ID chip with gold dot. Avatar on the right deep-links to Profile.
2. **Panchang card** — date (`EEEE, d MMMM yyyy`), tithi (e.g., "Chaitra Sud · Asthami"), 3-cell grid: Sunrise, Sunset, Pratikraman. White card with 3px crimson left-border accent.
3. **Today's Swamivatsalya** — sponsor recognition banner. Cream-warm gradient background, `🙏` emoji on the right, label "TODAY'S SWAMIVATSALYA" in gold-deep, sponsor name in crimson, optional "In memory of…" line.
4. **Thought for Today** — Fraunces italic 15pt quote with attribution. Gold left-border accent.
5. **Daily Quiz** — gold-tinted card. Day counter ("Day 47"), streak indicator ("🔥 12-day streak"), question in Fraunces, 4 options A/B/C/D as tappable rows. State persists locally; +1 day on first launch each calendar day; streak resets if user misses a day.
6. **Quick Actions** — horizontal scroll of 5 tiles: Live Darshan (5 shrines), Donate (active causes), Calendar (panchang), Gallery (photo count), Volunteer (open seva count). Two tile styles — default (white) and gold (`.gold` modifier) for emphasis.
7. **Center Hours** — JCA Elmhurst card with "● Open Now" pill, today's hours highlighted in crimson, full-week schedule, three actions row: Call (`tel:`), Directions (Apple Maps `maps://?daddr=`), Email (`mailto:`).
8. **Upcoming Events** — 3 event cards with date-block on the left (cream box, gold "APR" / black "26"), title, description, time + location meta. "See all" links to Calendar tab.
9. **Community Feed preview** — 2 posts (latest pinned admin + most-recent member). "Open feed" links to Community tab → Feed.
10. **Demo Notification Triggers** (optional — keep only if the existing app has a debug/demo mode). Two buttons preview push notifications.

**Navigation entries:** default tab on launch, tab-bar tap, deep-link `jca://home`.

**State:** `HomeViewModel` with `@Observable`. Pull-to-refresh re-fetches Panchang + sponsor + feed. Quiz state persists in `UserDefaults` keyed by `quizDay`.

### 2. Calendar (`CalendarView`)

Reuse existing if structure matches — otherwise: month grid with day cells; festival days marked with **gold dot**, JCA event days with **crimson dot**, today highlighted with crimson ring. Tithi label appears below day number on parva days. Swipe between months. Tap a day → list of events for that date. Tap an event → `EventDetailView`.

**EventDetailView** (existing or new): hero image, title, full schedule, location (with Map preview), RSVP button, **"Sponsor this event"** link → deep-links into the donate flow with the event prefilled. Add-to-Apple-Calendar button (use `EventKit`).

### 3. Donate tab (`DonateView` — uses sub-tabs)

The Donate tab now has **4 sub-views**, presented as a top-pill segmented control:

#### 3a. Causes (existing, restructure)
Lists active causes: General Fund, Temple Maintenance, Bhojanshala, Pathshala, Matching Gifts, Sponsor a Day. Each card shows progress bar (raised / goal), donor count, suggested-amount chips ($51, $108, $251, $501, $1,008, custom), and a recurring toggle. Tap a cause → `CauseDetailView` → `PaymentView`.

**Bhojanshala is special:** specialized flow with a date picker showing available dates (gold = open, dimmed = booked), three meal-type tiers (Full Lunch $1,251 / Sweet Box $351 / Snack Seva $501), and an "in memory of / in honor of" text field.

#### 3b. Sponsors of the Month *(new)*
`SponsorsOfMonthView` — header with month total raised + sponsor count, pill tabs (All / Bhojanshala / Festivals), sponsor rows with avatar, name, what-they-sponsored, amount, date, optional memorial text. Backed by an admin-curated feed (treat as read-only from your perspective; backend already exists or stub it).

#### 3c. History *(new)*
`DonationHistoryView` — YTD hero card (crimson background, big number), "Year-end Statement" download button (calls a backend endpoint that returns a PDF), pill tabs (current year / prior year / all years), grouped-by-month list. Each row: cause icon, cause name, date, payment method, amount, **↓ Receipt** link that downloads a PDF. Use `URLSession` + `.fileImporter`/`UIDocumentInteractionController` or modern `ShareLink` for the receipt download.

#### 3d. Subscriptions *(new)*
`SubscriptionsView` — pill tabs (My Subscriptions / + Set Up New). Each active subscription card: cause name, frequency, started-date, amount with `$X /mo` styling, next-charge date, lifetime total, **Edit Amount** and **Pause** actions. Below: "Set up a new recurring seva" CTA, then 3 pre-built plan templates (Daily Aarti $11/day, Bhojanshala Family $108/mo, Paryushan Dāna $2,508/yr). Backend handles actual recurring billing; the app only surfaces state and triggers create/edit/pause/cancel.

**PaymentView** (likely existing): Apple Pay (default), saved cards, bank transfer / Zelle. Use `PassKit` for Apple Pay. Add "Make this monthly" toggle that pivots into the Subscription create flow on success.

**ThankYouView** (likely existing): full-screen confirmation, animated lotus, anumodana headline, receipt download buttons, optional "Share to community feed" prompt that launches a community-post composer prefilled with the donation context.

### 4. Community tab (`CommunityView`)

Has **2 sub-flows + a hub:**

#### 4a. Feed *(new — primary view of this tab)*
`CommunityFeedView` — the social hub. Pill tabs (All / Admin / Members / Youth). Compose stub at top: tap → `ComposePostView`. **Important: posts are subject to whitelist moderation.** A first-time user must see a one-time disclosure sheet explaining "Posts are reviewed by admin before appearing in the public feed." Author can see their own pending posts in a "Pending Review" state with a dashed border and "Visible only to you" caption.

Post types:
- **Admin post** — crimson "JC" avatar, **OFFICIAL** badge, optional "📌 Pinned", optional image, reactions (🪷 lotus = primary like, 🙏 namaste, 💬 comment), share.
- **Member post** — gold "initials" avatar, optional **YOUTH** badge, optional image, same reactions.
- **Pending Review (your own)** — dashed border, opacity 0.7, "Visible only to you" subtitle.

Reactions are picker-driven; the like equivalent is the lotus (🪷) — **not a heart** (heart = donate semantics).

#### 4b. Hub
A grid or list of: **Pathshala** (children's class hub), **Volunteer** (seva opportunities + member-level lifetime hours — note: the hours-tracking UI is an open spec item, build the read-only view first), **News & Newsletters**, **Photos & Videos Gallery**, **Live Darshan** (5 shrine streams, dark-mode), **Virtual Tour** (360° walkthroughs of the 5 shrines, dark-mode), **Youth Connect** (placeholder OK).

**Live Darshan and Virtual Tour are dark-mode** — use `.preferredColorScheme(.dark)` and override surface colors with `.jcaSacredDark`.

### 5. Profile tab (`ProfileView`)

Top-level structure:

1. **Profile hero** (crimson background, gold avatar with initial, name in Fraunces, "JCA MEMBER · ID 04812")
2. **Stats row** — Donated YTD, Seva Hours, Family Members count
3. **Membership card** — tier ("Patron Sustaining"), member-since, renewal date, Manage button
4. **Account section list:** Family Profile, Donation Receipts, Payment Methods, Recurring Subscriptions
5. **Notifications section** — toggle list: Parva Days & Festivals, Daily Aarti Reminder, Birthday & Anniversary, Pathshala Class Reminders, Weekly Newsletter
6. **Support section list:** Help & Support, About JCA, **Sign Out** (crimson)

Tapping any list item navigates to its dedicated view. **Family Profile** is the most important sub-screen:

#### 5a. Family · Dues *(new)*
`FamilyDuesView` — top is a **red-tinted Pending Dues card** (always shown if `duesTotal > 0`): line items (Annual Membership Dues, MJK Family Pass, Pathshala Term Fee), total amount in big Fraunces serif, **Pay All Now** button → PaymentView preconfigured with bundled dues. Below dues: family member cards (Self/Primary, Spouse, Children with PATHSHALA badge, Parents). Each card: avatar, name, relationship, DOB, optional gotra/anniversary. **+ Add Family Member** CTA.

If a member has dues pending, also show a **dismissible banner on Home** that deep-links here.

#### 5b. More · Utility Drawer *(new)*
`MoreGridView` — accessed via "Explore More" button on Profile or a More icon at the top. Three labeled sections, each a 4-column grid of tiles:

- **Sacred & Learning** — Jinvani, Virtual Tour, Live Darshan, Library
- **Community Resources** — Business Directory, Restaurants, Jain Centers USA, Facility Booking, Classifieds, Horoscope, Recipes, Youth Connect
- **Pravachan & News** — Pravachan, News, Video, Help

Each tile: small icon in crimson-tinted square, label below, taps to its destination view. Tiles are 1-column wide, ~80pt tall.

#### 5c. Long-tail screens (build from scratch)

- **`JinvaniLibraryView`** — searchable PDF library of Jain scriptures. Search bar (full-text search across PDF text — use PDFKit's `findString`), pill tabs (All / Agam Sutras / Commentaries / Children / Bookmarks). Continue-Reading hero with progress bar (e.g., Tattvārtha Sūtra, Page 84/312). Book cards: cover (gradient if no image), title in Fraunces, author italic, format badge (PDF / Audio / Illustrated), language. Bookmark and progress persist in SwiftData.

- **`BusinessDirectoryView`** — Jain-owned member businesses. Category pills (All, Hospitality, Jewelry, Legal, Medical, Finance, Food). Listing rows: logo, name, category + location, rating with star, sangha-discount/member-rate badges. Backed by an admin-managed JSON feed; cache locally. Tap a row → `BusinessDetailView` with phone (`tel:`), website (`SFSafariViewController`), address (Maps).

- **`FacilityBookingView`** — reserve JCA halls (Main Hall capacity 450 / Upashray 120 / Marble Lobby 80). Date picker at top, 3 facility cards each with hero image, capacity, member price ($2,508 / $751 / $351 per period), Book button → `FacilityBookingFlow` (date confirmation, deposit collection via PaymentView, booking-policy disclosure: 60% off member rate, $500 refundable deposit, 14-day cancellation, **pure-veg catering only**).

- **`JainCentersUSAView`** — pill tabs (Centers / Restaurants / Map View). Centers list: 89 Jain temples across the US with address, distance from user, hours. Restaurants list: pure-veg + Jain-friendly nearby restaurants with veg badges. Map view uses MapKit. Tapping a pin opens directions in Apple Maps (`MKMapItem.openInMaps`). Use Core Location for distance computation; gracefully degrade if location permission denied.

- **Recipes**, **Classifieds**, **Horoscope**, **Library** (separate from Jinvani — this is the temple's general library), **Pravachan**, **News**, **Video**, **Help** — stub these as `ComingSoonView` with a graceful "in development" message themed to JCA. Don't fake content.

---

## Data layer

### Models

Define these in `Models/` (or extend existing). Use `Codable` and `Identifiable`. Use SwiftData (`@Model`) where state must persist locally; otherwise plain structs.

```swift
struct Member: Codable, Identifiable { /* id, name, memberID, gotra, dob, avatar, role */ }
struct Family: Codable { /* primary, members[], duesTotal, duesItems[] */ }
struct Panchang: Codable { /* date, tithi, sunrise, sunset, pratikramanTime */ }
struct Sponsor: Codable, Identifiable { /* memberRef, cause, amount, date, memorialText */ }
struct Cause: Codable, Identifiable { /* id, name, description, raised, goal, donorCount, suggestedAmounts[] */ }
struct Donation: Codable, Identifiable { /* id, cause, amount, date, paymentMethod, receiptURL */ }
struct Subscription: Codable, Identifiable { /* id, cause, frequency, amount, started, nextCharge, lifetimeTotal, status */ }
struct Event: Codable, Identifiable { /* id, title, description, start, end, location, hero, allowsRSVP, sponsorshipEnabled */ }
struct CommunityPost: Codable, Identifiable { /* id, author, kind: .admin/.member/.youth, body, image, reactions, createdAt, status: .approved/.pending */ }
struct Book: Codable, Identifiable { /* id, title, author, format, language, pdfURL, currentPage, totalPages */ }
struct Business: Codable, Identifiable { /* id, name, category, address, phone, website, rating, hasSanghaDiscount */ }
struct Facility: Codable, Identifiable { /* id, name, capacity, memberRate, publicRate, heroImage */ }
struct JainCenter: Codable, Identifiable { /* id, name, address, hours, distance */ }
struct VegRestaurant: Codable, Identifiable { /* id, name, address, kind: .pureVeg/.jainFriendly, rating, distance */ }
```

### Services

If the existing app has an API client, **extend it**. Otherwise create thin async services:

```swift
protocol PanchangService { func fetch() async throws -> Panchang }
protocol DonationService { func causes() async throws -> [Cause]; func donate(_ req: DonateRequest) async throws -> DonationReceipt; func history() async throws -> [Donation]; func subscriptions() async throws -> [Subscription]; … }
protocol CommunityService { func feed(filter: FeedFilter) async throws -> [CommunityPost]; func compose(_ post: NewPost) async throws -> CommunityPost; … }
protocol JinvaniService { func library() async throws -> [Book]; func searchAll(_ query: String) async throws -> [SearchHit]; … }
// etc.
```

Provide both a real implementation and a `MockXXXService` for previews and tests.

### Persistence (SwiftData)

Persist locally:
- Quiz day + streak
- Bookmark state for Jinvani books
- Read-progress per book (currentPage)
- Notification preference toggles (mirror to backend on change)
- Cached Panchang for today (so Home renders instantly)

---

## SwiftUI conventions to follow

1. **One screen = one View file**, named `<Screen>View.swift`, in `Features/<TabOrFeature>/`. ViewModels go alongside as `<Screen>ViewModel.swift`.
2. **Prefer `@Observable`** (Observation framework) over `ObservableObject` if iOS 17+. Match the existing app's style if it differs.
3. **Use `NavigationStack` with typed paths** (`NavigationPath` + `navigationDestination(for:)`) — not the legacy `NavigationLink(destination:)` everywhere.
4. **Compose, don't repeat.** Common card styles, the gold-pill segmented control, the avatar circle, the pending-dues card, the more-tile, the feed-post — extract these as reusable views in `DesignSystem/Components/`.
5. **Previews are mandatory.** Every view ships with at least one `#Preview` block, ideally multiple — e.g., loaded state, empty state, error state, dark-mode (Live Darshan only).
6. **Strings use `LocalizedStringKey`**. Don't hardcode user-facing strings as Swift `String`. The `open items` spec calls out Hindi/Gujarati support as TBD — **set up the localization infrastructure now** (`Localizable.xcstrings`), even if only English is populated. For Sanskrit/Prakrit terminology like *swamivatsalya*, *anumodana*, *pratikraman*: **keep these in the same string in every locale** (they are proper terminology, not translatable).
7. **Accessibility:** every interactive element gets `.accessibilityLabel` + `.accessibilityHint`. Phone-call/directions/email actions in the Center Hours card need traits (`.isButton`). Quiz options need to be navigable in order. The lotus reaction button announces "Like with lotus, 142 lotuses".
8. **Dynamic Type:** every text element uses font roles or `.dynamicTypeSize(...)` clamping where layouts would break above XXL.
9. **No third-party UI dependencies** unless something is critically needed (e.g., a PDF viewer beyond PDFKit, or a chart library for stats). Discuss before adding dependencies.

---

## Things to NOT do

- **Do not** rewrite working screens that already match the new design well (e.g., if the existing Splash, Sign In, Calendar Month View, Live Darshan, Virtual Tour are already aligned).
- **Do not** invent backend endpoints. If a feature needs an endpoint that doesn't exist, surface it in the migration plan as a "**Backend ask**" with a proposed contract (`POST /v1/donations/subscribe { causeId, amount, frequency }` etc.).
- **Do not** use Lorem Ipsum or "Sample Text". The HTML mockup uses real Jain terminology and realistic JCA-specific data — **port that data verbatim** into the SwiftUI previews and mock services.
- **Do not** use the lotus emoji as a UI primitive or the heart emoji for likes — match the design's reaction grammar (lotus = like, namaste = appreciation, comment, share).
- **Do not** introduce dark mode globally. Only Live Darshan and Virtual Tour.
- **Do not** change the app's bundle ID, code-signing, or build configuration unless required.

---

## Constraints around sensitive content

- **The Daily Quiz** is a learning aid, not a leaderboard. Streak data stays local; do not gamify with public rankings.
- **The Family Dues** flow is financial — **always** show line items before the total, never auto-charge. The "Pay All Now" button takes the user to PaymentView for explicit confirmation; it does not silently bill.
- **The Community Feed** moderation is non-negotiable — **never** show a member's pending post in the public feed even momentarily ("optimistic UI" is not appropriate here). The author sees a "Pending Review" state; everyone else sees nothing until admin approves.
- **The Sponsors of the Month** view is a recognition feature, not a leaderboard. Display in chronological order or by category, **never sorted by amount descending** by default.
- **The Birthday & Anniversary notifications** require users to opt in per family member during family-profile setup. Don't auto-enable.

---

## Output expectations

1. **Step 0 first** — produce a written migration plan (markdown is fine, in chat) and **wait for confirmation** before writing code.
2. **Then execute the plan in small, reviewable commits.** Each commit should be one logical change — for example: "Add design tokens (Colors, Typography, Spacing)", "Restructure root TabView to 5-tab IA", "Implement Home Dashboard sections 1–4 (Greeting, Panchang, Sponsor, Thought)", "Implement DonationHistoryView and wire to existing PaymentView", etc. Commit messages follow Conventional Commits (`feat(home): rebuild dashboard with 8-section layout`).
3. **Build clean.** After each commit, ensure the project still builds (`xcodebuild -scheme JCA -destination 'platform=iOS Simulator,name=iPhone 15 Pro'`) and the new screens render in previews.
4. **Open questions stay surfaced.** Maintain a running `MIGRATION_NOTES.md` at the repo root listing every assumption you made, every ambiguity in the existing code you resolved, and every "Backend ask" — so a human reviewer can verify each choice.
5. **Don't ship a single 5,000-line PR.** If the migration is large (it is), break it into a sequence of smaller PRs by feature area, with the design-tokens PR as a prerequisite.

---

## Files attached / referenced

- `jca-ny-app.html` — design source of truth (28 phone mockups + design system in CSS variables)
- `JCA_iOS_App_Walkthrough.pptx` — per-screen walkthrough with navigation paths
- `JCA_App_Features.xlsx` — feature spec (the 5-tab IA + sub-features per tab + open spec items)

If any of these aren't accessible to you in the current sandbox, ask before proceeding.

---

## Final note

The JCA NY sangha is multi-generational and has been around for 50+ years. The app is a **digital companion to a physical temple**, not a replacement for it. When in doubt, choose the option that is **calmer, slower, and more reverent** — never the option that feels growth-hacky, attention-grabbing, or transactional. Anumodana 🙏
