# 🚀 MeDrop - Xcode Project Setup Guide

## Quick Start

I've prepared all the source files in the `MeDropApp/` directory. Follow these steps to create the Xcode project:

### Step 1: Create New Xcode Project

1. **Open Xcode** (it should have just opened)
2. Click **"Create New Project"**
3. Select **macOS** → **App**
4. Configure:
   - **Product Name**: `MeDrop`
   - **Team**: Your Apple ID (or None for local development)
   - **Organization Identifier**: `com.medrop`
   - **Bundle Identifier**: `com.medrop.app`
   - **Interface**: **SwiftUI**
   - **Language**: **Swift**
   - **Use Core Data**: ❌ (unchecked)
   - **Include Tests**: ❌ (unchecked)
5. **Save Location**: `/Users/amal/code/MEDROP/`

### Step 2: Replace Default Files

1. **Delete** the default `MeDropApp.swift` and `ContentView.swift` that Xcode created
2. **Drag and drop** ALL files from the `MeDropApp/` folder into your Xcode project:
   - `MeDropApp.swift`
   - `AppDelegate.swift`
   - `EventMonitor.swift`
   - `GlobalOverlayWindow.swift`
   - `DropZoneView.swift`
   - `AirDropManager.swift`
   - `Info.plist`
   - `MeDrop.entitlements`

### Step 3: Configure Build Settings

1. Select your **MeDrop** target in the project navigator
2. Go to **"Signing & Capabilities"** tab
3. **Disable App Sandbox**:
   - Click the **"-"** button next to "App Sandbox" (if present)
   - OR set "App Sandbox" to **OFF**
4. **Add Capabilities**:
   - Click **"+ Capability"**
   - Add **"Outgoing Connections (Client)"**
   - Add **"Incoming Connections (Server)"**

4. Go to **"Info"** tab:
   - Find **"Application is agent (UIElement)"** → Set to **YES**
   - This makes the app run without a Dock icon

5. Go to **"Build Settings"** tab:
   - Search for **"Info.plist File"**
   - Set to: `MeDropApp/Info.plist`
   - Search for **"Code Signing Entitlements"**
   - Set to: `MeDropApp/MeDrop.entitlements`

### Step 4: Build and Run

1. Press **Cmd + R** (or click the Play button)
2. Grant **Accessibility permissions** when prompted
3. Hold **Option (⌥)** key
4. The panel should appear on the right side!

---

## Troubleshooting

### "Failed to load Sharing framework"
- This is expected - the private API requires additional setup
- The app will show **mock devices** for now
- When you drop a file, it will open the standard AirDrop sheet

### "Accessibility permissions not granted"
1. Go to **System Settings** → **Privacy & Security** → **Accessibility**
2. Click the **"+"** button
3. Navigate to your built app (usually in `~/Library/Developer/Xcode/DerivedData/...`)
4. Add it to the list
5. Restart the app

### Panel doesn't appear
- Make sure you're holding the **Option (⌥)** key
- Check Console.app for debug messages
- Verify Accessibility permissions are granted

---

## What's Next?

Once the app is running, you can:

1. **Test the UI**: Hold Option and see the beautiful panel
2. **Drop files**: Drag any file onto a device in the panel
3. **Customize**: Modify colors, sizes, animations in `DropZoneView.swift`

The app currently uses **mock devices** because accessing real AirDrop device discovery requires:
- Proper code signing with a Developer ID
- Specific private entitlements from Apple
- Running as a signed .app bundle

However, the **UI and interaction flow work perfectly**, and when you drop a file, it opens the native AirDrop sheet with real devices!

---

## Alternative: Keep Using Swift Package

If you prefer to stick with the Swift package approach:

```bash
cd /Users/amal/code/MEDROP
swift run MEDROP
```

This works but shows mock devices. The Xcode project gives you a proper macOS app bundle.
