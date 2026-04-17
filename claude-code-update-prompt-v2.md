# Incremental Update v2: JCA NY iOS App — Notification Demo Screen & Enhanced Gallery

## Context

You have already built the base JCA NY SwiftUI iOS app. You may also have already implemented the first set of incremental updates (member ID chip, sponsor banner, volunteer quick action, payment → thank-you flow, initial gallery screen, etc.).

**This document covers the NEW additions on top of that:**
- A dedicated **Notification Playground / Demo screen** accessible from the Profile tab (Settings section)
- An **expanded push notification system** supporting 8 notification types with deep-linking
- A **significantly enhanced Gallery** with real nyjaincenter.org image URLs, richer layouts, and proper video support

Use the updated `jca-ny-app.html` mockup as the visual source of truth. Compare the Gallery and the new **Notification Playground** phone to your existing implementation and upgrade accordingly.

---

## Summary of Changes

1. **New Screen:** `NotificationDemoView` — a settings-accessible playground where the user can trigger 8 different notification types and see how each renders
2. **Expanded model:** `PushNotificationType` enum with 8 cases (was 2 — birthday + event)
3. **Updated Gallery:** hero banner, stats bar, featured events strip, shrines explore strip, dedicated video library grid, masonry photo layout — all using real JCA image URLs
4. **YouTube link:** Gallery links out to JCA's official YouTube channel
5. **Deep linking:** Each notification type now deep-links to the correct destination when tapped

---

## Feature 1 — Notification Demo / Playground Screen

### Purpose
A dedicated screen that allows developers, QA, and members to preview how each push notification type looks and behaves. In production, this screen lives under **Settings → Notification Playground** (gated behind an internal build flag or admin role). For the demo build, it's accessible from the Profile tab.

### Entry point

Add a row to the Profile screen's Account section:
```
[🔔 icon]  Notification Playground        ›
```
Tap navigates to `NotificationDemoView`.

### Screen structure (top to bottom)

**Navigation bar:**
- Back chevron button (circular, 30×30, white background with 0.5pt border, crimson chevron) — pops the nav stack
- Title: "Notification Demo" — Fraunces 19pt 600
- Subtitle: "Preview how JCA push notifications look" — Inter 10pt muted

**Hero card (crimson gradient):**
- Full-width card with 18pt corner radius, margin 24pt horizontal, padding 16pt
- Background: radial gradient from `#a8202c` at top to `#7a1620` at bottom
- Decorative gold radial glow top-right (via `::before` equivalent using an overlay circle)
- Content (colored cream/gold):
  - **Animated bell icon** — 44pt circle, gold-tinted background, bell SF Symbol (`bell`) inside. Animate with a subtle shake every 3 seconds (4 alternating rotations: -12°, +10°, -8°, +4°, back to 0). Use `.phaseAnimator` or a timer-driven state transition.
  - Heading: "Stay connected to your *sangha.*" — Fraunces 20pt, "*sangha.*" italic in gold-light
  - Subheading: "Tap any notification below to preview how it appears on your iPhone lock screen." — Inter 11pt 80% opacity, 220pt max width

**Section 1: Wishes & Reminders**
Tiny crimson uppercase label `✦ Wishes & Reminders`, then four notification type cards.

**Section 2: Community & Seva**
Same styling, four more cards.

Each **NotificationTypeCard** renders as:
- White background, 0.5pt border, 12pt corner radius, subtle shadow
- 12pt internal padding, 12pt gap between elements
- **Left:** 38×38 rounded square with a soft two-tone gradient background (unique color per type — see palette below) and a large emoji glyph
- **Center:** vertical stack — `name` (Fraunces 13pt 600) + `description` (Inter 10pt muted)
- **Right:** small pill button "Send" — crimson fill, cream text, 11pt Inter 600, 7pt/14pt padding, fully rounded, subtle crimson shadow. Scale-down 0.95 on press.

**Footer tip card:**
- Margin 24pt, gold-tinted gradient background, dashed gold border, 12pt padding
- 💡 emoji + "**DEVELOPER TIP** — Tap a Send button to see the iOS-style push notification banner animate in from the top. Each notification deep-links to a relevant screen when tapped."

