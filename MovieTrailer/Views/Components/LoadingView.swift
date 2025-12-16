//
//  LoadingView.swift
//  MovieTrailer
//
//  Created by Daniel Wijono on 10/12/2025.
//

import SwiftUI

/// Loading state view with glassmorphism
struct LoadingView: View {
    
    @State private var isAnimating = false
    
    var body: some View {
        VStack(spacing: 20) {
            // Animated gradient circle
            Circle()
                .fill(
                    LinearGradient(
                        colors: [.blue, .purple, .pink],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 60, height: 60)
                .overlay(
                    Circle()
                        .stroke(Color.white.opacity(0.2), lineWidth: 2)
                )
                .rotationEffect(.degrees(isAnimating ? 360 : 0))
                .animation(
                    .linear(duration: 1.5)
                        .repeatForever(autoreverses: false),
                    value: isAnimating
                )
                .shadow(color: Color.purple.opacity(0.3), radius: 20, x: 0, y: 10)
            
            Text("Loading...")
                .font(.headline)
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            isAnimating = true
        }
    }
}

// MARK: - Preview

#if DEBUG
struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
#endif
