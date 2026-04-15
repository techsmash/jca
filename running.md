# How to Build & Run the JCA NY App on Your MacBook

This guide assumes **zero Swift or Xcode knowledge**. Follow every step in order.

---

## PART 1 — Check Your Mac

### Step 1 — Check macOS Version
1. Click the  Apple logo in the top-left corner of your screen
2. Click **"About This Mac"**
3. Look at the macOS version number
4. **You need macOS 14 (Sonoma) or higher**
   - If you have an older version, click **"Software Update"** and update first

---

## PART 2 — Install Xcode

### Step 2 — Install Xcode from the App Store
1. Open the **App Store** on your Mac (blue icon with "A" in your Dock)
2. In the search bar at the top, type: `Xcode`
3. Click the first result — it says **"Xcode"** by Apple Inc.
4. Click **"Get"** then **"Install"**
   - ⚠️ Xcode is **~15 GB** — this download will take 20–60 minutes depending on your internet
   - Keep your Mac plugged in and let it finish
5. Once installed, **open Xcode** (it's in your Applications folder or Launchpad)
6. The first time you open it, it will ask to install additional components — click **"Install"** and wait

### Step 3 — Accept the License Agreement
1. Xcode may show a license agreement window
2. Click **"Agree"**
3. It may ask for your Mac password — enter it

---

## PART 3 — Copy Files to Your Mac

### Step 4 — Transfer the JCANY Folder to Your Mac

You already have the `JCANY` folder at:
```
C:\Users\manan\Desktop\jnc_app\JCANY\
```

Since you're on Windows and need to run this on your MacBook, transfer the folder:

**Option A — USB Drive:**
1. Copy the entire `jnc_app` folder from your Windows Desktop to a USB drive
2. Plug the USB drive into your MacBook
3. Copy `jnc_app` to your Mac's Desktop

**Option B — Google Drive / iCloud / Dropbox:**
1. Upload the entire `jnc_app` folder to Google Drive / Dropbox
2. On your MacBook, download and extract it to your Desktop

**Option C — AirDrop (if both devices are nearby):**
1. Right-click the `jnc_app` folder on Windows → you'll need to use another method
2. Use the USB or cloud option instead

After transferring, on your **MacBook** you should have:
```
~/Desktop/jnc_app/
    JCANY/              ← the Swift source files
    jca-ny-app.html     ← the HTML mockup
    claude-code-prompt.md
    running.md          ← this file
```

---

## PART 4 — Download the Required Fonts

The app uses two special fonts that must be downloaded manually (they're Google Fonts).

### Step 5 — Download Fraunces Font
1. On your MacBook, open **Safari** or any browser
2. Go to: `https://fonts.google.com/specimen/Fraunces`
3. Click the **"Download family"** button (top right — looks like a download arrow icon)
4. A `.zip` file called `Fraunces.zip` will download to your Downloads folder
5. Double-click the `.zip` file to extract it
6. You'll get a folder called `Fraunces` with many `.ttf` files inside

### Step 6 — Download Inter Font
1. Go to: `https://fonts.google.com/specimen/Inter`
2. Click the **"Download family"** button
3. A `.zip` file called `Inter.zip` will download
4. Double-click to extract it
5. You'll get a folder called `Inter` with `.ttf` files inside

### Step 7 — Move Fonts into the Project
1. On your MacBook, open **Finder**
2. Navigate to: `Desktop → jnc_app → JCANY → Resources → Fonts`
3. From your downloaded Fraunces folder, copy these specific files into the `Fonts` folder:
   - `Fraunces-Regular.ttf`
   - `Fraunces-Italic.ttf`
   - `Fraunces-Light.ttf`
   - `Fraunces-LightItalic.ttf`
   - `Fraunces-Medium.ttf`
   - `Fraunces-SemiBold.ttf`
   - `Fraunces-SemiBoldItalic.ttf`

   **Note:** If you see files named slightly differently (e.g., `Fraunces[SOFT,opsz,wght].ttf`), that's the variable font. Copy it anyway and name it `Fraunces-Regular.ttf` for now. The app will fall back gracefully.

4. From your downloaded Inter folder, copy these specific files:
   - `Inter-Regular.ttf` (or `Inter[slnt,wght].ttf` — rename to `Inter-Regular.ttf`)
   - `Inter-Medium.ttf`
   - `Inter-SemiBold.ttf`
   - `Inter-Bold.ttf`
   - `Inter-Light.ttf`

   **Note:** If you only find a single variable font file like `Inter[slnt,wght].ttf`, just copy that one file and rename it to `Inter-Regular.ttf`. The app will still display text correctly.

---

## PART 5 — Create the Xcode Project

### Step 8 — Open Xcode and Create a New Project
1. Open **Xcode** (from Applications or Spotlight — press `Cmd + Space`, type "Xcode")
2. In the welcome screen, click **"Create New Project..."**
   - If you don't see the welcome screen, go to menu: **File → New → Project...**

### Step 9 — Choose the Project Template
1. At the top of the window, make sure **"iOS"** tab is selected
2. Click on **"App"** (the first option in the Application section)
3. Click **"Next"**

### Step 10 — Fill in Project Details
Fill in exactly these values:
- **Product Name:** `JCANY`
- **Team:** Select your Apple ID, or select "None" — either is fine for local testing
- **Organization Identifier:** `org.jcany` (or anything like `com.yourname.jcany`)
- **Bundle Identifier:** Will auto-fill based on above — leave it as-is
- **Interface:** `SwiftUI` ← make sure this says SwiftUI, not Storyboard
- **Language:** `Swift`
- **Storage:** `SwiftData` ← check this checkbox
- **Include Tests:** uncheck both (optional, not needed)

Click **"Next"**

### Step 11 — Choose Save Location
1. A folder browser will appear
2. Navigate to your **Desktop**
3. Click **"Create"**
4. Xcode will open with a basic template project

---

## PART 6 — Add the Source Files to Xcode

### Step 12 — Delete the Default Template Files
Xcode created some default files we don't need. Delete them:

1. In the left sidebar (called the **Navigator**), you'll see a file tree
2. Find and click on `ContentView.swift`
3. Press the **Delete** key on your keyboard
4. A dialog will appear — click **"Move to Trash"**
5. Find `Item.swift` (the SwiftData sample model)
6. Delete it the same way — **"Move to Trash"**

**Your app file** (`JCANYApp.swift`) was auto-created — delete it too:
7. Find `JCANYApp.swift` in the Navigator
8. Delete it → **"Move to Trash"**

### Step 13 — Add the JCANY Source Folder
Now we add all 61 Swift files at once:

1. In Xcode's left Navigator panel, click on the **top-level `JCANY` folder** (the one with the blue app icon at the very top of the tree)
2. Go to menu: **File → Add Files to "JCANY"...**
   - Or right-click on the `JCANY` folder in the Navigator → **"Add Files to JCANY..."**
3. In the file browser that opens, navigate to:
   `Desktop → jnc_app → JCANY`
4. You'll see all the subfolders: `App`, `DesignSystem`, `Models`, etc.
5. **Select all subfolders at once:**
   - Click `App`
   - Then hold `Cmd` and click `DesignSystem`, `Models`, `Services`, `ViewModels`, `Views`, `Resources`
   - (Select all 7 folders)
6. At the bottom of the file browser, make sure these options are set:
   - ✅ **"Copy items if needed"** — check this
   - **"Added folders"** → select **"Create groups"**
7. Click **"Add"**

Xcode will import all 61 Swift files. You'll see them appear in the Navigator on the left. This might take a few seconds.

---

## PART 7 — Add Fonts to the Project

### Step 14 — Add Font Files to Xcode
The font files need to be added to the Xcode project so they compile into the app:

1. In the Xcode Navigator, find the `Resources` → `Fonts` folder you just added
2. Check that the `.ttf` files you copied in Step 7 are showing there
3. If the `Fonts` folder is empty or missing the `.ttf` files:
   - Right-click on the `Fonts` folder in Xcode Navigator
   - Click **"Add Files to JCANY..."**
   - Navigate to `Desktop → jnc_app → JCANY → Resources → Fonts`
   - Select all the `.ttf` files
   - Check ✅ "Copy items if needed"
   - Click **"Add"**

### Step 15 — Register Fonts in Info.plist
This tells iOS to load the fonts:

1. In the Xcode Navigator, click on the blue `JCANY` app icon at the very top
2. This opens the **project settings** in the main editor area
3. Click on your app target (called `JCANY`) under "Targets" on the left
4. Click the **"Info"** tab at the top
5. You'll see a list of keys. Hover over any row and click the **"+"** button that appears
6. Type `Fonts provided by application` and press Enter
   - This creates a key called `UIAppFonts`
7. Click the arrow/triangle next to it to expand it
8. You'll see `Item 0` — click the **"+"** button to add items, one for each font:

Add these entries (click "+" for each one, then type the filename):
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

**Shortcut:** Instead of the GUI, you can edit the `Info.plist` file directly:
1. In the Navigator, find `Info.plist` (it's inside the `JCANY` folder)
2. Right-click it → **"Open As"** → **"Source Code"**
3. Find the line `</dict>` near the end of the file (the last `</dict>` before `</plist>`)
4. Paste this block **before** that last `</dict>`:

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

5. Press `Cmd + S` to save

---

## PART 8 — Fix the Build Target

### Step 16 — Set the Deployment Target
1. Click the blue `JCANY` app icon at the top of the Navigator
2. Under **Targets**, click `JCANY`
3. Click the **"General"** tab
4. Find **"Minimum Deployments"** section
5. Change the iOS version to **"iOS 17.0"** (click the dropdown and select 17.0)

### Step 17 — Check the App Entry Point
Because we deleted the default `JCANYApp.swift` and added our own, Xcode needs to know which file is the entry point:

1. Still in the `General` tab, scroll down to find **"App Icons and Launch Screen"** or look for where the entry point is specified
2. Actually, our `JCANYApp.swift` file has the `@main` attribute which tells Swift it's the entry point — this should work automatically

---

## PART 9 — Build and Run

### Step 18 — Select the iPhone Simulator
1. At the very top of Xcode, you'll see a toolbar with a ▶ Play button
2. Next to it, there's a device selector (might say something like "My Mac" or a device name)
3. Click on it — a dropdown menu appears
4. Under **"iOS Simulators"**, select **"iPhone 15 Pro"**
   - If you don't see iPhone 15 Pro, select any iPhone with iOS 17

### Step 19 — Build the App
1. Press `Cmd + B` (Command + B) to build the project
2. Xcode will compile all the Swift files — watch the progress bar at the top
3. This first build takes 2–5 minutes
4. If the build succeeds, you'll see ✅ **"Build Succeeded"** in the top bar
5. If there are errors, see the **Troubleshooting** section below

### Step 20 — Run the App
1. Press `Cmd + R` (Command + R) or click the ▶ Play button
2. The iPhone simulator will launch (it looks like an iPhone on your screen)
3. The app will install and open automatically
4. You should see the **JCA NY splash screen** with the crimson background!

---

## PART 10 — Using the App

### What you can test:

**Splash Screen** → tap **"Sign In"**

**Sign In Screen:**
- Enter any email (e.g., `test@test.com`)
- Enter any password (e.g., `password`)
- Tap **"Sign In"** — it will work (all credentials accepted for the mock)

**Home Screen:**
- See Panchang (today's Hindu calendar info)
- Tap quick action cards to navigate
- Tap events to see Event Detail

**Tab Bar (bottom):**
- 🏠 **Home** — Dashboard with events and quick actions
- 📅 **Calendar** — Monthly Jain calendar with parva (festival) days
- ❤️ **Donate** — Donation causes and goal progress
- 💬 **Community** — Pathshala lessons, Volunteer opportunities, News
- 👤 **Profile** — Your profile, family members, settings

**Donation Flow:**
1. Tap **Donate** tab
2. Tap **"Sponsor Bhojanshala"** → select a meal type → select a date → tap Continue
3. Select **"Credit / Debit"** → fill in any card details → tap Pay
4. See the payment success screen!

**Family Members:**
1. Tap **Profile** tab
2. Tap the **"+ Add"** button next to Family Members
3. Fill in a name, relation, and date of birth → Save
4. The new member appears in your list

**Live Darshan:**
1. From Home, tap the **"Live Darshan"** quick action card
2. See the featured stream, aarti schedule

---

## TROUBLESHOOTING

### Problem: "Build Failed" with errors

**Error: "Cannot find type 'X' in scope"**
- This usually means a file didn't get added to the project
- Check the Navigator to make sure all folders (App, DesignSystem, Models, Services, ViewModels, Views) are present
- Re-add any missing files using File → Add Files

**Error: "No such module 'SwiftData'"**
- Make sure your deployment target is iOS 17.0 (Step 16)

**Error: Multiple errors about fonts**
- Fonts are optional for building — the app will use system fonts as fallback
- You can still run the app without custom fonts

**Error about "Redeclaration" or duplicate symbols**
- You may have the default `ContentView.swift` or `Item.swift` still in the project
- Delete them (Step 12) and rebuild

**Too many errors to count:**
- Try: **Product → Clean Build Folder** (Shift + Cmd + K), then build again

---

### Problem: Simulator doesn't open
- Check that the simulator is installed: **Xcode → Settings → Platforms** → download iOS 17
- Try a different simulator (e.g., iPhone 14 instead of iPhone 15 Pro)

### Problem: App crashes immediately
- Click the ▶ button to run again
- Look at the debug output at the bottom of Xcode (the console) for red error messages
- Most likely cause: SwiftData model issue — try **Product → Clean Build Folder** and re-run

### Problem: Fonts look wrong (using system font)
- The custom fonts (Fraunces, Inter) may not be registered
- Double-check Step 15 — make sure font filenames in Info.plist match exactly
- The app still functions correctly with system fonts

---

## QUICK REFERENCE

| Action | Keyboard Shortcut |
|--------|------------------|
| Build project | `Cmd + B` |
| Run on simulator | `Cmd + R` |
| Stop running | `Cmd + .` |
| Clean build folder | `Shift + Cmd + K` |
| Show/hide Navigator | `Cmd + 1` |
| Open file quickly | `Cmd + Shift + O` |

---

## FILE STRUCTURE OVERVIEW (for reference)

```
JCANY/
├── App/
│   ├── JCANYApp.swift          ← App entry point (@main)
│   └── RootView.swift          ← Decides: show Splash or Main app
├── DesignSystem/               ← Colors, fonts, spacing, ornaments
├── Models/                     ← Data structures (User, Donation, etc.)
├── Services/                   ← Mock data, auth, payment logic
├── ViewModels/                 ← Business logic for each screen
├── Views/                      ← All 13+ screens
│   ├── Splash/                 ← Welcome screen
│   ├── Auth/                   ← Sign In
│   ├── Home/                   ← Dashboard
│   ├── Darshan/                ← Live streams
│   ├── Calendar/               ← Jain calendar
│   ├── VirtualTour/            ← Temple tour
│   ├── Donate/                 ← Donations + Payment
│   ├── Events/                 ← Event detail
│   ├── Pathshala/              ← Education
│   ├── News/                   ← News feed
│   ├── Volunteer/              ← Seva opportunities
│   ├── Profile/                ← Member profile
│   └── Shared/                 ← Tab bar, buttons, reusable views
└── Resources/
    └── Fonts/                  ← Put your .ttf files here
```

---

*Need help? Share a screenshot of any error message and the exact step where you got stuck.*