### Icon palette (card backgrounds)

Match the HTML exactly:
```swift
enum PushNotificationType {
    case birthday    // 🎂 — pink gradient (#ffe1eb → #ffc2d4)
    case eventReminder // 🔔 — warm amber (#fde8c4 → #fbd891)
    case parvaDay    // 🪷 — lavender (#e8d4f5 → #c9a0ec)
    case aartiReminder // 🪔 — orange gradient (#ffebc7 → #ffd080)
    case donationReceived // 💝 — mint (#d4f5dc → #a0e6b0)
    case volunteerOpportunity // 🤝 — sky (#d4e8f5 → #a0c9e6)
    case pathshalaClass // 📚 — peach (#fcebd4 → #f8c897)
    case newPhotos // 📸 — sand (#e8e0d0 → #c9b896)
}
```

### Notification content templates

Hardcode these templates in `NotificationContentFactory.swift`:

```swift
struct NotificationContent {
    let type: PushNotificationType
    let title: String
    let body: String
    let ctaText: String
    let destination: Destination
}

enum Destination {
    case donate
    case event(id: UUID)
    case calendar
    case liveDarshan
    case donationReceipt(id: UUID)
    case volunteerList
    case pathshalaLesson(id: UUID)
    case gallery
}
```

Templates (match the HTML exactly — no deviations):

| Type | Title | Body | CTA | Destination |
|------|-------|------|-----|-------------|
| birthday | 🎂 Happy Birthday! | Warmest wishes from JCA. May this year bring you peace, prosperity & dharma. | Tap to donate in gratitude › | `.donate` |
| eventReminder | 🙏 Event Reminder | Mahavir Janma Kalyanak is on 26th April. Please RSVP now. | Tap to RSVP › | `.event(id: mjk.id)` |
| parvaDay | 🪷 Parva Day Tomorrow | Ayambil Oli begins tomorrow. Prepare yourself for 9 days of austerity. | View calendar › | `.calendar` |
| aartiReminder | 🪔 Sandhya Aarti in 15 min | Join live darshan for evening aarti at Mahavir Swami Temple. | Watch live › | `.liveDarshan` |
| donationReceived | 💝 Donation Received | Thank you! Your $1,251 donation for Bhojanshala has been processed. | View receipt › | `.donationReceipt(id: latest)` |
| volunteerOpportunity | 🤝 Seva Opportunity | Bhojanshala needs helpers this Sunday. Sign up to serve your sangha. | Sign up now › | `.volunteerList` |
| pathshalaClass | 📚 Pathshala in 30 min | Lesson 8: The 5 Mahavratas — See you in Upashray Hall. | Review lesson › | `.pathshalaLesson(id: lesson8.id)` |
| newPhotos | 📸 New Photos Added | 48 new photos from Paryushan Parv 2025 are now in the gallery. | View gallery › | `.gallery` |

### Send button behavior

On tap:
1. Haptic feedback (`UIImpactFeedbackGenerator(style: .soft)`)
2. Build the `PushNotification` model from the template
3. Call `PushNotificationService.shared.present(notification)` — this is the same service you built in v1 of the updates, which drives the overlay banner

The banner itself renders at the app's root level via the `PushNotificationOverlay` view modifier you already have. **The banner content is not re-implemented here** — reuse it. Just make sure it's aware of the new 8 types and renders the correct icon color for each (derive from `notification.type`).

### Tap-to-deep-link

When the notification banner is tapped:
1. Dismiss the banner
2. Route via `AppState`:
   - `.donate` → switch to Donate tab, pop to root
   - `.event(id:)` → switch to Home tab, push `EventDetailView(event: ...)` onto its nav stack
   - `.calendar` → switch to Calendar tab
   - `.liveDarshan` → switch to Home tab, push `LiveDarshanView`
   - `.donationReceipt(id:)` → switch to Profile tab, push `DonationReceiptView(donation: ...)`
   - `.volunteerList` → switch to Community tab, push `VolunteerView`
   - `.pathshalaLesson(id:)` → switch to Community tab, push `PathshalaView` then navigate to lesson
   - `.gallery` → switch to Community tab, push `GalleryView`

