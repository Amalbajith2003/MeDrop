import SwiftUI
import AppKit

struct DropZoneView: View {
    weak var window: NSPanel?
    @ObservedObject var airDropManager: AirDropManager
    @State private var draggedFile: URL?
    @State private var hoveredPeerId: UUID?

    init(window: NSPanel?, airDropManager: AirDropManager) {
        self.window = window
        self.airDropManager = airDropManager
    }

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Image(systemName: "wifi.circle.fill")
                    .font(.system(size: 20))
                    .foregroundStyle(.blue)
                
                Text("AirDrop")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(.white)
            }
            .padding(.top, 20)
            .padding(.bottom, 10)
            
            Divider()
                .background(Color.white.opacity(0.2))
                .padding(.horizontal, 10)
            
            // Devices List
            ScrollView {
                if airDropManager.discoveredPeers.isEmpty {
                    VStack(spacing: 12) {
                        ProgressView()
                            .scaleEffect(0.8)
                            .tint(.white)
                        
                        Text("Searching for devices...")
                            .font(.system(size: 13))
                            .foregroundStyle(.white.opacity(0.7))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 40)
                } else {
                    VStack(spacing: 8) {
                        ForEach(airDropManager.discoveredPeers) { peer in
                            DeviceRow(
                                peer: peer,
                                isHovered: hoveredPeerId == peer.id,
                                onDrop: { url in
                                    handleDrop(url: url, peer: peer)
                                },
                                onHover: { isHovered in
                                    hoveredPeerId = isHovered ? peer.id : nil
                                }
                            )
                        }
                    }
                    .padding(.vertical, 12)
                    .padding(.horizontal, 8)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.ultraThinMaterial)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.white.opacity(0.3), lineWidth: 2)
        )
        .padding(8)
        .onDrop(of: [.fileURL], isTargeted: nil) { providers in
            // Capture the dragged file
            providers.first?.loadItem(forTypeIdentifier: "public.file-url", options: nil) { (urlData, error) in
                guard let data = urlData as? Data,
                      let url = URL(dataRepresentation: data, relativeTo: nil) else { return }
                
                DispatchQueue.main.async {
                    self.draggedFile = url
                }
            }
            return false // Don't consume the drop here
        }
    }
    
    private func handleDrop(url: URL, peer: AirDropPeer) {
        print("📤 Sending \(url.lastPathComponent) to \(peer.name)")
        airDropManager.sendFile(url, to: peer)
        
        // Hide window after drop
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.window?.orderOut(nil)
            self.draggedFile = nil
        }
    }
}

struct DeviceRow: View {
    let peer: AirDropPeer
    let isHovered: Bool
    let onDrop: (URL) -> Void
    let onHover: (Bool) -> Void
    
    @State private var isTargeted = false
    
    var body: some View {
        HStack(spacing: 12) {
            // Device Icon
            ZStack {
                Circle()
                    .fill(isTargeted ? Color.blue.opacity(0.3) : Color.white.opacity(0.1))
                    .frame(width: 44, height: 44)
                
                Image(systemName: deviceIcon)
                    .font(.system(size: 20))
                    .foregroundStyle(isTargeted ? .blue : .white)
            }
            
            // Device Name
            Text(peer.name)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(.white)
                .lineLimit(1)
            
            Spacer()
            
            // Drop indicator
            if isTargeted {
                Image(systemName: "arrow.down.circle.fill")
                    .font(.system(size: 18))
                    .foregroundStyle(.blue)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(isTargeted ? Color.blue.opacity(0.2) : Color.white.opacity(isHovered ? 0.1 : 0.05))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(isTargeted ? Color.blue : Color.clear, lineWidth: 2)
        )
        .onDrop(of: [.fileURL], isTargeted: $isTargeted) { providers in
            providers.first?.loadItem(forTypeIdentifier: "public.file-url", options: nil) { (urlData, error) in
                guard let data = urlData as? Data,
                      let url = URL(dataRepresentation: data, relativeTo: nil) else { return }
                
                DispatchQueue.main.async {
                    onDrop(url)
                }
            }
            return true
        }
        .onHover { hovering in
            onHover(hovering)
        }
    }
    
    private var deviceIcon: String {
        let name = peer.name.lowercased()
        if name.contains("iphone") {
            return "iphone"
        } else if name.contains("ipad") {
            return "ipad"
        } else if name.contains("mac") || name.contains("macbook") {
            return "laptopcomputer"
        } else if name.contains("watch") {
            return "applewatch"
        } else {
            return "display"
        }
    }
}
