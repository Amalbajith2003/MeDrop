import Cocoa
import SwiftUI

class GlobalOverlayWindow: NSPanel {
    init(airDropManager: AirDropManager) {
        super.init(
            contentRect: NSRect(x: 0, y: 0, width: 100, height: 320),
            styleMask: [.nonactivatingPanel, .borderless, .hudWindow], 
            backing: .buffered,
            defer: false
        )
        
        self.level = .floating
        self.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        self.backgroundColor = .clear
        self.isOpaque = false
        self.hasShadow = false
        
        // Content
        let hostingView = NSHostingView(rootView: DropZoneView(window: self, airDropManager: airDropManager))
        self.contentView = hostingView
    }
    
    private func calculateFrame() -> NSRect {
        // Get the screen where the mouse is currently located
        let mouseLocation = NSEvent.mouseLocation
        guard let screen = NSScreen.screens.first(where: { NSMouseInRect(mouseLocation, $0.frame, false) }) else {
            // Fallback to main screen if mouse screen not found
            guard let mainScreen = NSScreen.main else { return NSRect.zero }
            return calculateFrameForScreen(mainScreen)
        }
        
        return calculateFrameForScreen(screen)
    }
    
    private func calculateFrameForScreen(_ screen: NSScreen) -> NSRect {
        let screenRect = screen.visibleFrame
        let width: CGFloat = 100
        let height: CGFloat = 320
        
        let x = screenRect.maxX - width
        let y = screenRect.midY - (height / 2)
        
        return NSRect(x: x, y: y, width: width, height: height)
    }
    
    func show() {
        // Recalculate position based on current mouse location
        self.setFrame(self.calculateFrame(), display: true)
        self.orderFront(nil)
    }
    
    func hide() {
        self.orderOut(nil)
    }
}
