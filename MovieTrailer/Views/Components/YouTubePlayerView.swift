//
//  YouTubePlayerView.swift
//  MovieTrailer
//
//  Created by Daniel Wijono on 14/12/2025.
//

import SwiftUI
import SafariServices

/// YouTube trailer player using SFSafariViewController (in-app browser)
/// This bypasses YouTube embedding restrictions and works with all videos
struct TrailerPlayerView: UIViewControllerRepresentable {
    
    let video: Video
    let onClose: () -> Void
    
    func makeUIViewController(context: Context) -> SFSafariViewController {
        guard let url = video.youtubeURL else {
            // Fallback URL if something goes wrong
            return SFSafariViewController(url: URL(string: "https://www.youtube.com")!)
        }
        
        print("🎬 TrailerPlayerView: Opening YouTube URL: \(url.absoluteString)")
        
        let config = SFSafariViewController.Configuration()
        config.entersReaderIfAvailable = false
        config.barCollapsingEnabled = true
        
        let safariVC = SFSafariViewController(url: url, configuration: config)
        safariVC.preferredBarTintColor = .black
        safariVC.preferredControlTintColor = .white
        safariVC.dismissButtonStyle = .close
        safariVC.delegate = context.coordinator
        
        return safariVC
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {
        // No updates needed
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(onClose: onClose)
    }
    
    class Coordinator: NSObject, SFSafariViewControllerDelegate {
        let onClose: () -> Void
        
        init(onClose: @escaping () -> Void) {
            self.onClose = onClose
        }
        
        func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
            print("🎬 TrailerPlayerView: Safari dismissed")
            onClose()
        }
    }
}

// MARK: - Preview

#if DEBUG
struct TrailerPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        TrailerPlayerView(
            video: .sample,
            onClose: {}
        )
    }
}
#endif