Implement routing with a `NotificationRouter`:
```swift
@MainActor
final class NotificationRouter {
    static let shared = NotificationRouter()
    func route(to destination: Destination, appState: AppState) {
        switch destination { ... }
    }
}
```

---

## Feature 2 — Enhanced Gallery Screen

**Replace** the existing `GalleryView` layout with the richer version below. Keep the `GalleryViewerView` (tap-to-view full-screen) and the `GalleryItem`/`GalleryAlbum` models — just change the composition.

### Overall structure (vertical scroll)

1. **Header** (unchanged) — "Gallery · moments." + subtitle
2. **Segmented tabs** — three pills: All (default) / Videos / 360° (change first tab label from "Photos" to "All")
3. **Hero banner** (NEW, replaces the simpler featured card)
4. **Stats strip** (NEW)
5. **Featured Events horizontal scroll** (NEW)
6. **Explore Shrines horizontal scroll** (retain — now 6 shrines instead of 5)
7. **Video Library grid** (NEW — replaces the sprinkled video tiles)
8. **Masonry photo grid** (replaces the uniform 3-column grid)

### 2a. Hero banner

- Full-width card, 200pt tall, 18pt corner radius, 24pt horizontal margin, 12pt bottom margin, medium shadow
- `AsyncImage` of the MJK 2025 photo, `resizable().aspectRatio(contentMode: .fill).clipped()`, saturation boost `.saturation(1.1)`
- Dark gradient overlay from `Color.clear` at 35% to `Color.black.opacity(0.85)` at 100%
- Bottom-left overlay content (padding 16–18pt from edges):
  - **Gold pulsing pill** at top: "FEATURED" — solid gold background, crimson text, 9pt Inter 700, uppercase, 4pt/10pt padding, rounded. Prepend with a tiny 5×5 crimson dot. Optional subtle pulse animation on the dot.
  - **Title**: "Mahavir Janma *Kalyanak 2025*" — Fraunces 22pt 500, ". *Kalyanak 2025*" italic in `.jcaGoldLight`, line height 1.1
  - **Meta row**: three inline items separated by spacing, each with emoji + text
    - 🖼 48 photos
    - ▶ 6 videos
    - 📅 April 2025
  - 10pt Inter, opacity 85%, 6pt top margin

### 2b. Stats strip

- Horizontal card, 24pt margin, 12/16pt padding, white background, 0.5pt border, 12pt corner radius, subtle shadow
- Four equally-spaced stats, separated by 1pt vertical dividers:

| Number | Label |
|--------|-------|
| 1,247 | Photos |
| 89 | Videos |
| 34 | Albums |
| 9 | 360° Tours |

- Number: Fraunces 17pt 600, crimson, line-height 1
- Label: Inter 9pt 600, uppercase, letter-spacing 0.12em, muted, 3pt top margin
- Each stat is a `.centered` VStack; dividers are 1pt wide grey

### 2c. Featured Events horizontal scroll

- Section title "Featured Events" + subtitle "Latest albums" on the right
- Horizontal ScrollView, 10pt spacing, with 24pt leading padding and 24pt trailing padding
- **Each event card** (`GalleryEventCard`):
  - Width 180pt, 14pt corner radius, 0.5pt border, subtle shadow
  - Top: 120pt image, `AsyncImage` with gradient fallback
  - Top-right on image: tiny count tag with blurred black background, white text, "📸 48" etc.
  - Bottom info block (10pt/12pt padding):
    - Date eyebrow: Inter 9pt 700 crimson uppercase (e.g., "April 26, 2025")
    - Event name: Fraunces 13pt 600 ink, 2pt top margin (e.g., "Mahavir Janma Kalyanak")

Four cards seeded:
1. Mahavir Janma Kalyanak 2025 — April 26, 2025 — 48 photos
2. Paryushan Maha Parv — Sept 2025 — 124 photos
3. Annual GB Meeting — Dec 14, 2025 — 32 photos
4. Diwali Celebration — Nov 2025 — 67 photos

### 2d. Explore Shrines horizontal scroll

Same pattern as the existing albums strip — 6 cards now (was 5), **drop the "Paryushan Parva" album** from the Shrines strip (it lives in Featured Events instead). Replace with Upashray Hall and Shrimad Hall so you have all 5 shrines + Art Gallery:

