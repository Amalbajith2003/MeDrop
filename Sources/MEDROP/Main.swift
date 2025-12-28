import SwiftUI
import AppKit

@main
struct MeDropApp {
    static func main() {
        let app = NSApplication.shared
        let delegate = AppDelegate()
        app.delegate = delegate
        app.setActivationPolicy(.accessory) // Hide from Dock
        app.run()
    }
}
