# CRITICAL BUG FIXES & MISSING FUNCTIONALITY — JCA NY iOS App

## Priority Level: P0 — All items block the demo

This document describes **5 critical issues** in the current SwiftUI build that must be fixed before the demo. Each issue includes the expected behavior, the current broken behavior, and exact implementation instructions.

**Rules for this fix pass:**
- Every button the user can see MUST do something when tapped. No dead buttons.
- Navigation must work end-to-end. If a screen has a back button, it must go back. If a card is tappable, it must push a screen.
- Payment must accept ANY fake credit card number (no real validation — this is a demo). As long as the card number field has 16+ characters, expiry has a value, and CVV has 3 digits, the form is valid.
- After fixing, manually tap through EVERY flow in the simulator and confirm it works before marking done.

---

## Issue 1 — Donation Cause Cards Do Not Navigate to Payment Page

### Current behavior (BROKEN)
User taps a cause card (e.g., "Temple Maintenance", "General Fund") on the Donate tab. **Nothing happens.** The card may highlight but does not push to any payment screen.

### Expected behavior
Tapping ANY cause card on the Donate screen MUST push to a `PaymentView` screen with:
- The cause name pre-filled in the header (e.g., "Temple Maintenance")
- A suggested donation amount pre-filled (editable by the user)
- The user's saved payment method pre-selected (if one exists)
- A working "Confirm Donation" button

### Root cause investigation
Check these common failure points in order:

1. **Missing `NavigationLink` or `.navigationDestination`:**
   Each `CauseCard` likely needs an `onTapGesture` or `Button` that appends a route to the `NavigationPath`. If the `DonateView` is not wrapped in a `NavigationStack`, add one. If it IS in a `NavigationStack` but cause cards don't push, the `.navigationDestination(for:)` modifier is either missing or registered on the wrong view.

2. **Cause card is not a `Button`:**
   If the cause card is just a `VStack` or `HStack` without a tap gesture, wrap it:
   ```swift
   Button {
       // Navigate to payment
       navigationPath.append(PaymentRoute.causePayment(cause: cause))
   } label: {
       CauseCardContent(cause: cause)
   }
   .buttonStyle(.plain)
   ```

3. **Navigation path type mismatch:**
   If you're using `NavigationPath` with a typed route enum, make sure `PaymentRoute` (or whatever route type) conforms to `Hashable` and is registered with `.navigationDestination(for: PaymentRoute.self)`.

### Fix implementation

**Step A:** In `DonateView.swift`, ensure every cause card is tappable and navigates:

```swift
// DonateView.swift
struct DonateView: View {
    @State private var navigationPath = NavigationPath()
    // OR if using a shared path from a parent, use @Binding or @Environment

    var body: some View {
        NavigationStack(path: $navigationPath) {
            ScrollView {
                // ... stats card, header ...

                // Cause list
                ForEach(causes) { cause in
                    Button {
                        navigationPath.append(
                            PaymentDestination(
                                cause: cause.name,
                                suggestedAmount: cause.defaultSuggestedAmount,
                                allowsCustomAmount: true
                            )
                        )
                    } label: {
                        CauseCard(cause: cause)
                    }
                    .buttonStyle(.plain)
                }
            }
            .navigationDestination(for: PaymentDestination.self) { destination in
                PaymentView(
                    cause: destination.cause,
                    amount: destination.suggestedAmount,
                    allowsCustomAmount: destination.allowsCustomAmount
                )
            }
            .navigationDestination(for: ThankYouDestination.self) { destination in
                ThankYouView(donation: destination.donation)
            }
        }
    }
}
```

**Step B:** Create or fix `PaymentDestination`:
```swift
struct PaymentDestination: Hashable {
    let cause: String
    let suggestedAmount: Decimal
    let allowsCustomAmount: Bool
}
```

**Step C:** In `PaymentView`, the amount field MUST be editable. The user types in their desired amount. For "General Fund" the amount starts at $0 and the user enters their own. For other causes it starts at the suggested amount but the user can change it.

**Step D:** The "Confirm Donation" button in `PaymentView` must:
1. Show a loading spinner for 2 seconds
2. Create a `Donation` record in SwiftData
3. Update the user's `totalDonated`
4. Navigate to `ThankYouView` with the donation details

**Step E:** `ThankYouView` must have a "Back to Home" button that pops the entire navigation stack back to root AND switches to the Home tab.

