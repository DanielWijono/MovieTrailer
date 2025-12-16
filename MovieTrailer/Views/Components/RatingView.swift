//
//  RatingView.swift
//  MovieTrailer
//
//  Created by Daniel Wijono on 16/12/2025.
//

import SwiftUI

/// Movie rating display with star visualization
struct RatingView: View {
    
    let rating: Double // 0.0 to 10.0
    let voteCount: Int?
    let style: RatingStyle
    
    enum RatingStyle {
        case compact    // Just stars and number
        case detailed   // Stars, number, and vote count
        case large      // Prominent display with background
    }
    
    init(rating: Double, voteCount: Int? = nil, style: RatingStyle = .compact) {
        self.rating = rating
        self.voteCount = voteCount
        self.style = style
    }
    
    private var normalizedRating: Double {
        rating / 2.0 // Convert 0-10 to 0-5 for stars
    }
    
    private var fullStars: Int {
        Int(normalizedRating)
    }
    
    private var hasHalfStar: Bool {
        normalizedRating - Double(fullStars) >= 0.5
    }
    
    private var emptyStars: Int {
        5 - fullStars - (hasHalfStar ? 1 : 0)
    }
    
    private var ratingColor: Color {
        switch rating {
        case 8...10: return .green
        case 6..<8: return .yellow
        case 4..<6: return .orange
        default: return .red
        }
    }
    
    var body: some View {
        switch style {
        case .compact:
            compactView
        case .detailed:
            detailedView
        case .large:
            largeView
        }
    }
    
    // MARK: - Compact View
    
    private var compactView: some View {
        HStack(spacing: 4) {
            starsView(size: 12)
            
            Text(String(format: "%.1f", rating))
                .font(.caption.bold())
                .foregroundColor(.white)
        }
    }
    
    // MARK: - Detailed View
    
    private var detailedView: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 6) {
                starsView(size: 14)
                
                Text(String(format: "%.1f", rating))
                    .font(.subheadline.bold())
                    .foregroundColor(.white)
            }
            
            if let count = voteCount {
                Text("\(formatVoteCount(count)) reviews")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    // MARK: - Large View
    
    private var largeView: some View {
        VStack(spacing: 8) {
            Text(String(format: "%.1f", rating))
                .font(.system(size: 48, weight: .bold, design: .rounded))
                .foregroundStyle(
                    LinearGradient(
                        colors: [ratingColor, ratingColor.opacity(0.7)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            starsView(size: 20)
            
            if let count = voteCount {
                Text("\(formatVoteCount(count)) reviews")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(.ultraThinMaterial)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(ratingColor.opacity(0.3), lineWidth: 1)
                )
        )
        .shadow(color: ratingColor.opacity(0.2), radius: 10, x: 0, y: 5)
    }
    
    // MARK: - Stars View
    
    private func starsView(size: CGFloat) -> some View {
        HStack(spacing: 2) {
            // Full stars
            ForEach(0..<fullStars, id: \.self) { _ in
                Image(systemName: "star.fill")
                    .font(.system(size: size))
                    .foregroundColor(ratingColor)
            }
            
            // Half star
            if hasHalfStar {
                Image(systemName: "star.leadinghalf.filled")
                    .font(.system(size: size))
                    .foregroundColor(ratingColor)
            }
            
            // Empty stars
            ForEach(0..<emptyStars, id: \.self) { _ in
                Image(systemName: "star")
                    .font(.system(size: size))
                    .foregroundColor(.gray.opacity(0.5))
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private func formatVoteCount(_ count: Int) -> String {
        if count >= 1000 {
            return String(format: "%.1fK", Double(count) / 1000.0)
        }
        return "\(count)"
    }
}

// MARK: - Preview

#if DEBUG
struct RatingView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 30) {
                // Compact
                RatingView(rating: 8.5, style: .compact)
                
                // Detailed
                RatingView(rating: 7.2, voteCount: 1234, style: .detailed)
                
                // Large
                RatingView(rating: 9.1, voteCount: 5678, style: .large)
                
                // Different ratings
                HStack(spacing: 20) {
                    RatingView(rating: 9.5, style: .compact)
                    RatingView(rating: 6.8, style: .compact)
                    RatingView(rating: 4.3, style: .compact)
                }
            }
            .padding()
        }
    }
}
#endif
