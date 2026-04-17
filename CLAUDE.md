# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

JCA NY is a production-quality SwiftUI iOS app for the Jain Center of America (New York) community. All 61 Swift source files live in `JCANY/`. The project has **zero third-party dependencies** — no CocoaPods, SPM packages, or external frameworks.

## Build Setup (macOS + Xcode Required)

This is a native Xcode project. There is no CLI build system. To build:

1. **Xcode 15+**, **macOS 14+**, **iOS 17.0 SDK** required.
2. Create a new Xcode project: iOS → App, Product Name `JCANY`, Interface `SwiftUI`, Storage `SwiftData`.
3. Delete the default template files (`ContentView.swift`, `Item.swift`, the generated `JCANYApp.swift`).
4. Add all subfolders from `JCANY/` via File → Add Files: `App`, `DesignSystem`, `Models`, `Services`, `ViewModels`, `Views`, `Resources`.
5. Set deployment target to **iOS 17.0** (target General tab).
6. Download **Fraunces** and **Inter** from Google Fonts, place `.ttf` files in `Resources/Fonts/`, and register them under `UIAppFonts` in `Info.plist` (see `JCANY/README.md` for the exact list).

**Key shortcuts:**
- `Cmd+B` — build
- `Cmd+R` — run on simulator (use iPhone 15 Pro)
- `Shift+Cmd+K` — clean build folder

See `running.md` for step-by-step setup from scratch, and `JCANY/README.md` for Info.plist font registration XML.

## Architecture

**Pattern:** MVVM with iOS 17's `@Observable` macro (not `ObservableObject`/Combine).

**Navigation:** `MainTabView` hosts 5 tabs, each with its own `NavigationStack`. Auth is gated by `RootView` which shows `SplashView`/`SignInView` until authenticated.

**State flow:**
- ViewModels are `@Observable final class` singletons passed via `.environment()`
- Views read SwiftData models directly using `@Query`
- No Combine; pure `async/await` throughout

**5 tabs:** Home → Calendar → Donate → Community (Pathshala / Volunteer / News) → Profile

### Key Architectural Files

| File | Role |
|------|------|
| `App/JCANYApp.swift` | `@main` entry, sets up `ModelContainer`, enforces `.preferredColorScheme(.light)` |
| `App/RootView.swift` | Auth gate; calls `MockDataProvider.seedIfNeeded()` on first launch |
| `DesignSystem/Colors.swift` | All color constants (`Color.jcaCrimson`, `.jcaGold`, `.jcaCream`, `.jcaInk`, `.jcaMuted`) + `Color(hex:)` initializer |
| `DesignSystem/Typography.swift` | `JCAFont` enum + `Font.fraunces()` / `Font.inter()` extensions |
| `Services/AuthService.swift` | `@Observable` singleton — mocked, any credentials work, 1s simulated delay |
| `Services/DonationService.swift` | Mocked payment with 2s delay |
| `Services/MockDataProvider.swift` | Seeds all initial data on first launch |
| `ViewModels/DonationFlowViewModel.swift` | Shared across Donate → Bhojanshala → Payment → Success flow; owns navigation path, card validation, formatters |

### Persistent Models (SwiftData `@Model`)

`User`, `FamilyMember`, `PaymentMethod`, `Donation` — all use `@Relationship(deleteRule: .cascade)`.

### Non-Persistent Value Types

`Event`, `Shrine`, `LiveStream`, `ParvaDay`, `VolunteerOpportunity`, `PathshalaLesson`, `NewsItem` — plain structs, sourced from `MockDataProvider`.

### Design System Usage

```swift
// Typography
Text("Title").font(.fraunces(size: 20, weight: .semibold))
Text("Body").font(.inter(size: 14, weight: .regular))

// Color
.foregroundStyle(Color.jcaCrimson)
.background(Color.jcaCream)
```

Decorative views in `DesignSystem/Ornaments/`: `JainSwastikaView` (Path-drawn), `MandalaBackgroundView`, `OrnamentDivider`, `DeityGlowView`.

## Critical Implementation Notes

- **Light mode only** — `.preferredColorScheme(.light)` at root; do not add dark mode support.
- **Custom fonts are required** — app will fall back to system fonts without them, but the design degrades.
- **Payment validation rules:** card number 16 digits, expiry MM/YY, CVV 3 digits, cardholder name non-empty.
- **Donation flow navigation** is managed entirely by `DonationFlowViewModel.navigationPath` — do not add ad-hoc `NavigationLink`s in this flow.

## Backend Integration Points (Currently Mocked)

Replace these for production:

- `AuthService.signIn()` → Firebase Auth / custom JWT
- `DonationService.processPayment()` → Stripe / PayPal SDK
- `PanchangService.today()` → real Panchang API
- `MockDataProvider` → API calls for events, news, streams
- Live Darshan tiles → HLS streams via `AVPlayer` + `VideoPlayer`
- Push notifications → `UNUserNotificationCenter` for event/aarti reminders

## Source of Truth for Design

- `jca-ny-app.html` — visual design mockup
- `claude-code-prompt.md` — exhaustive functional spec (screens, interactions, acceptance criteria)
