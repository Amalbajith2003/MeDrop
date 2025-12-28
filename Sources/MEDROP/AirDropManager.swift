import Foundation
import Cocoa

final class AirDropManager: ObservableObject {
    
    func openAirDrop(with url: URL) {
        openAirDrop(with: [url])
    }
    
    func openAirDrop(with urls: [URL]) {
        guard !urls.isEmpty else { return }
        
        guard let service = NSSharingService(named: .sendViaAirDrop),
              service.canPerform(withItems: urls) else {
            return
        }
        
        service.perform(withItems: urls)
    }
}
