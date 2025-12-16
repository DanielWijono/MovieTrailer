//
//  GlassBackgroundView.swift
//  MovieTrailer
//
//  Created by Daniel Wijono on 16/12/2025.
//

import SwiftUI

/// Glassmorphism background view with animated gradient
struct GlassBackgroundView: View {
    
    @State private var animateGradient = false
    
    var body: some View {
        ZStack {
            // Dark base
            Color.black
                .ignoresSafeArea()
            
            // Animated gradient blobs
            GeometryReader { geometry in
                ZStack {
                    // Blob 1 - Top Left
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [.purple.opacity(0.3), .blue.opacity(0.2)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: geometry.size.width * 0.7)
                        .offset(
                            x: animateGradient ? -100 : -150,
                            y: animateGradient ? -50 : -100
                        )
                        .blur(radius: 60)
                    
                    // Blob 2 - Bottom Right
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [.blue.opacity(0.3), .cyan.opacity(0.2)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: geometry.size.width * 0.6)
                        .offset(
                            x: animateGradient ? geometry.size.width - 50 : geometry.size.width,
                            y: animateGradient ? geometry.size.height - 100 : geometry.size.height - 50
                        )
                        .blur(radius: 60)
                    
                    // Blob 3 - Center
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [.pink.opacity(0.2), .purple.opacity(0.3)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(width: geometry.size.width * 0.5)
                        .offset(
                            x: animateGradient ? geometry.size.width / 2 + 50 : geometry.size.width / 2 - 50,
                            y: animateGradient ? geometry.size.height / 2 - 100 : geometry.size.height / 2 + 50
                        )
                        .blur(radius: 70)
                }
            }
            .ignoresSafeArea()
        }
        .onAppear {
            withAnimation(
                .easeInOut(duration: 8)
                    .repeatForever(autoreverses: true)
            ) {
                animateGradient = true
            }
        }
    }
}

// MARK: - Glass Card Modifier

/// Glassmorphism card effect modifier
struct GlassCardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(.ultraThinMaterial)
            .background(
                LinearGradient(
                    colors: [
                        Color.white.opacity(0.1),
                        Color.white.opacity(0.05)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.2),
                                Color.white.opacity(0.05)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 10)
    }
}

extension View {
    /// Apply glassmorphism card effect
    func glassCard() -> some View {
        modifier(GlassCardModifier())
    }
}

// MARK: - Preview

#if DEBUG
struct GlassBackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            GlassBackgroundView()
            
            VStack(spacing: 20) {
                Text("Glassmorphism")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                    .padding()
                    .glassCard()
                
                VStack(spacing: 12) {
                    Text("Card Title")
                        .font(.headline)
                    Text("This is a glass card with premium design")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding()
                .glassCard()
            }
            .padding()
        }
    }
}
#endif
