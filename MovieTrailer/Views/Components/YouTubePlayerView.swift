//
//  YouTubePlayerView.swift
//  MovieTrailer
//
//  Created by Daniel Wijono on 14/12/2025.
//

import SwiftUI
import WebKit

/// YouTube video player using WKWebView with iframe embed
struct YouTubePlayerView: UIViewRepresentable {
    
    let videoKey: String
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        configuration.mediaTypesRequiringUserActionForPlayback = []
        
        // Enable debugging (optional)
        #if DEBUG
        if #available(iOS 16.4, *) {
            configuration.preferences.isInspectable = true
        }
        #endif
        
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.scrollView.isScrollEnabled = false
        webView.backgroundColor = .black
        webView.isOpaque = false
        webView.navigationDelegate = context.coordinator
        
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        // Load YouTube iframe HTML
        let html = """
        <!DOCTYPE html>
        <html>
        <head>
            <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
            <style>
                * {
                    margin: 0;
                    padding: 0;
                    box-sizing: border-box;
                }
                body {
                    background-color: #000;
                    overflow: hidden;
                }
                .video-container {
                    position: relative;
                    width: 100%;
                    padding-bottom: 56.25%; /* 16:9 aspect ratio */
                    height: 0;
                }
                .video-container iframe {
                    position: absolute;
                    top: 0;
                    left: 0;
                    width: 100%;
                    height: 100%;
                    border: 0;
                }
            </style>
        </head>
        <body>
            <div class="video-container">
                <iframe 
                    src="https://www.youtube.com/embed/\(videoKey)?playsinline=1&autoplay=1&rel=0&modestbranding=1&controls=1&showinfo=0&fs=1"
                    allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
                    allowfullscreen>
                </iframe>
            </div>
        </body>
        </html>
        """
        
        webView.loadHTMLString(html, baseURL: URL(string: "https://www.youtube.com"))
    }
    
    // MARK: - Coordinator
    
    class Coordinator: NSObject, WKNavigationDelegate {
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            print("✅ YouTube player loaded successfully")
        }
        
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            print("❌ YouTube player failed to load: \(error.localizedDescription)")
        }
        
        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            print("❌ YouTube player provisional navigation failed: \(error.localizedDescription)")
        }
    }
}

// MARK: - Trailer Player Sheet

/// Full-screen trailer player view
struct TrailerPlayerView: View {
    
    let video: Video
    let onClose: () -> Void
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            // Black background
            Color.black
                .ignoresSafeArea()
            
            // YouTube player
            if video.isYouTube {
                YouTubePlayerView(videoKey: video.key)
                    .aspectRatio(16/9, contentMode: .fit)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                // Fallback for non-YouTube videos
                ContentUnavailableView(
                    "Video Not Available",
                    systemImage: "video.slash",
                    description: Text("This video cannot be played in the app")
                )
            }
            
            // Close button
            Button(action: onClose) {
                Image(systemName: "xmark.circle.fill")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding()
                    .background(
                        Circle()
                            .fill(.ultraThinMaterial)
                    )
            }
            .padding()
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