1. Mahavir Swami (24 photos)
2. Adinathji Temple (18 photos)
3. Upashray Hall (22 photos)
4. Shrimad Hall (16 photos)
5. Dadawadi Shrine (14 photos)
6. Art Gallery (32 photos)

### 2e. Video Library section (NEW)

- Section header: "Video Library" title + **"YouTube ›"** link on the right (opens in `SFSafariViewController` or external browser)
- The YouTube icon is a small red SF Symbol `play.rectangle.fill` (or draw the YT logo path)
- URL: `https://www.youtube.com/user/jaincenterny`
- Body: 2-column grid, 8pt spacing, four videos
- **Each video card** (`VideoCard`):
  - Aspect ratio 16:10, 12pt corner radius, black background, subtle shadow
  - `AsyncImage` at 85% opacity
  - Dark gradient overlay bottom-half
  - **Centered play badge**: 38×38 white circle with crimson play triangle (SF Symbol `play.fill`), offset 2pt left, strong drop shadow
  - **Bottom-left caption** (Fraunces 11pt 600 white, with 0,1,3 text shadow)
  - **Bottom-right duration badge**: dark-blur background, white 9pt 700 text, 4pt radius, 2pt/6pt padding

Seed videos:
1. "Mangal Aarti" — 5:42 — thumbnail: virtual-tour/03.jpg
2. "Acharya Lecture" — 42:18 — thumbnail: virtual-tour/04.jpg
3. "MJK Highlights" — 12:03 — thumbnail: 2021MJK.jpg
4. "Paryushan Prayers" — 8:27 — thumbnail: Paryushan.jpg

Tap on video card → push `VideoPlayerView` using `AVPlayer` and `VideoPlayer` from `AVKit`. For now, since we don't have real `.mp4` URLs, stub this with a view that shows "Video coming soon" plus the thumbnail and caption. Mark as **backend integration point** in the README.

### 2f. Masonry photo grid

Replace the uniform 3-column `LazyVGrid` with a **2-column masonry** that stacks photos of varied heights:

Use `VStack` columns side-by-side, or a `LazyVStack` inside an `HStack` of two columns. Each photo has a randomized-but-consistent height (tall/medium/short → 200pt/160pt/120pt) with `.aspectFill` cropping.

Seed 8 photos alternating column assignments (the HTML shows the exact distribution — match it):

| Column | Image | Height class |
|--------|-------|--------------|
| 1 | virtual-tour/01.jpg (JCA Temple) | tall |
| 2 | virtual-tour/02.jpg (JCA Lobby) | short |
| 1 | virtual-tour/06.jpg (Shrimad) | medium |
| 2 | virtual-tour/05.jpg (Adinath) | tall |
| 1 | virtual-tour/08.jpg (Asthapad) | short |
| 2 | virtual-tour/07.jpg (Dadawadi) | medium |
| 1 | virtual-tour/09.jpg (Art Gallery) | medium |
| 2 | virtual-tour/03.jpg (Mahavir Swami) | tall |

Corner radius 8pt, 6pt spacing, 24pt horizontal margins. Tap any tile → `GalleryViewerView`.

### Image URLs (seed exactly)

All gallery images are `AsyncImage` with a crimson-gradient fallback. Use these exact URLs from the nyjaincenter.org CDN:

