import Cocoa
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    var overlayWindow: GlobalOverlayWindow?
    var eventMonitor: EventMonitor?
    var airDropManager: AirDropManager?

    func applicationDidFinishLaunching(_ notification: Notification) {
        print("MeDrop Started")
        
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
}
