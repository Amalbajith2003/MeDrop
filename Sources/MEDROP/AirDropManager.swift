import Foundation
import Cocoa

class AirDropManager: NSObject, ObservableObject {
    @Published var discoveredPeers: [AirDropPeer] = []
    
    override init() {
        super.init()
        print("📤 AirDrop Manager initialized")
    }
    
    func openAirDrop(with url: URL) {
        openAirDrop(with: [url])
    }
    
    func openAirDrop(with urls: [URL]) {
        guard !urls.isEmpty else { return }
        
        print("📤 Opening AirDrop for \(urls.count) file(s)")
        
        // Use the standard NSSharingService to open AirDrop
        guard let service = NSSharingService(named: .sendViaAirDrop) else {
            print("❌ AirDrop service not available")
            return
        }
        
        if service.canPerform(withItems: urls) {
            service.perform(withItems: urls)
            print("✅ AirDrop sheet opened with \(urls.count) file(s)")
        } else {
            print("❌ Cannot perform AirDrop with these items")
        }
    }
}

// MARK: - Peer Model (kept for compatibility)
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