```swift
enum JCAImageURLs {
    // Hero + Featured Events
    static let mjk2025        = URL(string: "https://www.nyjaincenter.org/media/36d70269-ce2f-4fde-a765-30236c979d38/943000124/2021MJK.jpg")
    static let paryushan      = URL(string: "https://www.nyjaincenter.org/media/e6cd9510-4f21-443f-874c-bfd3a51d01b6/234203235/Paryushan.jpg")
    static let gbMeeting      = URL(string: "https://www.nyjaincenter.org/media/5509d2e5-7809-434a-9539-cfb25c56c425/1791229349/GB_Meeting_Icon.jpg")
    
    // Virtual tour images (1-9)
    static let jcaTemple      = URL(string: "https://www.nyjaincenter.org/Frontend/Images/virtual-tour/01.jpg")
    static let jcaLobby       = URL(string: "https://www.nyjaincenter.org/Frontend/Images/virtual-tour/02.jpg")
    static let mahavirTemple  = URL(string: "https://www.nyjaincenter.org/Frontend/Images/virtual-tour/03.jpg")
    static let upashrayHall   = URL(string: "https://www.nyjaincenter.org/Frontend/Images/virtual-tour/04.jpg")
    static let adinathTemple  = URL(string: "https://www.nyjaincenter.org/Frontend/Images/virtual-tour/05.jpg")
    static let shrimadHall    = URL(string: "https://www.nyjaincenter.org/Frontend/Images/virtual-tour/06.jpg")
    static let dadawadi       = URL(string: "https://www.nyjaincenter.org/Frontend/Images/virtual-tour/07.jpg")
    static let asthapad       = URL(string: "https://www.nyjaincenter.org/Frontend/Images/virtual-tour/08.jpg")
    static let artGallery     = URL(string: "https://www.nyjaincenter.org/Frontend/Images/virtual-tour/09.jpg")
    
    // YouTube channel
    static let youtubeChannel = URL(string: "https://www.youtube.com/user/jaincenterny")!
}
```

### AsyncImage fallback pattern

For every `AsyncImage` in Gallery:
```swift
AsyncImage(url: imageURL) { phase in
    switch phase {
    case .empty:
        LinearGradient(
            colors: [Color.jcaCreamWarm, Color.jcaGold.opacity(0.3)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .overlay(ProgressView().tint(.jcaGold))
    case .success(let image):
        image
            .resizable()
            .aspectRatio(contentMode: .fill)
    case .failure:
        LinearGradient(
            colors: [Color.jcaCrimsonDeep, Color.jcaCrimson],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .overlay(Image(systemName: "photo.fill").foregroundStyle(.white.opacity(0.4)))
    @unknown default:
        EmptyView()
    }
}
.clipped()
```

**Image caching:** Wrap `AsyncImage` with a cached loader. Recommended approach: a small `CachedAsyncImage` wrapper that stores fetched `UIImage`s in `URLCache.shared` (configured to 50MB memory, 200MB disk in `JCANYApp.init`). The remote image URLs don't change often so caching is safe.

### Permissions / Info.plist

- No new permissions needed
- For YouTube link opening, use `openURL` environment action — no entitlement required

---

## Feature 3 — Unified `PushNotificationService` Update

If your v1 implementation had only 2 notification types, upgrade to 8:

```swift
@Observable
@MainActor
final class PushNotificationService {
    static let shared = PushNotificationService()
    var active: PushNotification?
    private var dismissTask: Task<Void, Never>?

    func present(_ type: PushNotificationType, context: NotificationContext = .default) {
        let content = NotificationContentFactory.build(for: type, context: context)
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        withAnimation(.spring(response: 0.55, dampingFraction: 0.7)) {
            active = PushNotification(
                type: type,
                title: content.title,
                body: content.body,
                ctaText: content.ctaText,
                destination: content.destination
            )
        }
        dismissTask?.cancel()
        dismissTask = Task { [weak self] in
            try? await Task.sleep(for: .seconds(7))
            guard !Task.isCancelled else { return }
            await MainActor.run { self?.dismiss() }
        }
    }

    func dismiss() {
        withAnimation(.easeOut(duration: 0.3)) {
            active = nil
        }
    }

    func handleTap() {
        guard let destination = active?.destination else { return }
        dismiss()
        NotificationRouter.shared.route(to: destination)
    }
}
```

The `PushNotificationOverlay` view modifier (at the root of `MainTabView`) observes `PushNotificationService.shared.active` and renders the banner accordingly.

### Banner icon color per type

The banner's app-icon square (36×36, JCA logo) always stays crimson → crimson-deep gradient with gold "JCA" text. But the title emoji and hero tinting come from the notification content itself — no additional rendering logic needed.

---

## Updated File Tree (delta from v1)

