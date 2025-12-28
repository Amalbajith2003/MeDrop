#!/bin/bash

# Create Xcode project for MeDrop

echo "Creating MeDrop Xcode project..."

cd "$(dirname "$0")"

# Create project using xcodebuild
xcodebuild -create-xcodeproj \
    -name MeDrop \
    -organization "MeDrop" \
    -bundleID com.medrop.app \
    -language swift \
    -platform macos \
    -deploymentTarget 12.0

echo "✅ Xcode project created!"
echo ""
echo "Next steps:"
echo "1. Open MeDrop.xcodeproj in Xcode"
echo "2. Add all .swift files from MeDropApp/ to the project"
echo "3. Set Info.plist and Entitlements in Build Settings"
echo "4. Build and run!"