### Verification
After fixing, test these exact flows:
- Donate tab → tap "General Fund" → PaymentView appears with $0 amount → enter $108 → tap Confirm → loading → ThankYouView → tap Back to Home → lands on Home tab
- Donate tab → tap "Temple Maintenance" → PaymentView appears with $251 → tap Confirm → loading → ThankYouView
- Donate tab → tap "Sponsor Bhojanshala" → BhojanshalaView → select meal/date → Continue → PaymentView → Confirm → ThankYouView

---

## Issue 2 — Today's Sponsor Banner Missing from Home Page + Live Demo Payment Reflection

### Current behavior (BROKEN)
The Home page does not show any sponsor highlight banner. The HTML mockup has a gold-gradient banner reading "Today's Swamivatsalya — Sponsored by Sunil Jain — Bhaut Bhaut Anumodana" positioned between the Panchang card and the quick actions.

### Expected behavior
1. A `SponsorHighlightBanner` view appears on the Home page between the Panchang card and the quick action scroll.
2. On first launch, it shows a **default placeholder**: "Sponsored by Sunil Jain" with "Bhaut Bhaut Anumodana".
3. **When the user completes a donation through the payment flow** (any cause, any amount, any fake card number), the sponsor banner UPDATES IN REAL-TIME to show the current user's name as the sponsor. For example, after Manan Shah donates $251 to Temple Maintenance, the banner should read: "Sponsored by **Manan Shah**" with "Bhaut Bhaut Anumodana".

### Implementation

**Step A:** Create the banner view:

```swift
struct SponsorHighlightBanner: View {
    let sponsorName: String
    let occasion: String  // "Swamivatsalya"
    let blessing: String  // "Bhaut Bhaut Anumodana"

    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            VStack(alignment: .leading, spacing: 3) {
                Text("TODAY'S SWAMIVATSALYA")
                    .font(.custom("Inter-Bold", size: 9))
                    .tracking(1.35)
                    .foregroundStyle(Color.jcaGoldDeep)
                
                HStack(spacing: 0) {
                    Text("Sponsored by ")
                        .font(.custom("Fraunces-Regular", size: 13))
                    Text(sponsorName)
                        .font(.custom("Fraunces-SemiBold", size: 13))
                        .foregroundStyle(Color.jcaCrimson)
                }
                
                Text(blessing)
                    .font(.custom("Fraunces-Italic", size: 11))
                    .foregroundStyle(Color.jcaGoldDeep)
            }
            .padding(.trailing, 30)
            
            Spacer()
            
            Text("🙏")
                .font(.system(size: 22))
                .opacity(0.7)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(
            LinearGradient(
                colors: [Color(hex: "#fff7e6"), Color(hex: "#fde8c4")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .overlay(alignment: .leading) {
            LinearGradient(
                colors: [Color.jcaGold, Color.jcaGoldDeep],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(width: 3)
        }
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color.jcaGold.opacity(0.4), lineWidth: 0.5)
        )
        .shadow(color: Color.jcaGold.opacity(0.15), radius: 5, y: 3)
        .padding(.horizontal, 24)
        .padding(.top, 14)
    }
}
```

**Step B:** Store the current sponsor in a shared observable:

```swift
@Observable
final class SponsorState {
    var currentSponsor: String = "Sunil Jain"   // default placeholder
    var occasion: String = "Swamivatsalya"
    var blessing: String = "Bhaut Bhaut Anumodana"
}
```

Inject this as an `@Environment` value or use a singleton.

**Step C:** In the payment confirmation logic (`PaymentView` or `DonationService`), after a successful donation:

```swift
// After donation is confirmed and saved to SwiftData:
SponsorState.shared.currentSponsor = user.name  // e.g., "Manan Shah"
```

**Step D:** In `HomeView`, add the banner between Panchang and quick actions:

```swift
// After PanchangCard
SponsorHighlightBanner(
    sponsorName: sponsorState.currentSponsor,
    occasion: sponsorState.occasion,
    blessing: sponsorState.blessing
)

// Quick actions scroll (NO section header above it — remove "Quick Actions" header if present)
```

### Payment acceptance rules (CRITICAL FOR DEMO)

The payment form must accept ANY input as long as:
- Card number has at least 13 characters (after stripping spaces)
- Expiry field is not empty
- CVV has 3 characters
- Amount is greater than $0

