import Cocoa
import SwiftUI

class GlobalOverlayWindow: NSPanel {
    init(airDropManager: AirDropManager) {
        super.init(
            contentRect: NSRect(x: 0, y: 0, width: 300, height: 600), // Default size, will be resized
            styleMask: [.nonactivatingPanel, .borderless, .hudWindow], 
            backing: .buffered,
            defer: false
        )
        
        self.level = .floating
        self.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        self.backgroundColor = .clear
        self.isOpaque = false
        self.hasShadow = false
        
        // Position on the right side
        self.setFrame(self.calculateFrame(), display: true)
        
        // Content
        let hostingView = NSHostingView(rootView: DropZoneView(window: self, airDropManager: airDropManager))
        self.contentView = hostingView
    }
    
    private func calculateFrame() -> NSRect {
        guard let screen = NSScreen.main else { return NSRect.zero }
        let screenRect = screen.visibleFrame
        let width: CGFloat = 120
        let height: CGFloat = 300
        
        let x = screenRect.maxX - width
        let y = screenRect.midY - (height / 2)
        
        return NSRect(x: x, y: y, width: width, height: height)
    }
    
    func show() {
        self.orderFront(nil)
    }
    
    func hide() {
        self.orderOut(nil)
    }
}
