import Foundation
import Cocoa
import Combine

// MARK: - AirDrop Manager using Private Sharing Framework
class AirDropManager: NSObject, ObservableObject {
    @Published var discoveredPeers: [AirDropPeer] = []
    
    private var discovery: AnyObject?
    private var sharingBundle: Bundle?
    private var isDiscovering = false
    
    override init() {
        super.init()
        loadSharingFramework()
    }
    
    private func loadSharingFramework() {
        // Load the private Sharing framework
        let frameworkPath = "/System/Library/PrivateFrameworks/Sharing.framework"
        
        guard let bundle = Bundle(path: frameworkPath) else {
            print("❌ Failed to load Sharing framework at \(frameworkPath)")
            fallbackToMockDevices()
            return
        }
        
        guard bundle.load() else {
            print("❌ Failed to load Sharing framework bundle")
            fallbackToMockDevices()
            return
        }
        
        sharingBundle = bundle
        print("✅ Loaded Sharing framework")
        
        // Try to start discovery
        startDiscovery()
    }
    
    private func startDiscovery() {
        guard !isDiscovering else { return }
        
        // Try different class names that might exist
        let possibleClassNames = [
            "SFAirDropDiscovery",
            "SDAirDropDiscovery", 
            "SDStatusMonitor"
        ]
        
        var discoveryClass: AnyClass?
        for className in possibleClassNames {
            if let cls = NSClassFromString(className) {
                discoveryClass = cls
                print("✅ Found class: \(className)")
                break
            }
        }
        
        guard let discoveryClass = discoveryClass as? NSObject.Type else {
            print("❌ Could not find any AirDrop discovery class")
            print("Available classes in Sharing framework:")
            if let bundle = sharingBundle {
                // List some classes for debugging
                let classCount = objc_getClassList(nil, 0)
                if classCount > 0 {
                    let classes = UnsafeMutablePointer<AnyClass>.allocate(capacity: Int(classCount))
                    objc_getClassList(AutoreleasingUnsafeMutablePointer(classes), classCount)
                    
                    for i in 0..<min(10, Int(classCount)) {
                        let className = String(cString: class_getName(classes[i]))
                        if className.contains("AirDrop") || className.contains("SF") || className.contains("SD") {
                            print("  - \(className)")
                        }
                    }
                    classes.deallocate()
                }
            }
            fallbackToMockDevices()
            return
        }
        
        // Create discovery instance
        discovery = discoveryClass.init()
        
        // Try to set ourselves as delegate
        if discovery?.responds(to: NSSelectorFromString("setDelegate:")) == true {
            discovery?.perform(NSSelectorFromString("setDelegate:"), with: self)
            print("✅ Set delegate")
        }
        
        // Try to start discovery
        if discovery?.responds(to: NSSelectorFromString("start")) == true {
            discovery?.perform(NSSelectorFromString("start"))
            isDiscovering = true
            print("✅ Started AirDrop discovery")
        } else if discovery?.responds(to: NSSelectorFromString("activate")) == true {
            discovery?.perform(NSSelectorFromString("activate"))
            isDiscovering = true
            print("✅ Activated AirDrop discovery")
        } else {
            print("❌ Could not start discovery")
            fallbackToMockDevices()
        }
    }
    
    private func fallbackToMockDevices() {
        print("⚠️ Using mock devices for UI demonstration")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.discoveredPeers = [
                AirDropPeer(identifier: "mock-1", name: "iPhone 15 Pro", peer: NSObject()),
                AirDropPeer(identifier: "mock-2", name: "iPad Air", peer: NSObject()),
                AirDropPeer(identifier: "mock-3", name: "MacBook Pro", peer: NSObject())
            ]
        }
    }
    
    func sendFile(_ url: URL, to peer: AirDropPeer) {
        print("📤 Sending \(url.lastPathComponent) to \(peer.name)")
        
        // If it's a mock device, use standard sharing service
        if peer.identifier.starts(with: "mock-") {
            useStandardAirDrop(url: url)
            return
        }
        
        // Try to use SFAirDropTransfer for real devices
        guard let transferClass = NSClassFromString("SFAirDropTransfer") as? NSObject.Type else {
            print("⚠️ SFAirDropTransfer not available, using standard service")
            useStandardAirDrop(url: url)
            return
        }
        
        let transfer = transferClass.init()
        
        // Set items
        if transfer.responds(to: NSSelectorFromString("setItems:")) {
            transfer.perform(NSSelectorFromString("setItems:"), with: [url])
        }
        
        // Set recipient
        if transfer.responds(to: NSSelectorFromString("setRecipient:")) {
            transfer.perform(NSSelectorFromString("setRecipient:"), with: peer.peer)
        }
        
        // Start transfer
        if transfer.responds(to: NSSelectorFromString("start")) {
            transfer.perform(NSSelectorFromString("start"))
            print("✅ Started transfer")
        } else {
            useStandardAirDrop(url: url)
        }
    }
    
    private func useStandardAirDrop(url: URL) {
        guard let service = NSSharingService(named: .sendViaAirDrop) else {
            print("❌ AirDrop service not available")
            return
        }
        
        if service.canPerform(withItems: [url]) {
            service.perform(withItems: [url])
        }
    }
    
    deinit {
        if discovery?.responds(to: NSSelectorFromString("stop")) == true {
            discovery?.perform(NSSelectorFromString("stop"))
        }
    }
}

// MARK: - Dynamic Delegate Methods
extension AirDropManager {
    @objc func discoveredPeer(_ peer: AnyObject) {
        print("✅ Discovered peer: \(peer)")
        
        var name = "Unknown Device"
        var identifier = UUID().uuidString
        
        // Try to extract information using KVC
        if let displayName = peer.value(forKey: "displayName") as? String {
            name = displayName
        } else if let realName = peer.value(forKey: "name") as? String {
            name = realName
        }
        
        if let peerID = peer.value(forKey: "identifier") as? String {
            identifier = peerID
        } else if let peerID = peer.value(forKey: "uniqueID") as? String {
            identifier = peerID
        }
        
        let airDropPeer = AirDropPeer(identifier: identifier, name: name, peer: peer)
        
        DispatchQueue.main.async {
            if !self.discoveredPeers.contains(where: { $0.identifier == identifier }) {
                self.discoveredPeers.append(airDropPeer)
                print("✅ Added peer: \(name)")
            }
        }
    }
    
    @objc func lostPeer(_ peer: AnyObject) {
        print("❌ Lost peer: \(peer)")
        
        var identifier = ""
        if let peerID = peer.value(forKey: "identifier") as? String {
            identifier = peerID
        } else if let peerID = peer.value(forKey: "uniqueID") as? String {
            identifier = peerID
        }
        
        DispatchQueue.main.async {
            self.discoveredPeers.removeAll { $0.identifier == identifier }
        }
    }
}

// MARK: - Peer Model
struct AirDropPeer: Identifiable, Hashable {
    let id = UUID()
    let identifier: String
    let name: String
    let peer: AnyObject
    
    static func == (lhs: AirDropPeer, rhs: AirDropPeer) -> Bool {
        lhs.identifier == rhs.identifier
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
}
