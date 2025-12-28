import Cocoa
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    var overlayWindow: GlobalOverlayWindow?
    var eventMonitor: EventMonitor?
    var airDropManager: AirDropManager?
    var statusItem: NSStatusItem?

    func applicationDidFinishLaunching(_ notification: Notification) {
        print("MeDrop Started")
        
        // Create menu bar icon
        setupMenuBar()
        
        // request permissions check
        let trusted = AXIsProcessTrustedWithOptions([kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true] as CFDictionary)
        if !trusted {
            print("Accessibilty permissions not granted yet. Monitor might fail.")
        }
        
        // Initialize AirDrop Manager
        airDropManager = AirDropManager()
        
        overlayWindow = GlobalOverlayWindow(airDropManager: airDropManager!)
        
        eventMonitor = EventMonitor(onOptionKeyChanged: { [weak self] isPressed in
            if isPressed {
                self?.overlayWindow?.show()
            } else {
                self?.overlayWindow?.hide()
            }
        })
        
        eventMonitor?.start()
    }
    
    private func setupMenuBar() {
        // Create status item in menu bar
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        
        if let button = statusItem?.button {
            // Use SF Symbol for the icon
            button.image = NSImage(systemSymbolName: "arrow.up.doc.fill", accessibilityDescription: "MeDrop")
            button.image?.isTemplate = true
        }
        
        // Create menu
        let menu = NSMenu()
        
        // About item
        let aboutItem = NSMenuItem(title: "About MeDrop", action: #selector(showAbout), keyEquivalent: "")
        aboutItem.target = self
        menu.addItem(aboutItem)
        
        menu.addItem(NSMenuItem.separator())
        
        // Instructions
        let instructionsItem = NSMenuItem(title: "Hold Option (⌥) while dragging", action: nil, keyEquivalent: "")
        instructionsItem.isEnabled = false
        menu.addItem(instructionsItem)
        
        menu.addItem(NSMenuItem.separator())
        
        // Quit item
        let quitItem = NSMenuItem(title: "Quit MeDrop", action: #selector(quitApp), keyEquivalent: "q")
        quitItem.target = self
        menu.addItem(quitItem)
        
        statusItem?.menu = menu
    }
    
    @objc private func showAbout() {
        let alert = NSAlert()
        alert.messageText = "MeDrop"
        alert.informativeText = "Beautiful AirDrop utility for macOS\n\nVersion 1.0\n\nHold Option (⌥) while dragging files to show the drop zone.\n\nCreated with ❤️ for macOS"
        alert.alertStyle = .informational
        alert.addButton(withTitle: "OK")
        alert.runModal()
    }
    
    @objc private func quitApp() {
        NSApplication.shared.terminate(nil)
    }
}
