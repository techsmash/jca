# Migration Notes

Assumptions, resolutions, and backend asks made during the design migration.

---

## Assumptions

### Design System
- Renamed `Color.jcaDark` → `Color.jcaSacredDark` (value `#08040a` unchanged). Zero call-sites existed before rename.
- `Radii.s` (10pt) used for small tile corner radii; `Radii.base` (16pt) used for cards.

### Home Tab
- `ThoughtForTodayCard`: 7 static quotes in `HomeViewModel.quoteBank`. Production should fetch from CMS.
- `DailyQuizCard`: 7-item quiz bank in `HomeViewModel.quizBank`. Day index increments on first view per calendar day. Streak resets if more than 1 day lapses between quiz answers.
- `CenterHoursCard`: Weekday hours 5–9 PM, Weekend 8 AM–9 PM — hardcoded per JCA website. Update when hours change.
- `CommunityFeedPreviewCard`: Shows first 2 approved posts; tapping opens Community › Feed tab.

### Donate Tab
- `SponsorsOfMonthView`: Displayed in chronological order (oldest first in month), never sorted by amount. Per spec constraint.
- `DonationHistoryView`: Moved from inline struct in `ProfileView.swift` to standalone file. `NavigationLink` in ProfileView still resolves correctly (same module).
- `SubscriptionsView`: "Set Up New" tab shows 3 preset recurring plan templates (Daily Aarti / Bhojanshala / Paryushan). Actual subscription creation requires backend integration.

### Community Tab
- `CommunityFeedView`: Pending posts are shown with dashed border and "Visible only to you" — no optimistic UI. Filter "All" shows all posts including pending (mock). Production should filter by `authorID == currentUser.id` for pending posts.
- `ModerationDisclosureSheet`: Shown once via `@AppStorage("jca.feed.seenDisclosure")`. Persists across app launches.
- Compose bar: tapping shows informational alert (posts go through review). Full compose flow deferred to backend integration.
- `CommunityHubView`: Youth Connect tile routes to `ComingSoonView`. Add `CommunityRoute.youthConnect` when feature is built.
- Live Darshan and Virtual Tour use `.preferredColorScheme(.dark)` on their own views per spec.

### Profile Tab
- `FamilyDuesView`: Dues data (`$501 Annual Membership + $301 MJK + $151 Pathshala = $953`) is hardcoded mock. Production needs a dues API endpoint.
- `FamilyDuesView`: "Pay All Now" shows a confirmation alert stub; full payment routing deferred to `DonationFlowViewModel` integration.
- `ProfileView`: Membership tier "Patron Sustaining", member-since "2009", renewal "Dec 31, 2026" are hardcoded. Production reads from `User` model or membership API.
- `MoreGridView`: Uses `AnyView` for tile destinations. This is acceptable here since tiles are static and won't change type at runtime.
- Notification toggles persist via `@AppStorage`. Production should sync changes to backend (`PATCH /v1/user/notifications`).
- Birthday & Anniversary toggle defaults to `false` per spec (requires per-member opt-in during family-profile setup).

### Long-Tail Screens
- `JinvaniLibraryView`: Book data is static (`MockDataProvider.books`). PDFKit full-text search (`findString`) not wired since there are no real PDF files in the bundle. Reading progress and bookmarks persist in SwiftData (`BookProgress` model).
- `BusinessDirectoryView`: Business data is static mock. Production should fetch from admin-managed JSON feed and cache locally.
- `FacilityBookingView`: "Proceed to Payment" shows a confirmation alert stub. Full booking flow needs backend (`POST /v1/facilities/book`).
- `JainCentersUSAView`: 5 sample centers hardcoded. Production needs the full 89-temple dataset. Location permission gracefully degrades (distances hidden if denied). `@StateObject private var locationManager` is used in JainCentersUSAView — this is the only `ObservableObject` in the codebase (required because CLLocationManagerDelegate is class-based).

---

## Backend Asks

| Feature | Endpoint | Notes |
|---------|----------|-------|
| Compose post | `POST /v1/community/posts` | Returns `CommunityPost` with `status: .pending` |
| Feed | `GET /v1/community/posts?filter=all\|admin\|member\|youth` | Pending posts only returned if `authorID == currentUser.id` |
| Dues | `GET /v1/family/dues` | Returns line items + total |
| Pay dues | `POST /v1/payments/dues` | Bundled dues payment |
| Membership details | `GET /v1/user/membership` | Tier, since-date, renewal-date |
| Manage membership | `POST /v1/membership/manage` | Opens web flow |
| Notification prefs | `PATCH /v1/user/notifications` | Called on toggle change |
| Jinvani library | `GET /v1/library/books` | Returns `[Book]` with PDF URLs |
| Business directory | `GET /v1/businesses` | Admin-managed, cache with ETag |
| Facility booking | `POST /v1/facilities/book { facilityID, date, depositPaid }` | |
| Jain centers | `GET /v1/centers?type=temple\|restaurant&lat=&lng=` | 89 temples |
| Subscriptions | `POST /v1/donations/subscribe { causeId, amount, frequency }` | |
| Receipt download | `GET /v1/donations/:id/receipt` | Returns PDF URL |

---

## Open Items

- Hindi / Gujarati localization: `Localizable.xcstrings` file should be added. Sanskrit/Prakrit terms (swamivatsalya, anumodana, pratikraman) must remain untranslated in all locales.
- Live Darshan HLS streams: tiles in `LiveDarshanView` use placeholder `AVPlayer`. Wire real HLS URLs when available.
- Push notifications: `UNUserNotificationCenter` registration not yet wired to notification toggle `@AppStorage` keys.
- Gallery real photos: `GalleryView` uses `CachedAsyncImage` with placeholder URLs. Replace with real S3/CDN URLs.
- Donation receipt PDF download: button in `DonationHistoryView` is a stub (`TODO: download receipt`).
- Year-end statement: button in `DonationHistoryView` hero shows a stub alert.
- Youth Connect: routed to `ComingSoonView`. Build when feature is spec'd.
- Dark mode for Live Darshan / Virtual Tour: both views should apply `.preferredColorScheme(.dark)` at the root; verify this is in place.