```
Views/
├── Settings/
│   └── NotificationDemoView.swift          (NEW — this document)
│       └── Components/
│           ├── NotificationHeroCard.swift
│           ├── NotificationTypeCard.swift
│           └── DemoTipCard.swift
├── Gallery/
│   ├── GalleryView.swift                   (REPLACE content)
│   ├── Components/
│   │   ├── GalleryHeroBanner.swift         (NEW)
│   │   ├── GalleryStatsStrip.swift         (NEW)
│   │   ├── GalleryEventCard.swift          (NEW)
│   │   ├── GalleryAlbumCard.swift          (existing)
│   │   ├── VideoCard.swift                 (NEW)
│   │   ├── MasonryPhotoGrid.swift          (NEW)
│   │   └── CachedAsyncImage.swift          (NEW)
Models/
├── PushNotificationType.swift              (expand to 8 cases)
├── NotificationContent.swift               (NEW)
├── NotificationContentFactory.swift        (NEW)
├── Destination.swift                       (NEW — deep-link enum)
Services/
├── PushNotificationService.swift           (expand)
├── NotificationRouter.swift                (NEW)
Resources/
└── JCAImageURLs.swift                      (NEW — centralize remote URLs)
```

---

## Acceptance Criteria

- [ ] Notification Playground is accessible from Profile → Account list item "Notification Playground"
- [ ] All 8 notification types render as cards with unique gradient backgrounds and correct emoji glyphs
- [ ] Tapping any "Send" button fires light haptic, presents the banner overlay with correct content
- [ ] Banner auto-dismisses after 7 seconds
- [ ] Tapping the banner routes to the correct destination (tab switch + navigation push)
- [ ] Bell icon on the hero card has a subtle shake animation every 3 seconds
- [ ] Gallery hero shows the MJK image with proper gradient overlay and "FEATURED" pulsing pill
- [ ] Stats strip shows 1,247 / 89 / 34 / 9 with correct typography
- [ ] Featured Events horizontal scroll has 4 real event cards with nyjaincenter.org images
- [ ] Explore Shrines strip has all 6 shrine/space entries
- [ ] Video Library section shows 4 video thumbnails with play badges and duration tags
- [ ] "YouTube ›" link opens `https://www.youtube.com/user/jaincenterny` in Safari
- [ ] Masonry grid renders 8 photos in 2-column layout with varied heights matching the HTML
- [ ] All images load from nyjaincenter.org URLs with graceful gradient fallback
- [ ] `URLCache.shared` is configured for 50MB memory / 200MB disk — images aren't re-fetched on every scroll
- [ ] No regressions in existing screens (Home, Donate, Payment, Thank You, Calendar, Profile, etc.)

---

## Implementation Order

1. Expand `PushNotificationType` enum to 8 cases with associated metadata (color palette, default emoji, default destination)
2. Create `Destination` enum + `NotificationRouter` (routes to specific tabs/stacks using `AppState`)
3. Create `NotificationContent` + `NotificationContentFactory` (hardcoded templates)
4. Update `PushNotificationService` to accept `PushNotificationType` and produce the full banner content
5. Build `NotificationDemoView` and its components
6. Wire Profile → NotificationDemoView nav
7. Create `JCAImageURLs` constants + `CachedAsyncImage` wrapper
8. Configure `URLCache.shared` in `JCANYApp.init`
9. Build Gallery components: Hero, Stats, EventCard, VideoCard, MasonryGrid
10. Replace `GalleryView` body with the new composition
11. Verify existing screens still work — navigate through each tab
12. Polish pass: haptics, animations, accessibility labels for notification type cards and video cards

---

## What NOT to Do

- Do not change the existing design system colors, fonts, radii, or shadows
- Do not remove the existing demo buttons at the bottom of Home (keep them — the Playground is a separate richer entry point)
- Do not replace `AsyncImage` with `Image` bundled assets — the gallery must load from remote URLs for the demo, with caching
- Do not bundle the JCA image URLs as hardcoded strings scattered across views — centralize in `JCAImageURLs.swift`
- Do not implement real `UNUserNotificationCenter` push registration for the Notification Demo — it's an in-app banner overlay preview only
- Do not break the Gallery item tap → GalleryViewerView flow that already exists
- Do not skip the fallback UI for failed image loads — every `AsyncImage` must have a branded fallback

Begin by opening the updated `jca-ny-app.html` and studying the "Notification Playground" phone mockup and the enhanced Gallery phone. Match the layout precisely.
