# JCA NY — iOS App

A production-quality SwiftUI iOS app for the Jain Center of America (NY) community.

## How to Build

### Prerequisites
- Xcode 15+
- iOS 17.0 SDK
- macOS 14+

### Setup Steps

1. **Create Xcode Project**
   - Open Xcode → New Project → iOS → App
   - Product Name: `JCANY`
   - Team: Your team
   - Bundle ID: `org.jcany.app`
   - Interface: SwiftUI
   - Language: Swift
   - Storage: SwiftData ✓
   - Include Tests: optional

2. **Add Source Files**
   - Drag the entire `JCANY/` folder into your Xcode project
   - Ensure "Copy items if needed" is checked
   - Add all groups recursively

3. **Add Custom Fonts** (Required)
   Download from Google Fonts:
   - [Fraunces](https://fonts.google.com/specimen/Fraunces) — download variable font + italic
   - [Inter](https://fonts.google.com/specimen/Inter) — download variable font

   Files needed (place in `Resources/Fonts/`):
   ```
   Fraunces-Regular.ttf
   Fraunces-Italic.ttf
   Fraunces-Light.ttf
   Fraunces-LightItalic.ttf
   Fraunces-Medium.ttf
   Fraunces-SemiBold.ttf
   Fraunces-SemiBoldItalic.ttf
   Inter-Regular.ttf
   Inter-Medium.ttf
   Inter-SemiBold.ttf
   Inter-Bold.ttf
   Inter-Light.ttf
   ```

4. **Register Fonts in Info.plist**
   Add key `UIAppFonts` (Array) with all font filenames:
   ```xml
   <key>UIAppFonts</key>
   <array>
       <string>Fraunces-Regular.ttf</string>
       <string>Fraunces-Italic.ttf</string>
       <string>Fraunces-Light.ttf</string>
       <string>Fraunces-LightItalic.ttf</string>
       <string>Fraunces-Medium.ttf</string>
       <string>Fraunces-SemiBold.ttf</string>
       <string>Fraunces-SemiBoldItalic.ttf</string>
       <string>Inter-Regular.ttf</string>
       <string>Inter-Medium.ttf</string>
       <string>Inter-SemiBold.ttf</string>
       <string>Inter-Bold.ttf</string>
       <string>Inter-Light.ttf</string>
   </array>
   ```

5. **Build & Run** on iPhone 15 Pro simulator

## Screen Checklist

| # | Screen | Status |
|---|--------|--------|
| 1 | Splash / Welcome | ✅ Implemented |
| 2 | Sign In | ✅ Implemented |
| 3 | Home Dashboard | ✅ Implemented |
| 4 | Live Darshan | ✅ Implemented |
| 5 | Jain Calendar | ✅ Implemented |
| 6 | Virtual Tour | ✅ Implemented |
| 7 | Donations | ✅ Implemented |
| 8 | Sponsor Bhojanshala | ✅ Implemented |
| 9 | Payment | ✅ Implemented |
| 10 | Volunteer & Seva | ✅ Implemented |
| 11 | Event Detail | ✅ Implemented |
| 12 | Pathshala | ✅ Implemented |
| 13 | News & Newsletters | ✅ Implemented |
| — | Member Profile | ✅ Implemented |
| — | Add/Edit Family Member | ✅ Implemented |
| — | Payment Methods | ✅ Implemented |
| — | Donation History | ✅ Implemented |
| — | Payment Success | ✅ Implemented |

## Architecture

- **MVVM** with `@Observable` macro (iOS 17 Observation framework)
- **SwiftData** for persistence (User, FamilyMember, Donation, PaymentMethod)
- **NavigationStack** + TabView for navigation
- **Zero third-party dependencies**
- Design system in `DesignSystem/` folder

## Backend Integration Points

These are currently mocked and need real backend integration:

- **`AuthService.swift`** — Replace mock `signIn()` with real Auth (e.g., Firebase Auth, custom JWT)
- **`DonationService.swift`** — Replace `processPayment()` with Stripe / PayPal SDK
- **`PanchangService.swift`** — Connect to a real Panchang API for live tithi/sunrise data
- **`MockDataProvider.swift`** — Replace with API calls to fetch events, news, streams
- **Live Darshan** — Replace stub video tiles with actual HLS stream URLs (use `AVPlayer` + `VideoPlayer`)
- **Push Notifications** — Add `UNUserNotificationCenter` setup for event reminders and aarti alerts

## Notes

- App is locked to light mode (`.preferredColorScheme(.light)` at root)
- All user-facing strings should be moved to `Localizable.strings` for Gujarati/Hindi localization
- Haptic feedback is implemented on key interactions
- Progress bar animation runs on appear with 1.2s ease-out
- LIVE dot pulse animation uses easeInOut repeating opacity
- Payment form validates card length (16 digits), expiry, CVV (3 digits), and name
