import SwiftUI
import AppKit

struct DropZoneView: View {
    weak var window: NSPanel?
    @ObservedObject var airDropManager: AirDropManager
    @State private var isTargeted = false
    @State private var droppedFiles: [URL] = []
    @State private var isHoveringButton = false
    @State private var hoveredFileURL: URL?

    init(window: NSPanel?, airDropManager: AirDropManager) {
        self.window = window
        self.airDropManager = airDropManager
    }

    var body: some View {
        ZStack {
            // Clean background with subtle material
            RoundedRectangle(cornerRadius: 24)
                .fill(.ultraThinMaterial)
                .environment(\.colorScheme, .dark)
            
            // Subtle inner shadow for depth
            RoundedRectangle(cornerRadius: 24)
                .fill(
                    LinearGradient(
                        colors: [
                            Color.black.opacity(0.05),
                            Color.clear,
                            Color.white.opacity(0.05)
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
            
            // Content
            VStack(spacing: 12) {
                // Top icon
                ZStack {
                    // Subtle glow when targeted
                    if isTargeted {
                        Circle()
                            .fill(
                                RadialGradient(
                                    colors: [
                                        Color.blue.opacity(0.3),
                                        Color.clear
                                    ],
                                    center: .center,
                                    startRadius: 5,
                                    endRadius: 30
                                )
                            )
                            .frame(width: 60, height: 60)
                            .blur(radius: 8)
                    }
                    
                    // Icon
                    Image(systemName: droppedFiles.isEmpty ? "plus.circle" : "doc.on.doc.fill")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(droppedFiles.isEmpty ? (isTargeted ? .blue : .white) : .blue)
                        .scaleEffect(isTargeted ? 1.1 : 1.0)
                        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isTargeted)
                }
                .padding(.top, 16)
                
                // File count badge
                if !droppedFiles.isEmpty {
                    Text("\(droppedFiles.count)")
                        .font(.system(size: 11, weight: .semibold, design: .rounded))
                        .foregroundStyle(.white.opacity(0.7))
                }
                
                Divider()
                    .background(Color.white.opacity(0.1))
                    .padding(.horizontal, 8)
                
                // Files list or drop text
                if droppedFiles.isEmpty {
                    Spacer()
                    
                    VStack(spacing: 2) {
                        ForEach(Array("DROP"), id: \.self) { char in
                            Text(String(char))
                                .font(.system(size: 11, weight: .medium, design: .rounded))
                                .foregroundStyle(.white.opacity(isTargeted ? 0.9 : 0.6))
                        }
                    }
                    
                    Spacer()
                } else {
                    // Scrollable file list
                    ScrollView {
                        VStack(spacing: 4) {
                            ForEach(droppedFiles, id: \.self) { fileURL in
                                FileItemView(
                                    fileURL: fileURL,
                                    isHovered: hoveredFileURL == fileURL,
                                    onRemove: {
                                        removeFile(fileURL)
                                    },
                                    onHover: { hovering in
                                        hoveredFileURL = hovering ? fileURL : nil
                                    }
                                )
                            }
                        }
                        .padding(.horizontal, 6)
                        .padding(.vertical, 4)
                    }
                    .frame(maxHeight: 140)
                }
                
                // Send button
                if !droppedFiles.isEmpty {
                    Button(action: {
                        sendFiles()
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "paperplane.fill")
                                .font(.system(size: 12, weight: .medium))
                            
                            Text("SEND")
                                .font(.system(size: 10, weight: .bold, design: .rounded))
                        }
                        .foregroundStyle(.white)
                        .frame(width: 50, height: 32)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(isHoveringButton ? Color.blue : Color.blue.opacity(0.8))
                        )
                    }
                    .buttonStyle(.plain)
                    .onHover { hovering in
                        isHoveringButton = hovering
                    }
                    .padding(.bottom, 12)
                } else {
                    Circle()
                        .fill(isTargeted ? Color.blue : Color.white.opacity(0.3))
                        .frame(width: 4, height: 4)
                        .padding(.bottom, 16)
                }
            }
        }
        .frame(width: 100, height: 320)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .strokeBorder(
                    isTargeted ? 
                        Color.blue.opacity(0.5) : 
                        Color.white.opacity(0.15),
                    lineWidth: 0.5
                )
        )
        .shadow(
            color: isTargeted ? 
                Color.blue.opacity(0.2) : 
                Color.black.opacity(0.3),
            radius: isTargeted ? 20 : 12,
            x: -4,
            y: 0
        )
        .onDrop(of: [.fileURL], isTargeted: $isTargeted) { providers in
            handleDrop(providers: providers)
            return true
        }
    }
    
    private func handleDrop(providers: [NSItemProvider]) {
        for provider in providers {
            provider.loadItem(forTypeIdentifier: "public.file-url", options: nil) { (urlData, error) in
                guard let data = urlData as? Data,
                      let url = URL(dataRepresentation: data, relativeTo: nil) else { return }
                
                DispatchQueue.main.async {
                    if !self.droppedFiles.contains(url) {
                        self.droppedFiles.append(url)
                    }
                }
            }
        }
    }
    
    private func sendFiles() {
        guard !droppedFiles.isEmpty else { return }
        airDropManager.openAirDrop(with: droppedFiles)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.droppedFiles.removeAll()
            self.window?.orderOut(nil)
        }
    }
    
    private func removeFile(_ url: URL) {
        droppedFiles.removeAll { $0 == url }
    }
}

// MARK: - File Item View
struct FileItemView: View {
    let fileURL: URL
    let isHovered: Bool
    let onRemove: () -> Void
    let onHover: (Bool) -> Void
    
    var body: some View {
        HStack(spacing: 4) {
            // File icon
            Image(systemName: fileIcon)
                .font(.system(size: 10))
                .foregroundStyle(.white.opacity(0.6))
                .frame(width: 12)
            
            // File name (truncated)
            Text(fileName)
                .font(.system(size: 10, weight: .medium))
                .foregroundStyle(.white.opacity(isHovered ? 0.9 : 0.7))
                .lineLimit(1)
                .truncationMode(.middle)
            
            Spacer(minLength: 2)
            
            // Remove button (shows on hover)
            if isHovered {
                Button(action: onRemove) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 10))
                        .foregroundStyle(.red.opacity(0.8))
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 6)
        .padding(.vertical, 4)
        .background(
            RoundedRectangle(cornerRadius: 6)
                .fill(isHovered ? Color.white.opacity(0.1) : Color.clear)
        )
        .onHover { hovering in
            onHover(hovering)
        }
    }
    
    private var fileName: String {
        fileURL.lastPathComponent
    }
    
    private var fileIcon: String {
        let ext = fileURL.pathExtension.lowercased()
        switch ext {
        case "jpg", "jpeg", "png", "gif", "heic", "webp":
            return "photo"
        case "mp4", "mov", "avi", "mkv":
            return "video"
        case "pdf":
            return "doc.text"
        case "zip", "rar", "7z":
            return "doc.zipper"
        case "txt", "md":
            return "doc.plaintext"
        default:
            return "doc"
        }
    }
}


