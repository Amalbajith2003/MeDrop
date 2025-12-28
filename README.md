# MeDrop 📤

> A beautiful, minimalistic macOS utility that brings instant AirDrop access to your workflow.

![macOS](https://img.shields.io/badge/macOS-12.0+-blue.svg)
![Swift](https://img.shields.io/badge/Swift-5.0+-orange.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)

## ✨ What is MeDrop?

MeDrop is a sleek macOS utility that revolutionizes how you use AirDrop. Simply hold the **Option (⌥)** key while dragging files, and a beautiful pill-shaped panel appears on your screen edge. Drop files into it, manage them visually, and send them all at once with a single click.

### 🎯 Key Features

- **🎨 Minimalistic Design** - Clean, Apple-style UI that feels native to macOS
- **📁 File Management** - Drop multiple files, see them listed with icons and names
- **🗑️ Individual Removal** - Hover over any file to remove it specifically
- **📤 Batch Sending** - Send all files to AirDrop at once
- **🖥️ Multi-Monitor Support** - Automatically appears on the display where your mouse is
- **⌨️ Simple Activation** - Just hold Option (⌥) while dragging
- **🔄 Smart Icons** - Automatically detects file types (photos, videos, PDFs, etc.)
- **📜 Scrollable List** - Handles many files gracefully

## 🚀 Quick Start

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/yourusername/MeDrop.git
   cd MeDrop
   ```

2. **Run the app:**
   ```bash
   swift run MEDROP
   ```

3. **Grant Accessibility Permissions:**
   - The app will prompt you to grant accessibility permissions
   - Go to System Settings → Privacy & Security → Accessibility
   - Enable MeDrop

### Usage

1. **Start MeDrop** - Run the app (it sits in the background)
2. **Drag a file** - From Finder, Desktop, or any app
3. **Hold Option (⌥)** - While dragging, the pill appears on the right edge
4. **Drop files** - Drop one or multiple files into the pill
5. **Manage files** - Hover over files to see remove buttons
6. **Send** - Click the blue "SEND" button to open AirDrop

## 🎨 Screenshots

### Empty State
The pill appears when you hold Option while dragging:
```
┌──────────────────┐
│       ➕         │  ← Drop zone
│                  │
│      DROP        │  ← Instructions
│                  │
│        •         │  ← Indicator
└──────────────────┘
```

### With Files
Files appear in a scrollable list:
```
┌──────────────────┐
│       📄         │  ← Files icon
│        3         │  ← File count
│  ──────────────  │
│ 📷 photo.jpg  ❌ │  ← Hover to remove
│ 📄 doc.pdf    ❌ │
│ 🎬 video.mp4  ❌ │
│                  │
│    📤 SEND       │  ← Send button
└──────────────────┘
```

## 🛠️ Technical Details

### Architecture

- **Language:** Swift 5.0+
- **UI Framework:** SwiftUI
- **Window Management:** AppKit (NSPanel)
- **Event Monitoring:** Global keyboard event monitoring
- **File Handling:** NSItemProvider, NSSharingService

### Project Structure

```
MeDrop/
├── Sources/
│   └── MEDROP/
│       ├── main.swift              # Entry point
│       ├── AppDelegate.swift       # App lifecycle & event monitoring
│       ├── GlobalOverlayWindow.swift # Floating panel window
│       ├── DropZoneView.swift      # Main UI with file list
│       ├── AirDropManager.swift    # AirDrop integration
│       └── EventMonitor.swift      # Keyboard event monitoring
├── Package.swift                   # Swift Package Manager config
└── README.md
```

### Key Components

#### 1. **Event Monitor**
- Monitors Option (⌥) key globally
- Triggers panel show/hide
- Non-intrusive background monitoring

#### 2. **Global Overlay Window**
- Floating NSPanel that stays on top
- Positioned on screen edge
- Multi-monitor aware
- Transparent, borderless design

#### 3. **Drop Zone View**
- SwiftUI-based UI
- File drop handling
- Scrollable file list
- Interactive file management

#### 4. **AirDrop Manager**
- Integrates with macOS NSSharingService
- Handles single or multiple files
- Opens system AirDrop picker

## 🎯 Features in Detail

### File Type Detection
MeDrop automatically shows appropriate icons for:
- 📷 **Images** - jpg, png, heic, gif, webp
- 🎬 **Videos** - mp4, mov, avi, mkv
- 📄 **PDFs** - pdf
- 🗜️ **Archives** - zip, rar, 7z
- 📝 **Text** - txt, md
- 📄 **Generic** - All other files

### Multi-Monitor Support
The pill intelligently appears on whichever display your mouse is currently on, perfect for multi-monitor setups.

### File Management
- **Add files** - Drop multiple files, they accumulate
- **View files** - See file names and icons in a list
- **Remove files** - Hover over any file, click the red X
- **Send all** - One button sends everything at once

## ⚙️ Configuration

### Changing the Activation Key

Currently uses Option (⌥). To change to another key, edit `EventMonitor.swift`:

```swift
// Change this line:
let isOption = event.modifierFlags.contains(.option)

// To use Command instead:
let isCommand = event.modifierFlags.contains(.command)
```

### Adjusting Panel Size

Edit `GlobalOverlayWindow.swift` and `DropZoneView.swift`:

```swift
// Current size: 100px × 320px
let width: CGFloat = 100
let height: CGFloat = 320
```

## 🔮 Roadmap

- [ ] Menu bar icon with preferences
- [ ] Customizable position (left/right edge)
- [ ] Keyboard shortcuts
- [ ] Sound effects
- [ ] Drag preview thumbnails
- [ ] Recent devices quick access
- [ ] Theme customization
- [ ] App Store distribution

## 🤝 Contributing

Contributions are welcome! Feel free to:
- Report bugs
- Suggest features
- Submit pull requests

## 📝 Requirements

- macOS 12.0 or later
- Swift 5.0+
- Xcode 13.0+ (for development)

## 🐛 Known Issues

- Requires Accessibility permissions to monitor keyboard events
- Uses system AirDrop (requires nearby devices to have AirDrop enabled)

## � License

MIT License - See LICENSE file for details

## 🙏 Acknowledgments

- Inspired by macOS's native AirDrop functionality
- Built with SwiftUI and AppKit
- Designed with Apple's Human Interface Guidelines in mind

## 💡 Tips

- **Keep it running** - MeDrop works best when running in the background
- **Multiple files** - You can drop files one by one or all at once
- **Quick clear** - Hover and click X on individual files to remove them
- **Multi-monitor** - The pill follows your mouse to the correct screen

---

**Made with ❤️ for macOS users who love efficiency**

For questions or support, please open an issue on GitHub.
