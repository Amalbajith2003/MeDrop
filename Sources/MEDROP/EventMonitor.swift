import Cocoa

class EventMonitor {
    private var monitor: Any?
    private let onKeyChanged: (Bool) -> Void
    private var isKeyPressed = false
    private let modifierFlag: NSEvent.ModifierFlags

    init(modifierFlag: NSEvent.ModifierFlags, onKeyChanged: @escaping (Bool) -> Void) {
        self.modifierFlag = modifierFlag
        self.onKeyChanged = onKeyChanged
    }

    func start() {
        monitor = NSEvent.addGlobalMonitorForEvents(matching: .flagsChanged) { [weak self] event in
            self?.handleEvent(event)
        }
    }

    func stop() {
        if let monitor = monitor {
            NSEvent.removeMonitor(monitor)
            self.monitor = nil
        }
    }

    private func handleEvent(_ event: NSEvent) {
        let isPressed = event.modifierFlags.contains(modifierFlag)
        
        // Debounce/Check state change to avoid repeated calls
        if isPressed != isKeyPressed {
            isKeyPressed = isPressed
            onKeyChanged(isPressed)
        }
    }
}
