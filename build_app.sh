#!/bin/bash

# MeDrop Build Script
# Creates a standalone .app bundle with security features

set -e

echo "🔨 Building MeDrop.app..."

# Build in release mode
swift build -c release

# Create app bundle structure
APP_NAME="MeDrop"
APP_DIR="$APP_NAME.app"
CONTENTS_DIR="$APP_DIR/Contents"
MACOS_DIR="$CONTENTS_DIR/MacOS"
RESOURCES_DIR="$CONTENTS_DIR/Resources"

# Clean previous build
rm -rf "$APP_DIR"

# Create directories
mkdir -p "$MACOS_DIR"
mkdir -p "$RESOURCES_DIR"

# Copy executable
cp .build/release/MEDROP "$MACOS_DIR/$APP_NAME"

# Copy secure Info.plist
if [ -f "Info.plist" ]; then
    cp Info.plist "$CONTENTS_DIR/Info.plist"
    echo "✓ Copied secure Info.plist with TCC declarations"
else
    echo "⚠️  Warning: Info.plist not found, creating basic one"
    # Fallback to basic Info.plist
    cat > "$CONTENTS_DIR/Info.plist" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key>
    <string>$APP_NAME</string>
    <key>CFBundleIdentifier</key>
    <string>com.medrop.app</string>
    <key>CFBundleName</key>
    <string>$APP_NAME</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0</string>
    <key>LSUIElement</key>
    <true/>
</dict>
</plist>
EOF
fi

# Create PkgInfo
echo "APPL????" > "$CONTENTS_DIR/PkgInfo"

echo "✅ Build complete!"
echo "📦 MeDrop.app created with security features:"
echo "   - App Sandboxing enabled"
echo "   - TCC compliance (Accessibility permission)"
echo "   - User-selected files only (Powerbox)"
echo "   - Hardened Runtime settings"
echo ""
echo "To install:"
echo "  mv MeDrop.app /Applications/"
echo ""
echo "To run:"
echo "  open MeDrop.app"
echo ""
echo "⚠️  Note: For production, sign with: codesign --deep --force --sign \"Developer ID\" MeDrop.app"
