import Cocoa

class EventMonitor {
    private var monitor: Any?
    private let onOptionKeyChanged: (Bool) -> Void
    private var isOptionPressed = false

    init(onOptionKeyChanged: @escaping (Bool) -> Void) {
        self.onOptionKeyChanged = onOptionKeyChanged
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
        let isOption = event.modifierFlags.contains(.option)
        
        // Debounce/Check state change to avoid repeated calls
        if isOption != isOptionPressed {
            isOptionPressed = isOption
            onOptionKeyChanged(isOption)
        }
    }
}
