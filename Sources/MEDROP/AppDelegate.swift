import Cocoa
import SwiftUI

enum ModifierKeyPreference: String {
    case option = "Option (⌥)"
    case command = "Command (⌘)"
    case control = "Control (⌃)"
    
    var eventFlag: NSEvent.ModifierFlags {
        switch self {
        case .option: return .option
        case .command: return .command
        case .control: return .control
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var overlayWindow: GlobalOverlayWindow?
    var eventMonitor: EventMonitor?
    var airDropManager: AirDropManager?
    var statusItem: NSStatusItem?
    var currentModifier: ModifierKeyPreference = .option

    func applicationDidFinishLaunching(_ notification: Notification) {
        // Create menu bar icon
        setupMenuBar()
        
        // Request accessibility permissions
        let trusted = AXIsProcessTrustedWithOptions([kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true] as CFDictionary)
        if !trusted {
            // Permissions will be requested via system dialog
        }
        
        // Initialize AirDrop Manager
        airDropManager = AirDropManager()
        
        overlayWindow = GlobalOverlayWindow(airDropManager: airDropManager!)
        
        // Start with Option key
        startEventMonitor()
    }
    
    private func startEventMonitor() {
        // Stop existing monitor if any
        eventMonitor?.stop()
        
        // Create new monitor with current modifier
        eventMonitor = EventMonitor(modifierFlag: currentModifier.eventFlag) { [weak self] isPressed in
            if isPressed {
                self?.overlayWindow?.show()
            } else {
                self?.overlayWindow?.hide()
            }
        }
        
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
        
        updateMenu()
    }
    
    private func updateMenu() {
        // Create menu
        let menu = NSMenu()
        
        // About item
        let aboutItem = NSMenuItem(title: "About MeDrop", action: #selector(showAbout), keyEquivalent: "")
        aboutItem.target = self
        menu.addItem(aboutItem)
        
        menu.addItem(NSMenuItem.separator())
        
        // Key binding submenu
        let keyBindingItem = NSMenuItem(title: "Activation Key", action: nil, keyEquivalent: "")
        let keyBindingMenu = NSMenu()
        
        // Option key
        let optionItem = NSMenuItem(title: ModifierKeyPreference.option.rawValue, action: #selector(changeToOption), keyEquivalent: "")
        optionItem.target = self
        optionItem.state = currentModifier == .option ? .on : .off
        keyBindingMenu.addItem(optionItem)
        
        // Command key
        let commandItem = NSMenuItem(title: ModifierKeyPreference.command.rawValue, action: #selector(changeToCommand), keyEquivalent: "")
        commandItem.target = self
        commandItem.state = currentModifier == .command ? .on : .off
        keyBindingMenu.addItem(commandItem)
        
        // Control key
        let controlItem = NSMenuItem(title: ModifierKeyPreference.control.rawValue, action: #selector(changeToControl), keyEquivalent: "")
        controlItem.target = self
        controlItem.state = currentModifier == .control ? .on : .off
        keyBindingMenu.addItem(controlItem)
        
        keyBindingItem.submenu = keyBindingMenu
        menu.addItem(keyBindingItem)
        
        menu.addItem(NSMenuItem.separator())
        
        // Instructions (updated with current key)
        let instructionsItem = NSMenuItem(title: "Hold \(currentModifier.rawValue) while dragging", action: nil, keyEquivalent: "")
        instructionsItem.isEnabled = false
        menu.addItem(instructionsItem)
        
        menu.addItem(NSMenuItem.separator())
        
        // Quit item
        let quitItem = NSMenuItem(title: "Quit MeDrop", action: #selector(quitApp), keyEquivalent: "q")
        quitItem.target = self
        menu.addItem(quitItem)
        
        statusItem?.menu = menu
    }
    
    @objc private func changeToOption() {
        currentModifier = .option
        startEventMonitor()
        updateMenu()
    }
    
    @objc private func changeToCommand() {
        currentModifier = .command
        startEventMonitor()
        updateMenu()
    }
    
    @objc private func changeToControl() {
        currentModifier = .control
        startEventMonitor()
        updateMenu()
    }
    
    @objc private func showAbout() {
        let alert = NSAlert()
        alert.messageText = "MeDrop"
        alert.informativeText = "Beautiful AirDrop utility for macOS\n\nVersion 1.0\n\nHold \(currentModifier.rawValue) while dragging files to show the drop zone.\n\nCreated with ❤️ for macOS"
        alert.alertStyle = .informational
        alert.addButton(withTitle: "OK")
        alert.runModal()
    }
    
    @objc private func quitApp() {
        NSApplication.shared.terminate(nil)
    }
}