**DO NOT** add Luhn validation, real card brand detection, or any other validation that would reject a fake number like `4111 1111 1111 1111` or `1234 5678 9012 3456`. This is a demo app.

```swift
var isFormValid: Bool {
    let strippedCardNumber = cardNumber.replacingOccurrences(of: " ", with: "")
    return strippedCardNumber.count >= 13
        && !expiry.isEmpty
        && cvv.count >= 3
        && amount > 0
}
```

### Verification
- Launch app → Home tab → see banner "Sponsored by Sunil Jain"
- Donate tab → tap General Fund → enter $108 → enter fake card `1234567890123456`, expiry `12/28`, CVV `123` → tap Confirm → loading → Thank You
- Navigate back to Home tab → banner now reads "Sponsored by **Manan Shah**" (or whatever the logged-in user's name is)

---

## Issue 3 — Multiple UI/Navigation Bugs

### 3a. Top-right avatar on Home does NOT navigate to Profile

**Current behavior:** Tapping the avatar circle (with the user's initial) on the top-right of the Home screen does nothing.

**Expected behavior:** Tapping it switches the selected tab to the Profile tab.

**Fix:**
```swift
// In HomeView, the avatar must be a Button:
Button {
    UIImpactFeedbackGenerator(style: .light).impactOccurred()
    appState.selectedTab = .profile  // Switch to profile tab
} label: {
    ZStack(alignment: .bottomTrailing) {
        Circle()
            .fill(LinearGradient(colors: [.jcaCrimson, .jcaCrimsonDeep], startPoint: .topLeading, endPoint: .bottomTrailing))
            .frame(width: 42, height: 42)
            .overlay(
                Text(user.avatarInitial)
                    .font(.custom("Fraunces-SemiBold", size: 18))
                    .foregroundStyle(Color.jcaCream)
            )
        
        // Online indicator dot
        Circle()
            .fill(Color.jcaGold)
            .frame(width: 12, height: 12)
            .overlay(Circle().stroke(Color.jcaCream, lineWidth: 2))
    }
}
.buttonStyle(.plain)
```

**Pre-requisite:** The `MainTabView`'s `TabView(selection:)` must use a `@Bindable` or `@Binding` to `appState.selectedTab`. If `AppState` doesn't exist yet:

```swift
@Observable
final class AppState {
    var selectedTab: AppTab = .home
}

enum AppTab: Int, Hashable {
    case home = 0
    case calendar = 1
    case donate = 2
    case community = 3
    case profile = 4
}
```

Put `@State private var appState = AppState()` in `RootView` and pass it down via `.environment(appState)`.

### 3b. Gallery page alignment issues

**Problem:** The Gallery page layout is misaligned — content may be overflowing, images may not be clipped, or spacing is inconsistent.

**Fix checklist:**
- Every `AsyncImage` MUST have `.clipped()` after `.aspectRatio(contentMode: .fill)` — without this, images overflow their containers.
- The main `ScrollView` must have `.padding(.bottom, 20)` at the end of its content to prevent content from being hidden under the tab bar.
- Album cards in the horizontal scroll must have `width: 120pt` fixed — use `.frame(width: 120)`.
- The masonry/photo grid must have `24pt` horizontal padding — `.padding(.horizontal, 24)`.
- Check that all `RoundedRectangle` clip shapes match the container's corner radius.
- Test on iPhone 15 Pro AND iPhone SE 3rd gen simulators to catch overflow issues.

### 3c. Gallery link missing from Home page

**Problem:** There is no way to access the Gallery from the Home screen.

**Fix:** Add a "Gallery" quick action card in the Home page's horizontal quick action scroll:

```swift
QuickActionCard(
    icon: "photo.on.rectangle.angled",  // SF Symbol
    name: "Gallery",
    meta: "Photos & videos",
    variant: .gold
) {
    // Navigate to GalleryView
    // Option A: If Gallery is in the Community tab, switch tab + push
    appState.selectedTab = .community
    // Then push GalleryView onto the community nav stack
    
    // Option B: If Gallery is a standalone push from Home
    homeNavigationPath.append(HomeDestination.gallery)
}
```

Register the navigation destination in the Home tab's `NavigationStack`:
```swift
.navigationDestination(for: HomeDestination.self) { dest in
    switch dest {
    case .gallery: GalleryView()
    case .liveDarshan: LiveDarshanView()
    // ... other destinations
    }
}
```

### 3d. ALL buttons must be functional

Do a full audit of every `Button` and tappable element in the app. The rule is simple:

**If it looks tappable, it MUST do something.**

Common offenders to check:
- "See all" links on the Home page → at minimum, switch to the relevant tab
- Event cards on Home → must push to `EventDetailView`
- Quick action cards → must navigate to their target screen
- "RSVP" button on EventDetailView → show a confirmation alert or toggle state
- "+ Add" on Profile family section → must open the Add Family Member sheet
- Family member rows → must open the Edit Family Member sheet
- Tab bar items → must switch tabs
- Back buttons → must pop navigation
- "Download Receipt" on ThankYouView → present a share sheet with receipt text (can be plain text for demo)
- "Share" on ThankYouView → present iOS share sheet
- "Back to Home" on ThankYouView → pop to root + switch to Home tab

### Verification for Issue 3
- Tap avatar on Home → Profile tab activates
- Tap Gallery quick action on Home → Gallery screen appears
- Tap every quick action → each navigates somewhere (no dead buttons)
- Tap an event card → EventDetailView opens
- Tap RSVP → visual feedback (alert, checkmark, or state change)
- Gallery: images are properly clipped, no overflow, consistent spacing

---

## Issue 4 — General Fund Must Be First + Custom Amount Entry

### Current behavior (BROKEN)
"General Fund" is the last cause card in the Donate page. All causes pre-fill a fixed amount that the user cannot change.

### Expected behavior
1. **"General Fund" must be the FIRST cause card** in the list, not the last.
2. On the Payment page, the amount field must be an **editable `TextField`** for ALL causes, not just General Fund.
3. For "General Fund", the initial amount is `$0` and the user MUST enter their own amount.
4. For other causes, the initial amount is the suggested default but the user CAN change it by tapping the field and typing a new number.

### Fix

**Step A:** Reorder the causes array:
```swift
// In MockDataProvider or wherever causes are defined:
let causes: [DonationCategory] = [
    DonationCategory(name: "General Fund",          defaultAmount: 0,     description: "Where it's needed most", ...),
    DonationCategory(name: "Temple Maintenance",    defaultAmount: 251,   description: "Marble, lighting, daily upkeep", ...),
    DonationCategory(name: "Sponsor Bhojanshala",   defaultAmount: 1251,  description: "Provide a community meal", ...),
    DonationCategory(name: "Pathshala Education",   defaultAmount: 151,   description: "Books, scholars, classes", ...),
    DonationCategory(name: "Matching Gifts Program",defaultAmount: 0,     description: "Double via employer", ...),
]
```

**Step B:** In `PaymentView`, replace the static amount display with an editable field:

```swift
// Amount section in PaymentView
VStack(alignment: .leading, spacing: 4) {
    Text("DONATION AMOUNT")
        .font(.custom("Inter-Bold", size: 10))
        .tracking(1.35)
        .foregroundStyle(Color.jcaGoldLight)
    
    Text(cause)
        .font(.custom("Fraunces-Italic", size: 14))
        .foregroundStyle(.white.opacity(0.9))
    
    HStack(alignment: .firstTextBaseline, spacing: 4) {
        Text("$")
            .font(.custom("Fraunces-Medium", size: 24))
            .foregroundStyle(.white)
        
        TextField("0", text: $amountString)
            .font(.custom("Fraunces-Medium", size: 38))
            .foregroundStyle(.white)
            .keyboardType(.decimalPad)
            .tint(.jcaGoldLight)
    }
}
```

**Step C:** Convert the string to `Decimal` for processing:
```swift
@State private var amountString: String

init(cause: String, suggestedAmount: Decimal, ...) {
    self.cause = cause
    // If suggested amount is 0, start with empty string so placeholder shows
    _amountString = State(initialValue: suggestedAmount > 0 ? "\(suggestedAmount)" : "")
}

private var parsedAmount: Decimal {
    Decimal(string: amountString.replacingOccurrences(of: ",", with: "")) ?? 0
}

// Update isFormValid to use parsedAmount:
var isFormValid: Bool {
    parsedAmount > 0 && /* card validation ... */
}
```

### Verification
- Donate tab → "General Fund" is the first card in the list
- Tap General Fund → Payment page shows $0 / empty → type "250" → amount reads $250 → Confirm works
- Tap Temple Maintenance → Payment shows $251 → change to $500 → Confirm works with $500
- Tap any other cause → amount is pre-filled but editable

---

## Issue 5 — Profile Navigation from Home + Member ID Placement

### 5a. "View Profile" element on Home must navigate to Profile tab

**Problem:** There may be a "View Profile" link or section on the Home page that does not navigate anywhere.

**Fix:** Every element on the Home page that says "Profile", shows the user's avatar, or implies navigation to the user's account MUST call:
```swift
appState.selectedTab = .profile
```

This includes:
- The top-right avatar circle (covered in Issue 3a)
- Any "View Profile" text link
- The user's name if it's tappable

### 5b. Member ID must be UNDER the user name, not beside it

**Current behavior:** The member ID chip ("ID 04812") is positioned to the right of the user's name on the same line, or missing entirely.

**Expected behavior:** The member ID appears on a **separate line directly below** the user name.

**Fix in `HomeView`:**
```swift
// Home greeting area
VStack(alignment: .leading, spacing: 2) {
    Text("Jai Jinendra 🙏")
        .font(.custom("Inter-SemiBold", size: 12))
        .tracking(0.6)
        .foregroundStyle(Color.jcaMuted)
        .textCase(.uppercase)
    
    Text(user.name)  // "Manan Shah"
        .font(.custom("Fraunces-Medium", size: 26))
        .foregroundStyle(Color.jcaInk)
        .tracking(-0.3)
    
    // Member ID on its OWN line, below the name
    HStack(spacing: 4) {
        Circle()
            .fill(Color.jcaGold)
            .frame(width: 4, height: 4)
        Text("ID \(user.memberID)")
            .font(.custom("Inter-SemiBold", size: 10))
            .foregroundStyle(Color.jcaCrimson)
    }
    .padding(.horizontal, 8)
    .padding(.vertical, 3)
    .background(Color.jcaCrimson.opacity(0.08))
    .clipShape(Capsule())
}
```

### Verification
- Home page: name "Manan Shah" on one line, "· ID 04812" pill on the line below
- Tap the avatar → switches to Profile tab
- Tap any "View Profile" link → switches to Profile tab

---

## Pre-Submission Checklist

Before marking this fix pass as complete, manually walk through EVERY flow:

### Navigation flows (must all work):
- [ ] Home → tap avatar → Profile tab
- [ ] Home → tap Gallery quick action → Gallery screen
- [ ] Home → tap Donate quick action → Donate tab
- [ ] Home → tap Live Darshan quick action → Live Darshan screen
- [ ] Home → tap Calendar quick action → Calendar tab
- [ ] Home → tap Volunteer quick action → Volunteer screen
- [ ] Home → tap Bhojanshala quick action → Bhojanshala screen
- [ ] Home → tap event card → Event Detail screen
- [ ] Donate → tap General Fund (first card) → Payment (amount empty/editable)
- [ ] Donate → tap Temple Maintenance → Payment (amount $251, editable)
- [ ] Donate → tap Sponsor Bhojanshala → Bhojanshala → meal/date → Payment
- [ ] Donate → tap Pathshala Education → Payment (amount $151, editable)
- [ ] Payment → enter fake card → tap Confirm → loading 2s → Thank You
- [ ] Thank You → tap Back to Home → Home tab, nav stack cleared
- [ ] Profile → tap family member → edit sheet with DOB picker
- [ ] Profile → tap "+ Add" → add family member sheet

### Data flows (must work):
- [ ] Home shows sponsor banner "Sponsored by Sunil Jain" on first launch
- [ ] After making a donation, sponsor banner updates to current user's name
- [ ] After making a donation, Profile stats "Donated" amount increases
- [ ] After adding a family member, it appears in the Profile family list

### Visual checks:
- [ ] Member ID pill is BELOW the name, not beside it
- [ ] General Fund is the FIRST cause card
- [ ] Gallery images are properly clipped (no overflow)
- [ ] No dead buttons anywhere in the app

---

## What NOT to Do

- Do not add real credit card validation (Luhn, BIN lookup, etc.) — accept any fake number
- Do not change the design system (colors, fonts, spacing, corner radii)
- Do not remove any existing screens or features
- Do not add new features beyond what's described here — this is a bug fix pass only
- Do not leave any `// TODO` or `fatalError()` in navigation or button handlers
- Do not use `EmptyView()` as a navigation destination — every destination must render a real screen
- Do not skip the 2-second loading delay on payment confirmation — it's important for the demo feel

Fix these 5 issues, verify with the checklist, and confirm all flows work end-to-end.
